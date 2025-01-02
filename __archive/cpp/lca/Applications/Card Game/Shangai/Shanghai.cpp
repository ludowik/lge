#include "System.h"
#include "Shanghai.h"
#include "CardGame.View.h"
#include "CardGame.Model.Solitaire.h"
#include "CardGame.Action.h"

ApplicationObject<ShanghaiView, ShanghaiModel> appShanghai("Shanghai", "Shanghai", "", 0, pageBoardGame);

ShanghaiTuile::ShanghaiTuile() : Card() {
	m_level = 0;
	m_l = 0;
	m_c = 0;
	m_reverse = false;
}

ShanghaiTuile::ShanghaiTuile(int serie, int val) : Card(serie, val) {
	m_level = 0;
	m_l = 0;
	m_c = 0;
	m_reverse = false;
}

ShanghaiTuile::~ShanghaiTuile() {
}

const char* ShanghaiTuile::asString() {
	const char* famille = 0;
	switch ( m_serie ) {
		case eSaison   :  famille = "S"; break;
		case eFleur    :  famille = "F"; break;
		case eDragon   :  famille = "D"; break;
		case eVent     :  famille = "V"; break;
		case eCercle   :  famille = "C"; break;
		case eBambou   :  famille = "B"; break;
		case eCaractere:  famille = "C"; break;
	}
	
	static char val[20];
	sprintf(val, "%s %d", famille, m_val);
	
	return val;
}

bool ShanghaiTuile::save(File& file) {
	if ( Card::save(file) ) {
		file << m_level;
		file << m_l;
		file << m_c;
		return true;
	}
	return false;
}

bool ShanghaiTuile::load(File& file) {
	if ( Card::load(file) ) {
		file >> m_level;
		file >> m_l;
		file >> m_c;
		return true;
	}
	return false;
}

int m_d = 5;

void ShanghaiTuile::draw(GdiRef gdi, int x, int y, int w, int h) {
	int radius = max(w,h)/10;
	
	Rect rect(0, 0, w-m_d, h-m_d);
	
	fromto(int, i, 0, m_d) {
		rect.x++;
		rect.y++;
		gdi->roundrect(&rect, radius, black);
	}
	
	rect = Rect(0, 0, w-m_d, h-m_d);
	
	// Fond de carte
	Color color = 0;
	switch ( m_serie ) {
		case eSaison   : color = blue; break;
		case eFleur    : color = green; break;
		case eDragon   : color = red; break;
		case eVent     : color = blueLight; break;
		case eCercle   : color = greenLight; break;
		case eBambou   : color = redLight; break;
		case eCaractere: color = yellow; break;
		default        : color = brown; break;
	}

	gdi->roundgradient(rect.x, rect.y, rect.w, rect.h, radius, eDiagonal, white, color);
	gdi->roundrect(&rect, radius, blue);
}

BitmapRef ShanghaiTuile::makeBitmap(GdiRef gdi, int w, int h) {
	m_bitmap.release();
	m_bitmap.create(w, h);
	
	int fontSize = w * 3 / 8;
	
	Bitmap* card = new Bitmap();
	card->create(w, h);

	draw(card, 0, 0, w, h);
		
	const char* s = asString();
	
	Rect size = m_bitmap.getTextSize(s, 0, fontSize);
	m_bitmap.text((w-4-size.w)/2, (h-4-size.h)/2, s, blue, 0, fontSize);

	return &m_bitmap;
}

CardRef ShanghaiModel::newCard() {
	return (CardRef)new ShanghaiTuile();
}

ShanghaiModel::ShanghaiModel() {
	m_version = 5;
	
	m_lMax = 15;
	m_cMax = 8;
	
	m_piles.add(&m_talon);
}

ShanghaiModel::~ShanghaiModel() {
}

void ShanghaiModel::create() {
	release();
	
	// Saisons
	fromto(int, i, 0, 4) {
		m_cards.add(new ShanghaiTuile(eSaison, i));
	}
	
	// Fleurs
	fromto(int, i, 0, 4) {
		m_cards.add(new ShanghaiTuile(eFleur, i));
	}
	
	// Dragons
	fromto(int, i, 0, 3) {
		fromto(int, j, 0, 4) {
			m_cards.add(new ShanghaiTuile(eDragon, i));
		}
	}
	
	// Vents
	fromto(int, i, 0, 4) {
		fromto(int, j, 0, 4) {
			m_cards.add(new ShanghaiTuile(eVent, i));
		}
	}
	
	// Cercles
	fromto(int, i, 0, 9) {
		fromto(int, j, 0, 4) {
			m_cards.add(new ShanghaiTuile(eCercle, i));
		}
	}
	
	// Bambous
	fromto(int, i, 0, 9) {
		fromto(int, j, 0, 4) {
			m_cards.add(new ShanghaiTuile(eBambou, i));
		}
	}
	
	// Caracteres
	fromto(int, i, 0, 9) {
		fromto(int, j, 0, 4) {
			m_cards.add(new ShanghaiTuile(eCaractere, i));
		}
	}
}

