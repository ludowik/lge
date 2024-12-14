#include "System.h"
#include "Board.Model.h"

BoardModel::BoardModel(int cMax, int lMax, int nbStartCell, Board* board) {
	m_board = board ? board : new Board(cMax, lMax);
	m_board->init();
	
	m_nbUser = 1;

	m_cMax = cMax;
	m_lMax = lMax;
	
	m_curCell = -1;
	
	m_nbBitmap = 7;
	m_nbStartCell = nbStartCell;
	
	m_damier = false;
	
	m_bgColor1 = white;
	m_bgColor2 = grayLight;
}

BoardModel::~BoardModel() {
	if ( m_board ) {
		delete m_board;
	}
}

void BoardModel::init() {
	ModelGame::init();
	
	if ( getCount() == 0 ) {
		for ( int l = 0 ; l < m_lMax ; ++l ) {
			for ( int c = 0 ; c < m_cMax ; ++c ) {
				int id = c + l * m_cMax;
				
				CellRef cell = newCell(id, c, l);
				cell->m_view = m_view;
				
				m_cells.add(cell);
			}
		}
	}
	else {
		resetCell();
	}
	
	if ( m_board ) {
		m_board->init();
	}
	
	addCell(m_nbStartCell);
	
	if ( m_damier ) {
		for ( int x = 0 ; x < m_cMax ; ++x ) {
			for ( int y = 0 ; y < m_lMax ; ++y ) {
				if ( ( y + x ) % 2 ) {
					get(x, y)->m_bgColor = m_bgColor1;
				}
				else {
					get(x, y)->m_bgColor = m_bgColor2;
				}
			}
		}
	}
}

CellRef BoardModel::newCell(int id, int c, int l) {
	return new Cell(c, l, &m_board->m_values[ c + l * m_cMax ], id);
}

void BoardModel::checkCell(int& c, int& l, int dc, int dl, int iLevel, bool& bAsWay, bool& bFindWay, CellRef pTo) {
	CellRef pCheckCell = get(c+dc, l+dl);
	if ( pCheckCell && pCheckCell->m_level == 0 && pCheckCell->m_value == 0 ) {
		bAsWay = true;
		
		pCheckCell->m_level = iLevel+1;
		
		if ( pTo == pCheckCell ) {
			c += dc;
			l += dl;
			
			bFindWay = true;
		}
	}
}

bool BoardModel::goCell(int& c, int& l, int dc, int dl, int iLevel, CellRef& cell) {
	CellRef pCheckCell = get(c+dc, l+dl);
	if ( pCheckCell && pCheckCell->m_level == iLevel ) {
		pCheckCell->m_level = -abs(pCheckCell->m_level);
		
		c += dc;
		l += dl;
		
		cell = pCheckCell;
		
		return true;
	}
	
	return false;
}

bool BoardModel::moveCell(int& c, int& l, int dc, int dl, int iLevel, CellRef& cell) {
	CellRef checkCell = get(c+dc, l+dl);
	if ( checkCell && checkCell->m_level == iLevel ) {
		checkCell->m_value = cell->m_value;
		
		cell->m_value = 0;
		
		cell = checkCell;
		
		c += dc;
		l += dl;
		
		return true;
	}
	
	return false;
} 

bool BoardModel::findWay(CellRef pFrom, CellRef pTo) {
	return findWay(pFrom, pTo, 0);
}

bool BoardModel::findWay(CellRef pFrom, CellRef pTo, ListRef chemin) {
	if ( chemin ) {
		chemin->m_delete = false;
		chemin->removeAll();
	}
	
	bool bFindWay = false;
	
	for ( int i = 0 ; i < getCount() ; ++i ) {
		CellRef cell = (CellRef)get(i);
		cell->m_level = 0;
	}
	
	int iLevel = 1;
	pFrom->m_level = iLevel;
	
	int c = 0;
	int l = 0;
	
	bool bAsWay = false;
	do {
		bAsWay = false;
		for ( c = 0 ; c < m_cMax ; ++c ) {
			for ( l = 0 ; l < m_lMax ; ++l ) {
				CellRef cell = get(c, l);
				
				if ( cell->m_level == iLevel ) {
					checkCell(c, l,  1,  0, iLevel, bAsWay, bFindWay, pTo);
					checkCell(c, l,  0,  1, iLevel, bAsWay, bFindWay, pTo);
					checkCell(c, l, -1,  0, iLevel, bAsWay, bFindWay, pTo);
					checkCell(c, l,  0, -1, iLevel, bAsWay, bFindWay, pTo);
				}
				
				if ( bFindWay ) {
					break;
				}
			}
			
			if ( bFindWay ) {
				break;
			}
		}
		iLevel++;
	}
	while ( bAsWay && !bFindWay );
	
	if ( bFindWay ) {
		CellRef cell = pTo;
		pTo->m_level = -abs(pTo->m_level);
		
		while ( cell != pFrom && iLevel ) {
			iLevel--;
			
			if (   goCell(c, l, 1, 0, iLevel, cell)
				|| goCell(c, l, 0, 1, iLevel, cell) 
				|| goCell(c, l,-1, 0, iLevel, cell)
				|| goCell(c, l, 0,-1, iLevel, cell) ) {
				continue;
			}
		}
		
		for ( int j = 0 ; j < getCount() ; ++j ) {
			CellRef pWayCell = (CellRef)get(j);
			if ( pWayCell->m_level > 0 ) {
				pWayCell->m_level = 0;
			}
			else {
				pWayCell->m_level = abs(pWayCell->m_level);
			}
		}
		
		iLevel = 1;
		
		while ( cell!=pTo ) {
			iLevel++;
			
			if ( chemin ) {
				chemin->add(cell);
			}
			
			if (   moveCell(c, l, 1, 0, iLevel, cell)
				|| moveCell(c, l, 0, 1, iLevel, cell) 
				|| moveCell(c, l,-1, 0, iLevel, cell)
				|| moveCell(c, l, 0,-1, iLevel, cell) ) {
				continue;
			}
		}
		
		if ( chemin ) {
			chemin->add(pTo);
		}
	}
	
	return bFindWay;
}

