#include "System.h"
#include "Chess.h"

ApplicationObject<ChessView, ChessModel> appChess("Chess", "Chess", "chess.png", 0, pageBoardGame);

#define Roi      1
#define Dame     2
#define Fou      3
#define Cavalier 4
#define Tour     5
#define Pion     6

ImplementClass(ChessEngine) : public Board {
public:
	ChessEngine(int w, int h);
	virtual ~ChessEngine();
	
public:
	virtual void getMovesList(List& list, int user, Position from);
	virtual int getEvaluation();
	
	virtual void init();
	
private:
	void directionGetMoves(List& list, int user, Position from, int dx, int dy, bool stop);
	void cavalierGetMoves (List& list, int user, Position from, int dx, int dy);
	
};

ChessEngine::ChessEngine(int w, int h) : Board(w, h) {
	m_fromTo = true;
}

ChessEngine::~ChessEngine() {
}

void ChessEngine::init() {
	Board::init();
	
	int x = 0;
	
	Position pos(x, 0);
	set(pos, getVal(1, Tour));
	pos.m_x++;
	set(pos, getVal(1, Cavalier));
	pos.m_x++;
	set(pos, getVal(1, Fou));
	pos.m_x++;
	set(pos, getVal(1, Dame));
	pos.m_x++;
	set(pos, getVal(1, Roi));
	pos.m_x++;
	set(pos, getVal(1, Fou));
	pos.m_x++;
	set(pos, getVal(1, Cavalier));
	pos.m_x++;
	set(pos, getVal(1, Tour));
	pos.m_x++;
	
	pos.m_x = 0;
	pos.m_y = 7;

	set(pos, getVal(2, Tour));
	pos.m_x++;
	set(pos, getVal(2, Cavalier));
	pos.m_x++;
	set(pos, getVal(2, Fou));
	pos.m_x++;
	set(pos, getVal(2, Dame));
	pos.m_x++;
	set(pos, getVal(2, Roi));
	pos.m_x++;
	set(pos, getVal(2, Fou));
	pos.m_x++;
	set(pos, getVal(2, Cavalier));
	pos.m_x++;
	set(pos, getVal(2, Tour));
	pos.m_x++;
	
	for ( x = 0 ; x < m_w ; ++x ) {
		Position p1(x, 1);
		set(p1, getVal(1, Pion));
		
		Position p2(x, 6);
		set(p2, getVal(2, Pion));
	}  
}

void ChessEngine::directionGetMoves(List& list, int user, Position from, int dx, int dy, bool stop) {
	Position to = Position(from.m_x+(dx), from.m_y+(dy));
	
	int valueTo = get(to);
	while ( to.m_exist && getUser(valueTo) != user ) {
		list.add(new Move(from, to));
		if ( getUser(valueTo) != 0 || stop ) {
			break;
		}
		to = Position(to.m_x+(dx), to.m_y+(dy));
		valueTo = get(to);
	}
}

void ChessEngine::cavalierGetMoves(List& list, int user, Position from, int dx, int dy) {
	Position to = Position(from.m_x+(dx), from.m_y+(dy));
	
	int valueTo = get(to);
	if ( to.m_exist && getUser(valueTo) != user ) {
		list.add(new Move(from, to));
	}
}