void ShanghaiModel::addSerieTuile(int level, double startColonne, double nc, double startLine, double nl) {
	Iterator iter(m_cards.getIterator());
	iter.begin();
	
	fromto(double,l,startLine,startLine+nl) {
		fromto(double,c,startColonne,startColonne+nc) {
			ShanghaiTuileRef tuile = (ShanghaiTuileRef)iter.next();
			tuile->m_level = level;
			tuile->m_l = l;
			tuile->m_c = c;
			tuile->m_reverse = false;
			m_talon.add(iter.remove());
		}
	}
}

void ShanghaiModel::distrib() {
	SolitaireCardGameModel::distrib();
	distrib5();
}

void ShanghaiModel::distrib1() {
	addSerieTuile(1, 2, 4, 1  , 1);
	addSerieTuile(1, 1, 6, 2  , 2);
	addSerieTuile(1, 2, 4, 4  , 1);
	addSerieTuile(2, 2, 4, 2  , 2);
	addSerieTuile(3, 2, 4, 2.5, 1);
}

void ShanghaiModel::distrib2() {
	addSerieTuile(1, 1, 9, 1, 8);
	addSerieTuile(2, 2, 7, 2, 6);
	addSerieTuile(2, 3, 5, 3, 4);
	addSerieTuile(2, 4, 3, 4, 2);
	addSerieTuile(2, 5, 1, 4, 2);
	addSerieTuile(2, 5, 1, 3, 1);
	addSerieTuile(2, 5, 1, 5, 1);
}

void ShanghaiModel::distrib3() {
	distrib3(0);
	distrib3(8);
}

void ShanghaiModel::distrib3(int x) {
	addSerieTuile(1, x+2, 4, 1, 1);
	addSerieTuile(1, x+1, 6, 2, 4);
	addSerieTuile(1, x+2, 4, 6, 1);
	
	addSerieTuile(2, x+2, 4, 2, 4);
	addSerieTuile(3, x+2, 4, 2, 4);
	
	addSerieTuile(4, x+3, 2, 3, 2);
	addSerieTuile(5, x+3, 2, 3, 2);
}

void ShanghaiModel::distrib4() {
	addSerieTuile(1, 2, 10, 1, 1);
	addSerieTuile(1, 1, 12, 2, 4);
	addSerieTuile(1, 2, 10, 6, 1);
	
	addSerieTuile(2, 4,  6, 1, 1);
	addSerieTuile(2, 3,  8, 2, 1);
	addSerieTuile(2, 2, 10, 3, 2);
	addSerieTuile(2, 3,  8, 5, 1);
	addSerieTuile(2, 4,  6, 6, 1);
	
	addSerieTuile(3, 4,  6, 2, 1);
	addSerieTuile(3, 3,  8, 3, 2);
	addSerieTuile(3, 4,  6, 5, 1);
}

void ShanghaiModel::distrib5() {
	addSerieTuile(1,  2  , 12, 1  , 1);
	addSerieTuile(1,  4  ,  8, 2  , 1);
	addSerieTuile(1,  3  , 10, 3  , 1);
	addSerieTuile(1,  2  , 12, 4  , 2);
	addSerieTuile(1,  1  ,  1, 4.5, 1);
	addSerieTuile(1, 14  ,  1, 4.5, 1);
	addSerieTuile(1, 15  ,  1, 4.5, 1);
	addSerieTuile(1,  3  , 10, 6  , 1);
	addSerieTuile(1,  4  ,  8, 7  , 1);
	addSerieTuile(1,  2  , 12, 8  , 1);
	
	addSerieTuile(2,  5  ,  6, 2  , 6);
	addSerieTuile(3,  6  ,  4, 3  , 4);
	addSerieTuile(4,  7  ,  2, 4  , 2);
	
	addSerieTuile(5,  7.5,  1, 4.5, 1);
}

