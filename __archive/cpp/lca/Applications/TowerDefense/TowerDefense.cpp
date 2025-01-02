#include "System.h"
#include "TowerDefense.h"

ApplicationObject<TowerDefenseView, TowerDefenseModel> appTowerDefense("TowerDefense", "TowerDefense");

enum {
	cheminPossible,
	cheminEntree,
	cheminSortie,
	terrainDefense,
	terrainDecor
};

Monster::Monster(int typeMonster) {
	m_typeMonster = typeMonster;
	
	m_lifeMax = ( m_typeMonster + 1 ) * 100;
	m_lifeCurrent = m_lifeMax;
	
	x = 0;
	y = 0;
	
	m_line = 0;
	
	m_chemin.m_delete = false;
}

Monster::~Monster() {
	if ( m_line ) {
		delete m_line;
	}
}

Defender::Defender(int typeDefender, TowerDefenseCellRef cell) {
	m_typeDefender = typeDefender;
	
	m_attaque = 20;
	
	m_cell = cell;
	
	m_zone.m_delete = false;
}

Defender::~Defender() {
	Iterator iter = m_zone.getIterator();
	while ( iter.hasNext() ) {
		TowerDefenseCellRef cell = (TowerDefenseCellRef)iter.next();
		cell->m_nbDefenders--;
	}
}

void Defender::addCellToZone(TowerDefenseModelRef model, int c, int l) {
	TowerDefenseCellRef cell = (TowerDefenseCellRef)model->get(c, l);
	if ( cell ) {
		m_zone.add(cell);
		cell->m_nbDefenders++;
	}
}

void Defender::initZone(TowerDefenseModelRef model) {
	int x = m_cell->m_posInBoard.m_x;
	int y = m_cell->m_posInBoard.m_y;
	
	addCellToZone(model, x-1, y-1);
	addCellToZone(model, x  , y-1);
	addCellToZone(model, x+1, y-1);
	
	addCellToZone(model, x-1, y  );
	addCellToZone(model, x+1, y  );
	
	addCellToZone(model, x-1, y+1);
	addCellToZone(model, x  , y+1);
	addCellToZone(model, x+1, y+1);
}

TowerDefenseCell::TowerDefenseCell(int c, int l, sint* pvalue, int id) : Cell(c, l, pvalue, id) {
	m_typeCell = 0;
	
	m_nbDefenders = 0;
	
	m_monster = 0;
	m_defender = 0;
}

void TowerDefenseCell::draw(GdiRef gdi) {
	Color clr;
	switch ( m_typeCell ) {
		case cheminPossible:
		case cheminEntree:
		case cheminSortie:
			clr = white;
			break;
		case terrainDefense:
			clr = grayLight;
			break;
		case terrainDecor:
			clr = gray;
			break;
		default:
			assert(0);
			break;
	}
	
	gdi->rect(&m_rect, clr, clr);
	
	TowerDefenseViewRef view = (TowerDefenseViewRef)m_view;
	
	if ( m_monster ) {
		// Affichage d'un monstre
		BitmapRef monsterBitmap = (BitmapRef)view->m_resourcesMonsters.get(m_monster->m_typeMonster);
		
		int x = m_monster->x + m_rect.x;
		int y = m_monster->y + m_rect.y;
		
		gdi->copy(monsterBitmap, x, y, m_rect.w, m_rect.h, 0, 0, monsterBitmap->m_rect.w, monsterBitmap->m_rect.h);
		
		// Affichage de son énergie
		double percent = divby(m_monster->m_lifeCurrent, m_monster->m_lifeMax);
		
		int wlifeMax = 0.8 * m_rect.w;
		int wlifeCurrent = (int)mulby(wlifeMax, percent);
		
		x = m_monster->x + m_rect.x + ( m_rect.w - wlifeMax ) / 2;
		
		y -= 4;
		
		Rect rect(x, y, wlifeCurrent, 2);
		gdi->rect(&rect, red, red);
	}
	
	if ( m_defender ) {
		// Affichage d'une defense
		BitmapRef defenderBitmap = (BitmapRef)view->m_resourcesDefenders.get(m_defender->m_typeDefender);
		
		int x = m_rect.x + ( m_rect.w - defenderBitmap->m_rect.w ) / 2;
		int y = m_rect.y + ( m_rect.h - defenderBitmap->m_rect.h ) / 2;
		
		gdi->copy(defenderBitmap, x, y);
	}
}

