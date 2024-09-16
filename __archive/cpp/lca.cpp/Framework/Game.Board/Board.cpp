#include "System.h"
#include "Board.h"

Position::Position() { // : Object("Position") {
	m_x = -1;
	m_y = -1;
	
	m_exist = false;
}

Position::Position(int x, int y) { // : Object("Position") {
	m_x = x;
	m_y = y;
	
	m_exist = true;
}

bool operator == (Position& pos1, Position& pos2) {
	if ( pos1.m_x == pos2.m_y && pos1.m_y == pos2.m_y ) {
		return true;
	}
	
	return false;
}

Move::Move() : Object("Move") {
}

Move::Move(Position start, Position end) : Object("Move"), m_start(start), m_end(end) {
	m_start = start;
	m_end = end;
}

Board::Board(int w, int h) : Object("Board") {
	m_fromTo = false;
	
	m_w = w;
	m_h = h;
	
	
#if	TARGET_IPHONE_SIMULATOR
	m_depth = 10;
#else
	m_depth = 4;
#endif
	
	m_values = create();
}

Board::~Board() {
	delete[] m_values;
}

sint* Board::create() {
	return new sint[m_w*m_h];
}

sint* Board::push() {
	sint* cells = m_values;
	m_values = create();
	memcpy(m_values, cells, sizeof(sint)*m_w*m_h);
	return cells;
}

void Board::pop(sint* cells) {
	delete[] m_values;
	m_values = cells;
}

void Board::init() {
	Position pos;
	for ( pos.m_x = 0 ; pos.m_x < m_w ; ++pos.m_x ) {
		for ( pos.m_y = 0 ; pos.m_y < m_h ; ++pos.m_y ) {
			set(pos, getVal(0, 0));
		}
	}
}

sint Board::get(Position& pos) {
	if ( pos.m_x >= 0 && pos.m_x < m_w && pos.m_y >= 0 && pos.m_y < m_h ) {
		pos.m_exist = true;
		return m_values [ pos.m_x + pos.m_y * m_w ];
	}
	
	pos.m_exist = false;
	return 0;
}

sint Board::set(Position& pos, sint val) {
	if ( pos.m_x >= 0 && pos.m_x < m_w && pos.m_y >= 0 && pos.m_y < m_h ) {
		int i = pos.m_x + pos.m_y * m_w;
		
		sint old = m_values[i];
		m_values[i] = val;
		
		pos.m_exist = true;
		return old;
	}
	
	pos.m_exist = false;
	return 0;
}

void Board::getMovesList(List& list, int user) {
	list.releaseAll();
	
	Position from;
	Position to;
	
	for ( from.m_x = 0 ; from.m_x < m_w ; ++from.m_x ) {
		for ( from.m_y = m_h-1 ; from.m_y >= 0 ; --from.m_y ) {
			if ( getUser(get(from)) == user ) {
				getMovesList(list, user, from);
			}
		}
	}
}

void Board::getMovesList(List& list, int user, Position from) {
}

bool Board::testMove(Move& move, int user) {
	List list;
	getMovesList(list, user);
	
	for ( int i = 0 ; i < list.getCount() ; ++i ) {
		MoveRef amove = (Move*)list.get(i);
		if (   move.m_start.m_x == amove->m_start.m_x && move.m_end.m_x == amove->m_end.m_x
			&& move.m_start.m_y == amove->m_start.m_y && move.m_end.m_y == amove->m_end.m_y ) {
			return true;
		}
	}
	
	return false;
}

bool Board::execMove(Move& move, int user) {
	if ( move.m_end.m_exist ) {
		if ( move.m_start.m_exist ) {
			set(move.m_end, get(move.m_start));
			set(move.m_start, getVal(0, 0));
		}
		else {
			set(move.m_end,  getVal(user, 1));
		}  
	}
	
	return true;
}

int Board::getBestMove(Move& bestMove, int user) {
	return getBestMove(bestMove, user, m_depth);
}

int Board::getBestMove(Move& bestMove, int user, int depth) {
	if ( depth % 2 ) {
		depth--;
	}
	
	return AlpaBeta(bestMove, user, depth, depth, -INT_MAX, INT_MAX);
}

#define odd(a) ((a)&1)

int Board::MiniMax(Move& bestMove, int user, int depth, int baseDepth) {
	if ( depth == 0 ) {
		return getEvaluation() * ( user == 1 ? 1 : -1 );
	}
	
	int bestScore = 0;
	int nbLines = 0;
	
	sint* cells = 0;
	
	List list;
	getMovesList(list, user);
	
	if ( odd(depth) ) { // niveaux impairs, on minimise 
		bestScore = INT_MAX;
	}
	else {
		bestScore = -INT_MAX;
	}
	
	for ( int i = 0 ; i < list.getCount() ; ++i ) {
		MoveRef amove = (Move*)list.get(i);
		infoMove(user, depth, *(amove));
		
		cells = push();
		execMove(*(amove), user);
		
		nbLines = MiniMax(bestMove, getOponent(user), depth-1, baseDepth);
		
		pop(cells);
		
		if ( odd(depth) ) { // niveaux impairs, on minimise
			if ( nbLines < bestScore ) {
				bestScore = nbLines;
				if ( depth == baseDepth ) {
					bestMove = *(amove);
				}
			}
		}
		else { // niveaux pairs, on maximise
			if ( nbLines > bestScore ) { 
				bestScore = nbLines;
				if ( depth == baseDepth ) {
					bestMove = *(amove);
				}
			}
		}
	}
	
	return bestScore;
}