bool ShanghaiModel::action(::CardsRef pile, CardRef card) {
	if ( m_cardSelect && m_cardSelect != card ) {
		// Une paire
		if (   card
			&& card->m_serie == m_cardSelect->m_serie && ( card->m_val == m_cardSelect->m_val || card->m_serie == eFleur || card->m_serie == eSaison )
			&& selectable((ShanghaiTuileRef)card) ) {
			Actions* actions = new Actions();
			actions->add(new MoveCardAction(this, card, pile, &m_cards));
			actions->add(new MoveCardAction(this, m_cardSelect, m_pileSelect, &m_cards));
			pushAction(actions);
			unselect();
			return true;
		}
	}
	
	unselect();
	select(pile, card);
	
	return true;
}

bool ShanghaiModel::select(::CardsRef pile, CardRef card) {
	if ( selectable((ShanghaiTuileRef)card) ) {
		m_cardSelect = card;
		m_pileSelect = pile;
		card->m_select = true;
		return true;
	}
	
	return false;
}

bool ShanghaiModel::selectable(ShanghaiTuileRef tuile) {
	// rien au dessus ?
	if ( hasOver(tuile) ) {
		return false;
	}
	
	// un cote libre ?
	if ( hasLeftAndRight(tuile) ) {
		return false;
	}
	
	return true;
}

bool ShanghaiModel::hasOver(ShanghaiTuileRef tuile) {
	Iterator iter(m_talon.getIterator());
	iter.begin();
	
	while ( iter.hasNext()) {
		ShanghaiTuileRef over = (ShanghaiTuileRef)iter.next();
		if ( over != tuile ) {
			if ( over->m_level == tuile->m_level+1 ) {
				double dl = abs(over->m_l-tuile->m_l);
				if ( dl < 1 ) {
					double dc = abs(over->m_c-tuile->m_c);
					if ( dc < 1 ) {
						return true;
					}
				}
			}
		}
	}
	
	return false;
}

bool ShanghaiModel::hasLeftAndRight(ShanghaiTuileRef tuile) {
	Iterator iter(m_talon.getIterator());
	iter.begin();
	
	bool left  = false;
	bool right = false;
	
	while ( iter.hasNext()) {
		ShanghaiTuileRef neighbours = (ShanghaiTuileRef)iter.next();
		if ( neighbours != tuile ) {
			if ( neighbours->m_level == tuile->m_level ) {
				double dl = abs(neighbours->m_l-tuile->m_l);
				if ( dl < 1 ) {
					double dc = neighbours->m_c-tuile->m_c;
					if ( dc == 1 ) {
						left = true;
					}
					else if ( dc == -1 ) {
						right = true;
					}
					
					if ( left && right ) {
						return true;
					}
				}
			}
		}
	}
	
	return false;
}

bool ShanghaiModel::isGameOver() {
	return false;
}

bool ShanghaiModel::isGameWin() {
	if ( m_talon.getCount() == 0 ) {
		return true;
	}
	
	return false;
}

const char* ShanghaiModel::getRulesDistrib() {
	return "";
}

const char* ShanghaiModel::getRulesPlay() {
	return "";
}

ShanghaiView::ShanghaiView() : CardGameView() {
}

ShanghaiView::~ShanghaiView() {
}

void ShanghaiView::draw(GdiRef gdi) {
	ShanghaiModelRef model = (ShanghaiModelRef)m_model;
	
	calc(gdi, model->m_cMax, model->m_lMax);

	m_wcard = m_d+(m_rect.w-m_d)/8;
	m_hcard = 30;
	
	int dx = -m_d;
	int dy = -m_d;
	
	Iterator iter(model->m_talon.getIterator());
	while ( iter.hasNext() ) {
		ShanghaiTuileRef tuile = (ShanghaiTuileRef)iter.next();
		
		tuile->m_rect.x = (int)( m_rect.x + ( tuile->m_l - 1 ) * (m_wcard-m_d) + dx * ( tuile->m_level - 1 ) );
		tuile->m_rect.y = (int)( m_rect.y + ( tuile->m_c - 1 ) * (m_hcard-m_d) + dy * ( tuile->m_level - 1 ) );
		
		tuile->m_rect.w = m_wcard;
		tuile->m_rect.h = m_hcard;
		
		CardGameView::drawCard(gdi, (CardRef)tuile, &model->m_cards, tuile->m_rect.x, tuile->m_rect.y, m_wcard, m_hcard);
	}
}
