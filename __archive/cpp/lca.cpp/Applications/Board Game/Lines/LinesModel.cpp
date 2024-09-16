#include "System.h"
#include "LinesCell.h"
#include "LinesModel.h"

LinesModel::LinesModel() : BoardModel(9, 9, 5) {
	m_nbCellPerLine = 5;
	m_nbAddCell = 3;

	m_pNxtBoard = new BoardModel(3, 1, 3);
}

LinesModel::~LinesModel() {
	delete m_pNxtBoard;
}

void LinesModel::init() {
	BoardModel::init();
	m_pNxtBoard->init();
}

bool LinesModel::action(CellRef cell) {
	CellRef cellFrom = (CellRef)get(m_curCell);
	CellRef cellTo = (CellRef)cell;
	
	if ( cellFrom == cellTo || !cell ) {
		return false;
	}
		
	if ( m_curCell != -1 ) {
		LinesCell* pCell = (LinesCell*)get(m_curCell);
		
		pCell->m_selected = false;
		
		if ( cellTo->m_value ) {
			m_curCell = cellTo->m_id;
			cellTo->m_selected = true;
		}
		else {
			if ( findWay(pCell, cellTo) ) {
				Actions* actions = new Actions();
				
				BoardAction* action = new BoardAction(this, pCell, cellTo, cellTo->m_value);
				actions->push(action);

				int score = m_board->findLines(true, m_nbCellPerLine, 0);
				
				if ( score == 0 ) {
					int nItems = m_pNxtBoard->getCount();
					for ( int i = 0 ; i < nItems ; ++i ) {
						if ( getNbFreeCell()==0 ) {
							break;
						}
						
						while ( 1 ) {
							LinesCell* pNewCell = (LinesCell*)get( System::Math::random(getCount()) );
							if ( pNewCell->m_value == 0 ) {
								pNewCell->m_value = ((LinesCell*)m_pNxtBoard->get(i))->m_value;
								
								LinesCell* pVide = (LinesCell*)m_pNxtBoard->get(i);
								pVide->m_value = 0;
								
								BoardAction* action = new BoardAction(this, pVide, pNewCell, pNewCell->m_value);
								actions->push(action);

								break;
							}
						}
					}
					
					m_pNxtBoard->addCell(m_nbAddCell);
					
					score += m_board->findLines(true, m_nbCellPerLine, 0);
				}
				
				pushAction(actions);
				
				if ( score ) {
					m_score.m_value += score;
				}
				
				m_curCell = -1;
			}
		}
	}
	else {
		if ( cellTo && cellTo->m_value ) {
			m_curCell = cellTo->m_id;
			cellTo->m_selected = true;
		}
	}
	
	return true;
}

bool LinesModel::update() {
	bool bOkGrid;
	
	int score = 0;
	int scoreInter;
	
	do {
		scoreInter = m_board->findLines(true, m_nbCellPerLine, 0);
		
		if ( scoreInter ) {
			score += scoreInter;
			m_score.m_value += scoreInter;
			
			do {
				bOkGrid = true;
				
				for ( int l = m_lMax-1 ; l > 0  ; --l ) {
					for ( int c = 0 ; c < m_cMax ; ++c ) {
						LinesCell* control = (LinesCell*)get(c, l);  
						if ( control->m_value == 0 ) {
							LinesCell* pUpItem = (LinesCell*)get(c, l-1);
							
							echangeCell((CellRef)&control, (CellRef)&pUpItem);
							
							bOkGrid = false;
						}
					}
				}
				
				for ( int c = 0 ; c < m_cMax ; ++c ) {
					LinesCell* control = (LinesCell*)get(c, 0);  
					if ( control->m_value == 0 ) {
						control->m_value = ( System::Math::random(m_nbBitmap) ) + 1;						
						bOkGrid = false;
					}
				}
			}
			while ( !bOkGrid );
		}
	}
	while ( scoreInter );
	
	return score?true:false;
}

bool LinesModel::save(File& file) {
	if ( BoardModel::save(file) ) {
		if ( m_pNxtBoard->save(file) ) {
			file << m_score;
			return true;
		}
	}
	return false;
}

bool LinesModel::load(File& file) {
	if ( BoardModel::load(file) ) {
		if ( m_pNxtBoard->load(file) ) {
			file >> m_score;
			return true;
		}
	}
	return false;
}