int Board::NegaMax(Move& bestMove, int user, int depth, int baseDepth) {
	if ( depth == 0 ) {
		return getEvaluation() * ( user == 1 ? 1 : -1 );
	}
	
	int bestScore = 0;
	int nbLines = 0;
	
	sint* cells = 0;
	
	List list;
	getMovesList(list, user);
	
	bestScore = -INT_MAX;
	
	for ( int i = 0 ; i < list.getCount() ; ++i ) {
		MoveRef amove = (Move*)list.get(i);
		infoMove(user, depth, *(amove));
		
		cells = push();
		execMove(*(amove), user);
		
		nbLines = -NegaMax(bestMove, getOponent(user), depth-1, baseDepth);
		
		pop(cells);
		
		if ( nbLines > bestScore ) { // niveaux pairs, on maximise
			bestScore = nbLines;
			if ( depth == baseDepth ) {
				bestMove = *(amove);
			}
		}
	}
	
	return bestScore;
}

int Board::AlpaBeta(Move& bestMove, int user, int depth, int baseDepth, int alpha, int beta) {
	if ( depth == 0 ) {
		return getEvaluation() * ( user == 1 ? 1 : -1 );
	}
	
	int bestScore = 0;
	int nbLines = 0;
	
	int mode = 1;

	sint* cells = 0;
	
	sint start = 0;
	sint end   = 0;
	
	List list;
	getMovesList(list, user);
	
	bestScore = -INT_MAX;
	
	for ( int i = 0 ; i < list.getCount() ; ++i ) {
		MoveRef amove = (Move*)list.get(i);
		
		infoMove(user, depth, *(amove));
		

		if ( mode == 1 ) {
			cells = push();
		}
		else {
			start = get(amove->m_start);
			end   = get(amove->m_end);
		}

		execMove(*(amove), user);
		
		nbLines = -AlpaBeta(bestMove, getOponent(user), depth-1, baseDepth, -beta, -alpha);
		
		if ( mode == 1 ) {
			pop(cells);
		}
		else {
			set(amove->m_start, start);
			set(amove->m_end, end);
		}		
		
		if ( nbLines > bestScore ) { // niveaux pairs, on maximise
			bestScore = nbLines;
			if ( depth == baseDepth ) {
				bestMove = *(amove);
			}
		}
		
		if ( bestScore > alpha ) {
			alpha = bestScore;
		}
		if ( alpha >= beta ) {
			return alpha;
		}
	}
	
	return bestScore;
}

int Board::getEvaluation() {
	return 0;
}

void Board::infoMove(int user, int depth, Move& move) {
}

int Board::findLines(bool bdelLine, int nbCellPerLine, int typeCell, bool bDiagonal) {
	int nbLines = 0;
	
	int y;
	int x;
	
	for ( y = 0 ; y < m_h ; ++y ) {
		nbLines += findLines(bdelLine, nbCellPerLine, typeCell, 0, y, 1, 0);
		if ( bDiagonal ) {
			nbLines += findLines(bdelLine, nbCellPerLine, typeCell, 0, y, 1, 1);
		}
	}
	
	for ( x = 0 ; x < m_w ; ++x ) {
		nbLines += findLines(bdelLine, nbCellPerLine, typeCell, x, 0,  0, 1);
		if ( bDiagonal ) {
			nbLines += findLines(bdelLine, nbCellPerLine, typeCell, x, 0,  1, 1);
			nbLines += findLines(bdelLine, nbCellPerLine, typeCell, x, 0, -1, 1);
		}
	}
	
	if ( bDiagonal ) {
		for ( y = 0 ; y < m_h ; ++y ) {
			nbLines += findLines(bdelLine, nbCellPerLine, typeCell, m_w-1, y, -1, 1);
		}
	}
	
	return nbLines;
}

int Board::findLines(bool bdelLine, int nbCellPerLine, int _typeCell, int x, int y, int dc, int dl) {
	int typeCell = 0;  
	
	int nbLines = 0;  
	int nbCell = 0;
	
	int value = 0;
	
	Position pos(x, y);
	
	value = get(pos);
	
	while ( x >= 0 && x < m_w && y >= 0 && y < m_h ) {
		if ( typeCell == value && typeCell ) {
			nbCell++;
		}
		else if ( value ) {
			nbLines += findLines(bdelLine, nbCellPerLine, typeCell, x, y, dc, dl, nbCell);
			
			if ( _typeCell ) {
				if ( _typeCell == value ) {
					typeCell = value;
				}
				else {
					typeCell = 0;
				}
			}
			else {
				typeCell = value;
			}
			
			nbCell = 1;
		}
		else {
			nbLines += findLines(bdelLine, nbCellPerLine, typeCell, x, y, dc, dl, nbCell);
			
			typeCell = 0;
			
			nbCell = 0;
		}
		
		x += dc;
		y += dl;
		
		pos = Position(x, y);
		
		value = get(pos);
	}
	
	nbLines += findLines(bdelLine, nbCellPerLine, typeCell, x, y, dc, dl, nbCell);
	
	return nbLines;
}

int Board::findLines(bool bdelLine, int nbCellPerLine, int typeCell, int x, int y, int dc, int dl, int nbCell) {
	int nbLines = 0;
	
	if ( nbCell >= nbCellPerLine ) {
		int _c = x - dc;
		int _l = y - dl;
		
		nbLines += 10 + ( nbCell - nbCellPerLine );
		
		Position pos(_c, _l);
		
		int value = get(pos);    
		if ( bdelLine ) {
			while ( nbCell ) {
				set(pos, 0);
				
				_c -= dc;
				_l -= dl;
				
				pos = Position(_c, _l);
				
				value = get(pos);
				
				nbCell--;
			}
		}
	}
	
	return nbLines;
}
