#include "System.h"
#include "EnlightModel.h"

const char* g_schemas[] =  {
"1100000011"\
"1000000001"\
"0000000100"\
"0000001110"\
"0000000100"\
"0001000000"\
"0011100000"\
"0001000000"\
"1000000001"\
"1100000011",

"0100000010"\
"1110000111"\
"0100000010"\
"0100000010"\
"1110000111"\
"0100000010"\
"0100000010"\
"1110000111"\
"0100000010"\
"0000000000",

"0000000000"\
"0110000110"\
"1001001001"\
"0110000110"\
"0000000000"\
"0110000110"\
"1001001001"\
"0110000110"\
"0000000000"\
"0000000000",

"0000000000"\
"0000000000"\
"0000000000"\
"0000110000"\
"0001111000"\
"0001111000"\
"0000110000"\
"0000000000"\
"0000000000"\
"0000000000",

"0000000000"\
"0000000000"\
"0000000000"\
"0000101000"\
"0001000100"\
"0001101100"\
"0001000100"\
"0000101000"\
"0000000000"\
"0000000000",

"0000000000"\
"0010000100"\
"0110000110"\
"0001001000"\
"0000110000"\
"0000110000"\
"0001001000"\
"0110000110"\
"0010000100"\
"0000000000",

"0000010000"\
"0000111000"\
"0000000000"\
"0010010010"\
"0110101011"\
"0010010010"\
"0000000000"\
"0000111000"\
"0000010000"\
"0000000000"
};

EnlightModel::EnlightModel() : BoardModel(10, 10, 0) {
	m_nbBitmap = 2;
	
	m_ilevel = 0;
	m_imovesLeft = 0;
	m_imovesTotal = 0;
}

void EnlightModel::init() {
	BoardModel::init();
	
	m_imovesLeft = 0;
	m_imovesTotal = 0;
	
	enlightBoard();
}

void EnlightModel::enlightBoard() {
	if ( m_ilevel < sizeof(g_schemas) / sizeof(char*) ) {
		for ( int l = 0 ; l < m_lMax ; ++l ) {
			for ( int c = 0 ; c < m_cMax ; ++c ) {
				get(l, c)->m_value = g_schemas[m_ilevel][c+l*m_lMax]=='1'?2:1;
			}
		}
	}
	else {
		for ( int l = 0 ; l < m_lMax ; ++l ) {
			for ( int c = 0 ; c < m_cMax ; ++c ) {
				get(l, c)->m_value = 1;
			}
		}
		
		int n = 10 + m_ilevel;
		while ( --n ) {
			enlight(get(System::Math::random(m_cMax),
						System::Math::random(m_lMax)));
		}
	}
}

bool EnlightModel::isGameWin() {
	for ( int l = 0 ; l < m_lMax ; ++l ) {
		for ( int c = 0 ; c < m_cMax ; ++c ) {
			if ( get(l, c)->m_value != 1 ) {
				return false;
			}
		}
	}
	
	return true;
}

bool EnlightModel::action(CellRef ctrl) {
	enlight(ctrl);
	
	m_imovesLeft++;
	m_imovesTotal++;
	
	if ( isGameWin() ) {
		m_ilevel++;
		enlightBoard();
	}
	
	return true;
}

void EnlightModel::enlightCell(CellRef cell) {
	if ( cell ) {
		cell->m_value = cell->m_value==1?2:1;
	}
}

void EnlightModel::enlight(CellRef cell) {
	enlightCell(cell);
	
	enlightCell(get(cell->m_posInBoard.m_x+1, cell->m_posInBoard.m_y  ));
	enlightCell(get(cell->m_posInBoard.m_x-1, cell->m_posInBoard.m_y  ));
	enlightCell(get(cell->m_posInBoard.m_x  , cell->m_posInBoard.m_y+1));
	enlightCell(get(cell->m_posInBoard.m_x  , cell->m_posInBoard.m_y-1));
}

bool EnlightModel::load(File& file) {
	if ( BoardModel::load(file) ) {
		file >> m_ilevel;
		file >> m_imovesLeft;
		file >> m_imovesTotal;
		return true;
	}
	
	return false;
}

bool EnlightModel::save(File& file) {
	if ( BoardModel::save(file) ) {
		file << m_ilevel;
		file << m_imovesLeft;
		file << m_imovesTotal;
		return true;
	}
	
	return false;
}