const char* labyrinthe =
"000sss000000"\
"011   111110"\
"011   111110"\
"011      110"\
"01111111 110"\
"01   111 110"\
"01 1 1   110"\
"01 1 1 11110"\
"e  1 1 11110"\
"e  1 1  1110"\
"0111 1  1110"\
"01   1  1110"\
"01 111 11110"\
"01     11110"\
"011111111110"\
"011111111110"\
"000000000000";

TowerDefenseModel::TowerDefenseModel() : GameBoardModel(17, 12, 0) {
	m_entree.m_delete = false;
	m_sortie.m_delete = false;
}

TowerDefenseModel::~TowerDefenseModel() {
}

void TowerDefenseModel::init() {
	BoardModel::init();
	
	int i = 0;
	
	fromto(int, c, 0, m_cMax) {
		fromto(int, l, 0, m_lMax) {
			TowerDefenseCellRef cell = (TowerDefenseCellRef)get(c, l);
			switch ( labyrinthe[i++] ) {
				case ' ':
					cell->m_typeCell = cheminPossible;
					break;
				case 'e':
					cell->m_typeCell = cheminEntree;
					m_entree.add(cell);
					break;
				case 's':
					cell->m_typeCell = cheminSortie;
					m_sortie.add(cell);
					break;
				case '1':
					cell->m_typeCell = terrainDefense;
					break;
				case '0':
					cell->m_typeCell = terrainDecor;
					break;
				default:
					assert(0);
					break;
			}
		}
	}
	
	m_timer.timerInit();
	
	m_previousDelay = 0;
}

CellRef TowerDefenseModel::newCell(int id, int c, int l) {
	return new TowerDefenseCell(c, l, &m_board->m_values[ c + l * m_cMax ], id);
}

void TowerDefenseModel::addMonster(int typeMonster) {
	MonsterRef monster = (MonsterRef)m_monsters.add(new Monster(typeMonster));
	
	TowerDefenseCellRef from = (TowerDefenseCellRef)m_entree.getRandom();
	TowerDefenseCellRef to   = (TowerDefenseCellRef)m_sortie.getRandom();
	
	from->m_monster = monster;
	
	fromto(int, c, 0, m_cMax) {
		fromto(int, l, 0, m_lMax) {
			TowerDefenseCellRef cell = (TowerDefenseCellRef)get(c, l);
			switch ( cell->m_typeCell ) {
				case terrainDecor:
				case terrainDefense:
					cell->m_value = 1;
					break;
				default:
					cell->m_value = 0;
					break;
			}
		}
	}
	
	findWay(from, to, &monster->m_chemin);
}