CellRef BoardModel::get(int i) {
	return (CellRef)m_cells.get(i);
}

CellRef BoardModel::get(int c, int l) {
	if (   c < 0 || c >= m_cMax
		|| l < 0 || l >= m_lMax ) {
		return 0;
	}
	
	return (CellRef)get(c+l*m_cMax);
}

int BoardModel::getCount() {
	return m_cells.getCount();
}

int BoardModel::getNbFreeCell() {
	int nbFreeCell = 0;
	
	for ( int c = 0 ; c < m_cMax ; ++c ) {
		for ( int l = 0 ; l < m_lMax ; ++l ) {
			CellRef cell = get(c, l);
			if ( !cell->m_value ) {
				nbFreeCell++;
			}
		}
	}
	
	return nbFreeCell;
}

void BoardModel::resetCell() {
	int nItems = getCount();
	
	for ( int i = 0 ; i < nItems ; ++i ) {
		CellRef cell = (CellRef)get(i);
		cell->m_value = 0;
	}
}

void BoardModel::unselect() {
	int nItems = getCount();
	
	for ( int i = 0 ; i < nItems ; ++i ) {
		CellRef cell = (CellRef)get(i);
		cell->unselect();
	}
	
	m_curCell = -1;
}

bool BoardModel::addCell(int nbCell) {
	if ( getNbFreeCell() < nbCell ) {
		return false;
	}
	
	int nItems = getCount();
	
	while ( nbCell > 0 ) {
		int i = System::Math::random(nItems);
		
		CellRef cell = (CellRef)get(i);
		while ( cell->m_value ) {
			i++;
			if ( i == getCount() ) {
				i = 0;
			}
			cell = (CellRef)get(i);
		}
		
		cell->m_value = ( System::Math::random(m_nbBitmap) ) + 1;
		nbCell--;
	}
	
	return true;
}

void BoardModel::echangeCell(CellRef pCell1, CellRef pCell2, bool bdraw) {
	if ( !pCell1 || !pCell2 ) {
		return;
	}
	
	int iObject1 = pCell1->m_value;
	int iObject2 = pCell2->m_value;
	
	if ( !iObject1 && !iObject2 ) {
		return;
	}
	
	pCell1->m_value = iObject2;
	pCell2->m_value = iObject1;
}

bool BoardModel::update() {
	return false;
}

GameBoardModel::GameBoardModel(int cMax, int lMax, int nbStartCell, Board* board) : BoardModel(cMax, lMax, nbStartCell, board) {
	m_user = 1;
	m_nbUser = 2;

	m_showMoves = 2; // all
}

void GameBoardModel::init() {
	BoardModel::init();
	m_user = 1;
}

CellRef GameBoardModel::newCell(int id, int c, int l) {
	CellRef cell = BoardModel::newCell(id, c, l);
	
	String csText;
	csText.format("%c.%ld", 'A' + c, 1 + l);
	
	cell->m_text = csText;
	
	return cell;
}

void GameBoardModel::autoPlay() {
	System::Event::startWaitAnimation();
	
	Move bestMove;    
	m_board->getBestMove(bestMove, m_user);    
	
	execMove(bestMove);

	System::Event::stopWaitAnimation();
}

void GameBoardModel::execMove(Move& move) {
	m_board->execMove(move, m_user);
	nextUser();
}

