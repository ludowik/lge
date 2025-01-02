#include "System.h"
#include "Puissance4Model.h"

Puissance4Model::Puissance4Model() : GameBoardModel(8, 8, 0, new Puissance4(8, 8)) {
	m_class = "Puissance4Model";
}

Puissance4::Puissance4(int w, int h) : Board(w, h) {
}

void Puissance4::getMovesList(List& rList, int user) {
	rList.releaseAll();
	
	int lines = findLines(false, 4, 0);
	if ( lines ) {
		return;
	}
	
	Position pos;
	for ( pos.m_x = 0 ; pos.m_x < m_w ; ++pos.m_x ) {
		for ( pos.m_y = m_h-1 ; pos.m_y >= 0 ; --pos.m_y ) {
			if ( getUser(get(pos) == 0 ) ) {
				rList.add(new Move(Position(), pos));
				break;
			}
		}
	}
}

int Puissance4::getEvaluation() {
	int lines1 = findLines(false, 4, getVal(1, 1));
	int lines2 = findLines(false, 4, getVal(2, 1));
	
	if ( lines1 ) {
		return 1000;
	}
	
	if ( lines2 ) {
		return -1000;
	}
	
	lines1 = findLines(false, 3, getVal(1, 1));
	lines2 = findLines(false, 3, getVal(2, 1));
	
	if ( lines1 != lines2 ) {
		return lines1 - lines2;
	}
	
	return System::Math::random(10) - 5;
}
