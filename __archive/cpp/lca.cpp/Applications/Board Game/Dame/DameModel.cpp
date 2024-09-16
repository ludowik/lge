#include "System.h"
#include "DameModel.h"

DameModel::DameModel() : GameBoardModel(10, 10, 0, new Dame(10, 10)) {
	m_damier = true;
}

DameModel::~DameModel() {
}

Dame::Dame(int w, int h) : Board(w, h) {
	m_fromTo = true;
}

Dame::~Dame() {
}

void Dame::init() {
	Board::init();
	
	Position pos;
	for ( pos.m_x = 0 ; pos.m_x < m_w ; ++pos.m_x ) {
		for ( pos.m_y = 0 ; pos.m_y < m_h ; ++pos.m_y ) {
			if ( ( pos.m_x + pos.m_y ) % 2 ) {
				switch ( pos.m_y ) {
					case 0:
					case 1:
					case 2:
					case 3: {
						set(pos, getVal(1, 1));
						break;
					}
					case 6:
					case 7:
					case 8:
					case 9: {
						set(pos, getVal(2, 1));
						break;
					}
				}
			}
		}
	}  
}

void Dame::getMovesList(List& rList, int user, Position from) {
	int dy = user == 1 ? +1 : -1;
	
	Position to;
	if ( from.m_x > 0 && from.m_y < m_h-1 ) {
		to = Position(from.m_x-1, from.m_y+dy);
		if ( getUser(get(to)) == 0 ) {
			rList.add(new Move(from, to));
		}
		else if ( getUser(get(to)) != user ) {
			if ( from.m_x > 1 && from.m_y < m_h-2 ) {
				to = Position(from.m_x-2, from.m_y+dy+dy);
				if ( getUser(get(to)) == 0 ) {
					rList.add(new Move(from, to));
				}
			}
		}
	}
	if ( from.m_x < m_w-1 ) {
		to = Position(from.m_x+1, from.m_y+dy);
		if ( getUser(get(to)) == 0 ) {
			rList.add(new Move(from, to));
		}
	}
}

int Dame::getEvaluation() {
	int lines1 = findLines(false, 4, getVal(1, 1));
	int lines2 = findLines(false, 4, getVal(2, 1));
	
	return lines1-lines2;
}