void GameBoardModel::unselect() {
	int curCell = m_curCell; {
		BoardModel::unselect();
	}
	m_curCell = curCell;

	List rList;
	m_board->getMovesList(rList, m_user);
		
	if ( m_showMoves == 2 ) {
		for ( int i = 0 ; i < rList.getCount() ; ++i ) {
			Move* move = (Move*)rList.get(i);
			CellRef cell = get(move->m_end.m_x, move->m_end.m_y);
			if ( cell )  {
				cell->m_selected = true;
			}
		}
	}
	else if ( m_showMoves == 1 ) {
		CellRef cellFrom = (CellRef)get(curCell);
		if ( cellFrom ) {
			for ( int i = 0 ; i < rList.getCount() ; ++i ) {
				Move* move = (Move*)rList.get(i);
				
				CellRef moveFrom = get(move->m_start.m_x, move->m_start.m_y);
				CellRef moveTo   = get(move->m_end.m_x, move->m_end.m_y);
				
				if ( cellFrom == moveFrom && moveTo )  {
					moveTo->m_selected = true;
				}
			}
		}
	}
}

void GameBoardModel::nextUser() {
	m_user = m_user == 1 ? 2 : 1;
	
	List rList;
	m_board->getMovesList(rList, m_user);
	
	if ( rList.getCount() == 0 ) {
		m_user = m_user == 1 ? 2 : 1;
	}
	else {
		unselect();
	}
}

bool GameBoardModel::action(CellRef cell) {
	CellRef cellFrom = (CellRef)get(m_curCell);
	CellRef cellTo = (CellRef)cell;
	
	if ( cellFrom == cellTo || !cell ) {
		return false;
	}
		
	if ( m_board->m_fromTo )
		moveFromTo(cellTo);
	else
		moveTo(cellTo);
	
	unselect();

	return true;
}

bool GameBoardModel::idle() {
	if ( m_nbUser == 2 && m_user == 2 ) {
		autoPlay();
	}
	
	return true;
}

bool GameBoardModel::moveTo(CellRef cell) {
	if ( cell->isKindOf("Cell") ) {
		if ( m_nbUser == 2 && m_user == 2 ) {
			autoPlay();
		}
		else {
			if ( m_nbUser == 1 || m_user == 1 ) {
				Position defPosition;
				Move move(defPosition, cell->m_posInBoard);
				if ( m_board->testMove(move, m_user) ) {
					execMove(move);
				}

				return true;
			}
		}
	}
	return true;
}

bool GameBoardModel::moveFromTo(CellRef cell) {
	/* L'arrivee
	 */
	CellRef cellTo = (CellRef)cell;
	if ( m_curCell != -1 ) {
		CellRef cellFrom = (CellRef)get(m_curCell);
		if ( cellFrom != cellTo ) {
			Move move(cellFrom->m_posInBoard, cellTo->m_posInBoard);
			
			if ( m_board->testMove(move, m_user) ) {        
				m_board->execMove(move, m_user);
				m_curCell = -1;
				
				for ( int i = 0 ; i < getCount() ; ++i ) {
					CellRef cell = (CellRef)get(i);
					cell->m_selected = false;
				}
				
				nextUser();
			}
			
			cellFrom->m_selected = false;
		}
	}
	
	/* Selection de la piece de depart
	 */
	if ( cellTo ) {
		m_curCell = -1;
		
		if ( m_board->getUser(m_board->get(cellTo->m_posInBoard)) == m_user ) {
			m_curCell = cellTo->m_id;
		}
	}
	
	return true;
}

bool BoardModel::save(File& file) {
	if ( ModelGame::save(file) ) {
		for ( int c = 0 ; c < m_cMax ; ++c ) {
			for ( int l = 0 ; l < m_lMax ; ++l ) {
				CellRef cell = get(c, l);
				cell->save(file);
			}
		}
		return true;
	}
	return false;
}

bool BoardModel::load(File& file) {
	if ( ModelGame::load(file) ) {
		for ( int c = 0 ; c < m_cMax ; ++c ) {
			for ( int l = 0 ; l < m_lMax ; ++l ) {
				CellRef cell = get(c, l);
				cell->load(file);
			}
		}
		return true;
	}	
	return false;
}

bool BoardModel::onHelp(ObjectRef obj) {
	View view;
	if ( !m_view->g_gdi->isKindOf(classGdiOpenGL) ) {
		view.m_bgImage = m_view->g_gdi;
	}
	
	view.startPanel(posHCenter)->m_opaque = true; {
		String str;
		str.format("<center>%s</center></nl>"\
			       "<left>%s</left>",
			  "RulesPlay", System::String::load("RulesPlay", "Lines.Model"));
		
		view.add(new RichTextControl(str), posNextLine|posRightExtend);
		
		view.add(new ButtonControl("OK"), posNextLine|posWCenter)->setListener(&view, (FunctionRef)&View::onClose);
	}	
	view.endPanel();
	
	view.run();
	
	return true;
}

BoardAction::BoardAction(ModelRef model, CellRef from, CellRef to, int value) {
	m_from = from;
	m_to = to;
	
	m_value =  value;
}

void BoardAction::execute() {
	/*	m_from->m_value = 0;
	 m_to->m_value = m_value;
	 */
}

void BoardAction::undo() {
	m_from->m_value = m_value;
	m_to->m_value = 0;
}