void ChessEngine::getMovesList(List& list, int user, Position from) {
	int opponent = user == 1 ? 2 : 1;
	
	int value = get(from);
	int valueTo;
	
	int type = getType(value);
	
	Position to;
	
	if ( type == Roi ) {
		directionGetMoves(list, user, from, +1, -1, true);
		directionGetMoves(list, user, from, +1, +1, true);
		directionGetMoves(list, user, from, -1, -1, true);
		directionGetMoves(list, user, from, -1, +1, true);
		directionGetMoves(list, user, from, +1, +0, true);
		directionGetMoves(list, user, from, -1, +0, true);
		directionGetMoves(list, user, from, +0, +1, true);
		directionGetMoves(list, user, from, +0, -1, true);
	}
	else if ( type == Dame ) {
		directionGetMoves(list, user, from, +1, -1, false);
		directionGetMoves(list, user, from, +1, +1, false);
		directionGetMoves(list, user, from, -1, -1, false);
		directionGetMoves(list, user, from, -1, +1, false);
		directionGetMoves(list, user, from, +1, +0, false);
		directionGetMoves(list, user, from, -1, +0, false);
		directionGetMoves(list, user, from, +0, +1, false);
		directionGetMoves(list, user, from, +0, -1, false);
	}
	else if ( type == Fou ) {
		directionGetMoves(list, user, from, +1, -1, false);
		directionGetMoves(list, user, from, +1, +1, false);
		directionGetMoves(list, user, from, -1, -1, false);
		directionGetMoves(list, user, from, -1, +1, false);
	}
	else if ( type == Cavalier ) {
		cavalierGetMoves(list, user, from, +2,+1);
		cavalierGetMoves(list, user, from, +2,-1);
		cavalierGetMoves(list, user, from, -2,+1);
		cavalierGetMoves(list, user, from, -2,-1);
		cavalierGetMoves(list, user, from, +1,+2);
		cavalierGetMoves(list, user, from, +1,-2);
		cavalierGetMoves(list, user, from, -1,+2);
		cavalierGetMoves(list, user, from, -1,-2);
	}
	else if ( type == Tour ) {
		directionGetMoves(list, user, from, +1, +0, false);
		directionGetMoves(list, user, from, -1, +0, false);
		directionGetMoves(list, user, from, +0, +1, false);
		directionGetMoves(list, user, from, +0, -1, false);
	}
	else if ( type == Pion ) {
		/* En avant : premier mouvement
		 */
		to = Position(from.m_x, from.m_y + (user==1?2:-2));
		valueTo = get(to);
		if ( to.m_exist && valueTo == 0 && from.m_y == (user==1?1:6) ) {
			list.add(new Move(from, to));
		}
		
		/* En avant
		 */
		to = Position(from.m_x, from.m_y + (user==1?1:-1));
		valueTo = get(to);
		if ( to.m_exist && valueTo == 0 ) {
			list.add(new Move(from, to));
		}
		
		/* Prise a droite
		 */
		to = Position(from.m_x+1, from.m_y + (user==1?1:-1));
		valueTo = get(to);
		if ( to.m_exist && getUser(valueTo) == opponent ) {
			list.add(new Move(from, to));
		}
		
		/* Prise a gauche
		 */
		to = Position(from.m_x-1, from.m_y + (user==1?1:-1));
		valueTo = get(to);
		if ( to.m_exist && getUser(valueTo) == opponent ) {
			list.add(new Move(from, to));
		}
	}
}

int getValue(int type) {
	int value = 0;
	switch ( type )  {
		case Pion: {
			value = 100;
			break;
		}
		case Cavalier: {
			value = 300;
			break;
		}
		case Fou: {
			value = 300;
			break;
		}
		case Tour: {
			value = 500;
			break;
		}
		case Dame: {
			value = 900;
			break;
		}
		case Roi: {
			value = 1000000;
			break;
		}
	}
	return value;
}

int ChessEngine::getEvaluation() {
	int player1 = 0;
	int player2 = 0;
	
	int value = 0;
	
	int user = 0;
	int type = 0;	
	
	Position from;
	for ( from.m_x = 0 ; from.m_x < m_w ; ++from.m_x ) {
		for ( from.m_y = m_h-1 ; from.m_y >= 0 ; --from.m_y ) {
			value = get(from);
			
			user = getUser(value);
			type = getType(value);
			
			if ( user == 1 ) {
				player1 += getValue(type);
			}
			else if ( user == 2 ) {
				player2 += getValue(type);
			}
		}
	}
	
	return player1 - player2;
}

ChessModel::ChessModel() : GameBoardModel(8, 8, 0, new ChessEngine(8, 8)) {
	m_damier = true;
	m_showMoves = 1;
}

ChessView::ChessView() : BoardView() {
	m_annoted = true;
}

void ChessView::loadResource() {	
	addResource("w_king.png");
	addResource("w_queen.png");
	addResource("w_bishop.png");
	addResource("w_knight.png");
    addResource("w_rook.png");
	addResource("w_pawn.png");
	
	addResource("b_pawn.png");
	addResource("b_rook.png");
	addResource("b_knight.png");
	addResource("b_bishop.png");
	addResource("b_queen.png");
	addResource("b_king.png");
}