bool TowerDefenseModel::idle() {
	TowerDefenseViewRef view = (TowerDefenseViewRef)m_view;
	
	int delay = m_timer.timerDelay() ;
	
	// Gestion des déplacements des monstres
	Iterator iterMonsters = m_monsters.getIterator();
	while ( iterMonsters.hasNext() ) {
		MonsterRef monster = (MonsterRef)iterMonsters.next();
		if ( monster->m_line ) {	
			TowerDefenseCellRef from = (TowerDefenseCellRef)monster->m_chemin.get(0);
			TowerDefenseCellRef to   = (TowerDefenseCellRef)monster->m_chemin.get(1);
			
			Point pos = monster->m_line->get(0);
			monster->m_line->release(0);
			
			if ( monster->m_line->getCount() == 1 ) {
				delete monster->m_line;
				monster->m_line = 0;
				
				to->m_monster = from->m_monster;
				from->m_monster = 0;
				
				monster->m_chemin.remove(0);
				
				monster->x = (int)( pos.x - to->m_rect.x );
				monster->y = (int)( pos.y - to->m_rect.y );
			}
			else {
				monster->x = (int)( pos.x - from->m_rect.x );
				monster->y = (int)( pos.y - from->m_rect.y );
			}
			
		}
		
		if ( monster->m_line == 0 ) {
			if ( monster->m_chemin.getCount() <= 1 ) {
				// Fin de la route
				TowerDefenseCellRef to = (TowerDefenseCellRef)monster->m_chemin.get(0);
				to->m_monster = 0;
				
				iterMonsters.release();
			}
			else if ( monster->m_chemin.getCount() > 1 && monster->m_line == 0 ) {
				// En chemin
				TowerDefenseCellRef from = (TowerDefenseCellRef)monster->m_chemin.get(0);
				TowerDefenseCellRef to   = (TowerDefenseCellRef)monster->m_chemin.get(1);
				
				Point fromPos(from->m_rect.x, from->m_rect.y);
				Point toPos  (to  ->m_rect.x, to  ->m_rect.y);
				
				if ( to->m_monster == 0 ) {
					monster->m_line = new Line(&fromPos, &toPos, 0, minmax(view->g_frameRateReal, 4, 8));
					monster->m_line->initLine();
				}
			}
		}
	}
	
	if ( delay-m_previousDelay >= 1000 ) {
		// Gestion de la défense
		Iterator iterDefenders = m_defenders.getIterator();
		while ( iterDefenders.hasNext() ) {
			DefenderRef defender = (DefenderRef)iterDefenders.next();
			
			// Truc de base
			// - une défense défend les cases autour d'elle
			// - donc 8 cases
			// - un tir par séquence possible sur une seule case parmi les 8
			// - tir en priorité sur celui qui a le moins de chemin à  parcourir
			// - réduit pour commencer la force d'un monstre de 20%
			TowerDefenseCellRef cellMonster = 0;
			
			Iterator iterZone = defender->m_zone.getIterator();
			while ( iterZone.hasNext() ) {
				TowerDefenseCellRef cell = (TowerDefenseCellRef)iterZone.next();
				if ( cell->m_monster ) {
					if ( cellMonster == 0 || cell->m_monster->m_chemin.getCount() < cellMonster->m_monster->m_chemin.getCount() ) {
						cellMonster = cell;
					}
				}
			}
			
			if ( cellMonster ) {
				MonsterRef monster = cellMonster->m_monster;
				if (  monster ) {
					monster->m_lifeCurrent -= defender->m_attaque;
					
					view->m_shoot.play();
					
					if ( monster->m_lifeCurrent <= 0 ) {
						cellMonster->m_monster = 0;
						m_monsters.release(monster);
					}
				}
			}
		}
	}
	
	if ( delay-m_previousDelay >= 1000 ) {
		// Gestion de l'apparition des monstres
		m_previousDelay = delay;
		
		if ( delay > 0 && System::Math::random( 4) == 2 ) {
			addMonster(0);
		}
		else if ( delay >= 10*1000 && System::Math::random(10) == 5 ) {
			addMonster(1);
		}
		else if ( delay >= 20*1000 && System::Math::random(16) == 8 ) {
			addMonster(2);
		}
		else if ( delay >= 30*1000 && System::Math::random(20) == 10 ) {
			addMonster(3);
		}
	}
	
	return true;
}

bool TowerDefenseModel::action(CellRef _cell) {
	TowerDefenseCellRef cell = (TowerDefenseCellRef)_cell;
	
	// Ajout d'une défense
	if ( cell->m_typeCell == terrainDefense ) {
		if ( cell->m_defender == 0 ) {
			DefenderRef defender = new Defender(0, cell);
			defender->initZone(this);
			
			cell->m_defender = (DefenderRef)m_defenders.add(defender);
		}
		else {
			m_defenders.release(cell->m_defender);
			cell->m_defender = 0;
		}
	}
	
	return false;
}

TowerDefenseView::TowerDefenseView() : BoardView() {
	m_shouldRotateToPortrait = false;
}

TowerDefenseView::~TowerDefenseView() {
}

void TowerDefenseView::loadResource() {
	m_resourcesMonsters.loadRes("alien-amarillo.png");
	m_resourcesMonsters.loadRes("alien-morado.png");
	m_resourcesMonsters.loadRes("alien-rentaculos.png");
	m_resourcesMonsters.loadRes("alien-verde.png");
	
	m_resourcesDefenders.loadRes("robot.png");
	
	m_shoot.load("shoot");
}