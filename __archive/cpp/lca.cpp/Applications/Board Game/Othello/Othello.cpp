#include "System.h"
#include "Othello.h"

ApplicationObject<OthelloView, OthelloModel> appOthello("Othello", "Othello", "othello.png", 0, pageBoardGame);

ImplementClass(OthelloEngine) : public Board {
public:
	OthelloEngine(int w, int h);
	
public:
	virtual void getMovesList(List& rList, int user, Position& position, int dx, int dy);
	virtual void getMovesList(List& rList, int user);
	
	virtual int getEvaluation();
	
	virtual void init();
	
	virtual bool CheckMove(int user, Position& position, int dx, int dy, bool bCheckOnly=true, bool bChange=false);
	
	virtual bool execMove(Move& move, int user);
	
};

OthelloEngine::OthelloEngine(int w, int h) : Board(w, h) {
}	

void OthelloEngine::init() {
	Board::init();
	
	Position pos(3, 3);
	set(pos, getVal(1));
	
	pos = Position(4, 4);
	set(pos, getVal(1));
	
	pos = Position(4, 3);
	set(pos, getVal(2));
	
	pos = Position(3, 4);
	set(pos, getVal(2));
}

void OthelloEngine::getMovesList(List& rList, int user, Position& position, int dx, int dy) {
	if ( CheckMove(user, position, dx, dy) ) {
		rList.add(new Move(Position(), position));
	}
}

void OthelloEngine::getMovesList(List& rList, int user) {
	rList.releaseAll();
	
	Position pos;
	for ( pos.m_x = 0 ; pos.m_x < m_w ; ++pos.m_x ) {
		for ( pos.m_y = 0 ; pos.m_y < m_h ; ++pos.m_y ) {
			if ( getUser(get(pos) == 0 ) ) {
				getMovesList(rList, user, pos,  1,  0);
				getMovesList(rList, user, pos,  1,  1);
				getMovesList(rList, user, pos,  0,  1);
				getMovesList(rList, user, pos, -1,  1);
				getMovesList(rList, user, pos, -1,  0);
				getMovesList(rList, user, pos, -1, -1);
				getMovesList(rList, user, pos,  0, -1);
				getMovesList(rList, user, pos,  1, -1);
			}
		}
	}
}

bool OthelloEngine::execMove(Move& move, int user) {
	CheckMove(user, move.m_end,  1,  0, false);
	CheckMove(user, move.m_end,  1,  1, false);
	CheckMove(user, move.m_end,  0,  1, false);
	CheckMove(user, move.m_end, -1,  1, false);
	CheckMove(user, move.m_end, -1,  0, false);
	CheckMove(user, move.m_end, -1, -1, false);
	CheckMove(user, move.m_end,  0, -1, false);
	CheckMove(user, move.m_end,  1, -1, false);
	
	return true;
}

/* Force de chaque cellule
 ATTENTION : les positions autour d'un coin deviennent interessantes si l'on
 possede le coin
 Possible d'ameliorer le truc en regardant si une piece est imprenable
 */
int valuation[8][8] = {
{ 500, -150, 30, 10, 10, 30, -150,  500},
{-150, -250,  0,  0,  0,  0, -250, -150},
{  30,    0,  1,  2,  2,  1,    0,   30},
{  10,    0,  2, 16, 16,  2,    0,   10},
{  10,    0,  2, 16, 16,  2,    0,   10},
{  30,    0,  1,  2,  2,  1,    0,   30},
{-150, -250,  0,  0,  0,  0, -250, -150},
{ 500, -150, 30, 10, 10, 30, -150,  500},
};

/* Les phases de jeu :
 1) Debut de partie : les n premiers coup, on favorise la mobilite (max) et la position
 2) Milieu de partie : attention particuliere sur la conquÍte des bords et des coins
 3) Fin de partie : on maximise le materiel et on peut pousser la profondeur
 Pour un nombre de pionts joues inferieur a ... on a des facteurs :
 - fmateriel
 - fmobilite
 - fposition
 */
int phase[4][4] = {
{ 12, 1,4,2},
{ 45, 1,2,4},
{ 55, 1,1,1},
{999, 1,0,0},
};

int OthelloEngine::getEvaluation() {
	int imateriel = 0; // nombre de pion
	int imobilite = 0; // nombre de coup possible
	int iposition = 0; // force de la position
	
	int nbPion = 0;
	
	Position pos;
	for ( pos.m_x = 0 ; pos.m_x < m_w ; ++pos.m_x ) {
		for ( pos.m_y = 0 ; pos.m_y < m_h ; ++pos.m_y ) {
			int user = getUser(get(pos));
			switch ( user ) {
				case 1:
				case 2: {
					int sign = user == 1 ? 1 : -1;
					
					nbPion++;
					
					imateriel += sign * 1;
					iposition += sign * valuation[pos.m_x][pos.m_y];
					break;
				}
			}
		}
	}
	
	List rList;
	
	getMovesList(rList, 1);
	imobilite += rList.getCount();
	
	getMovesList(rList, 2);
	imobilite -= rList.getCount();
	
	int i = 0;
	while ( nbPion > phase[i][0] ) i++;
	
	int fmateriel = phase[i][1];
	int fmobilite = phase[i][2];
	int fposition = phase[i][3];
	
	return imateriel * fmateriel + imobilite * fmobilite + iposition * fposition;
} 

bool OthelloEngine::CheckMove(int user, Position& position, int dx, int dy, bool bCheckOnly, bool bChange) {
	if ( position.m_x == -1 && position.m_y == -1 ) {
		return false;
	}
	
	Position pos = position;
	
	pos.m_x += dx;
	pos.m_y += dy;
	
	int user2 = getUser(get(pos));
	
	if ( user2 && user != user2 ) {
		int nb = 0;
		
		if ( bChange ) {
			set(position, getVal(user));
		}
		
		do {
			if ( bChange ) {
				set(pos, getVal(user));
			}
			
			nb++;
			
			pos.m_x += dx;
			pos.m_y += dy;
			
			user2 = getUser(get(pos));
		}
		while ( user2 && user != user2 );
		
		if ( user2 && user == user2 ) {
			if ( !bCheckOnly && !bChange ) {
				CheckMove(user, position, dx, dy, false, true);
			}
			return true;
		}
	}
	
	return false;
}

OthelloModel::OthelloModel() : GameBoardModel(8, 8, 0, new OthelloEngine(8, 8)) {
	m_damier = true;
	
	m_bgColor1 = greenDark;
	m_bgColor2 = greenDark;
}

OthelloView::OthelloView() : BoardView() {
}

void OthelloView::loadResource() {
	addResource("othello_blackchip.png");
	addResource("othello_whitechip.png");
}

void OthelloView::createUI() {
	BoardView::createUI();
}

void OthelloView::draw(GdiRef gdi, int x, int y, int wcell, int hcell, BoardModel* model) {
	BoardView::drawCells(gdi, x, y, wcell, hcell, model);

	gdi->setPenSize(4);
	gdi->pixel(x+2*wcell, y+2*hcell, white);
	gdi->pixel(x+6*wcell, y+2*hcell, white);
	gdi->pixel(x+6*wcell, y+6*hcell, white);
	gdi->pixel(x+2*wcell, y+6*hcell, white);

	gdi->setPenSize(1);
}
