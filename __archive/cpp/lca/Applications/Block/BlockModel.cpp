#include "System.h"
#include "BlockModel.h"

BlockModel::BlockModel() : BoardModel(10, 10, 100) {
	m_nbBitmap = 4;
}

BlockModel::~BlockModel() {
}

#define Show 0
#define Kill 1
#define Calc 2

int BlockModel::killItem(int id, int iObject, int bShowKillOrCalc) {
	if ( id < 0 || id >= m_cMax * m_lMax ) {
		return 0;
	}
	
	int gain = 0;
	
	CellRef cell = (CellRef)get(id);
	if ( cell && cell->m_value == iObject ) {
		cell->m_value = 0;
		
		if ( bShowKillOrCalc != Calc ) {
			cell->m_selected = true;
		}
		
		gain = 1;
		
		gain += killItem(id - 1, iObject, bShowKillOrCalc) * 2;
		gain += killItem(id + 1, iObject, bShowKillOrCalc) * 2;
		
		gain += killItem(id - m_cMax, iObject, bShowKillOrCalc) * 2;
		gain += killItem(id + m_cMax, iObject, bShowKillOrCalc) * 2;
		
		if ( bShowKillOrCalc != Kill ) {
			cell->m_value = iObject;
		}
	}
	
	return gain;
}

bool BlockModel::action(CellRef cell) {
	CellRef cellFrom = (CellRef)get(m_curCell);
	CellRef cellTo = (CellRef)cell;
	
	if ( cellFrom == cellTo || !cell ) {
		return false;
	}
	
	if ( cell && cell->isKindOf("Cell") ) {
		if ( cell->m_selected ) {
			int gain = killItem(cell->m_id, cell->m_value, Kill);
			
			unselect();
			
			m_score.m_value += gain;
		}
		else {
			unselect();
			
			if ( cell->m_value != 0 ) {
				int m_score = killItem(cell->m_id, cell->m_value, Show);
				if ( m_score > 1 ) {
					int minx = INT_MAX;
					int miny = INT_MAX;
					
					int maxx = INT_MIN;
					int maxy = INT_MIN;
					
					foreach ( CellRef , cell , m_cells ) {
						if ( cell->m_selected ) {
							minx = min(minx, cell->m_rect.x);
							miny = min(miny, cell->m_rect.y);
							
							maxx = max(maxx, cell->m_rect.x+cell->m_rect.w);
							maxy = max(maxy, cell->m_rect.y+cell->m_rect.h);
						}
					}
				}
			}
		}
		
		update();
	}
	return true;
}

bool BlockModel::update() {
	int x = 0;
	int y = 0;
	
	bool bMove = false;
	
	do {
		bMove = false;
		
		for ( x = 0 ; x < m_cMax ; ++x ) {
			for ( y = m_lMax-1 ; y >0  ; --y ) {
				CellRef cell = get(x, y);
				CellRef pUpCell = get(x, y-1);
				
				if ( cell->m_value == 0 && pUpCell->m_value != 0 ) {
					cell->m_value = pUpCell->m_value;
					pUpCell->m_value = 0;
					
					bMove = true;
				}
			}
		}
		
		if ( bMove == false ) {
			for ( x = divby2(m_cMax) ; x < m_cMax-1 ; ++x ) {
				if ( get(x  , m_lMax-1)->m_value==0
					&& get(x+1, m_lMax-1)->m_value!=0 ) {
					for ( y = m_lMax-1 ; y >0  ; --y ) {
						CellRef cell = get(x, y);
						CellRef pRightCell = get(x+1, y);
						
						cell->m_value = pRightCell->m_value;
						pRightCell->m_value = 0;
						
						bMove = true;
					}
				}
			}
			
			for ( x = divby2(m_cMax) - 1 ; x > 0 ; --x ) {
				if ( get(x  , m_lMax-1)->m_value==0
					&& get(x-1, m_lMax-1)->m_value!=0 ) {
					for ( y = m_lMax-1 ; y >0  ; --y ) {
						CellRef cell = get(x, y);
						CellRef pRightCell = get(x-1, y);
						
						cell->m_value = pRightCell->m_value;
						pRightCell->m_value = 0;
						
						
						bMove = true;
					}
				}
			}
		}
	}
	while ( bMove );
	
	// Est-ce la fin ?
	CellRef cell = 0;
	for ( x = 0 ; x < m_cMax ; ++x ) {
		for ( y = m_lMax-1 ; y >0  ; --y ) {
			cell = get(x, y);
			if ( cell->m_value != 0 && killItem(cell->m_id, cell->m_value, Calc) > 1 ) {
				break;
			}
			cell = 0;
		}
		if ( cell ) {
			break;
		}
	}
	
	if ( !cell ) {
		init();
	}
	
	return true;
}
