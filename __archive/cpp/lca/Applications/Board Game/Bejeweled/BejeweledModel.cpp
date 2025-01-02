#include "System.h"
#include "BejeweledModel.h"

ImplementClass(BejeweledCell) : public Cell {
public:
	int m_iBitmap;

public:
	BejeweledCell(int c, int l, sint* pvalue, int id) : Cell(c, l, pvalue, id) {
		m_iBitmap = 0;
	}
	
public:
	virtual int getIndexBitmapFromID() {
		if ( m_value > 0 ) {
			if ( m_selected ) {
				m_iBitmap++;
				if ( m_iBitmap == 30 ) {
					m_iBitmap = 0;
				}
				return ( m_value - 1 ) * 30 + m_iBitmap;
			}
			return ( m_value - 1 ) * 30; 
		}
		return -1;
	}

};

BejeweledModel::BejeweledModel() : BoardModel(8, 8, 8*8) {
	m_nbCellPerLine = 3;
	m_damier = true;
}

BejeweledModel::~BejeweledModel() {
}

CellRef BejeweledModel::newCell(int id, int c, int l) {
	return new BejeweledCell(c, l, &m_board->m_values[ c + l * m_cMax ], id);
}

bool BejeweledModel::action(CellRef cell) {
	CellRef cellFrom = (CellRef)get(m_curCell);
	CellRef cellTo = (CellRef)cell;
	
	if ( cellFrom == cellTo || !cell ) {
		return false;
	}
	
	if ( m_curCell != -1 ) {
		CellRef pcell = (CellRef)get(m_curCell);
		if ( pcell != cell &&
			( abs( pcell->m_id - cell->m_id ) == 1 || abs( pcell->m_id - cell->m_id ) == m_cMax ) )
		{        
			pcell->m_selected = false;
			
			echangeCell(pcell, cell);
			
			if ( !update() ) {
				echangeCell(pcell, cell);
			}
			
			m_curCell = -1;
			
			return true;
		}
		
		pcell->m_selected = false;
	}
	
	m_curCell = cell->m_id;
	cell->m_selected = true;
	
	return true;
}

bool BejeweledModel::update() {
	bool bOkGrid;
	
	int total = 0;
	int score = 0;
	
	do {
		do {
			bOkGrid = true;
			
			for ( int l = m_lMax-1 ;l > 0  ;--l ) {
				for ( int c = 0 ;c < m_cMax ;++c ) {
					CellRef item = get(c, l);
					if ( item->m_value == 0 ) {
						CellRef pUitem = get(c, l-1);
						
						echangeCell(item, pUitem);
						
						bOkGrid = false;
					}
				}
			}
			
			for ( int c = 0 ;c < m_cMax ;++c ) {
				CellRef item = get(c, 0);
				if ( item->m_value == 0 ) {
					item->m_value = System::Math::random(m_nbBitmap) + 1;
					
					bOkGrid = false;
				}
			}
		}
		while ( !bOkGrid );
		
		score = m_board->findLines(true, m_nbCellPerLine, 0, false);
		
		total += score;
		
		m_score.m_value += score;
	}
	while ( score );
	
	if ( isGameOver() ) {
		gameOver();
	}
	
	return total ? true : false;
}

#define testCell(dx,dy)\
	echangeCell(pfrom, get(x+(dx), y+(dy)), false);\
	score = m_board->findLines(false, m_nbCellPerLine, type, false);\
	echangeCell(pfrom, get(x+(dx), y+(dy)), false);\
	if ( score > 0 ) {\
		pfrom->m_checked = true;\
		return false;\
	}

bool BejeweledModel::isGameOver() {
	int score = 0;
	for ( int x = 0 ; x < m_cMax ; ++x ) {
		for ( int y = 0 ; y < m_lMax ; ++y ) {
			CellRef pfrom = get(x, y);
			
			int type = pfrom->m_value;  
			
			testCell(-1,  0);
			testCell(+1,  0);
			testCell( 0, -1);
			testCell( 0, +1);      
		}
	}
	
	return true;
}
