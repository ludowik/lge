#pragma once

/*ImplementClass(Position) : public Object {
public:
	int m_x;
	int m_y;
	
	bool m_exist;
	
public:
	Position();
	Position(int x, int y);
	
};*/
struct Position {
	int m_x;
	int m_y;
	
	bool m_exist;
	
	Position();
	Position(int x, int y);
	
};

ImplementClass(Move) : public Object {
public:
	Position m_start;
	Position m_end;
	
public:
	Move();
	Move(Position start, Position end);
	
};

ImplementClass(Board) : public Object {
public:
	bool m_fromTo;
	
	int m_w;
	int m_h;
	
	int m_depth;
	
	sint* m_values;
	
public:
	Board(int w, int h);
	virtual ~Board();
	
public:
	inline int getUser(int val) {
		switch ( sign(val) ) {
			case  1: return 1;
			case -1: return 2;
		}
		return 0;
	}
	
	inline int getType(int val) {
		return abs(val);
	}  
	
	inline int getOponent(int user) {
		switch ( user ) {
			case 1: return 2;
			case 2: return 1;
		}
		return 1;
	}
	
	inline int getVal(int user, int type=1) {
		switch ( user ) {
			case 1: return  type;
			case 2: return -type;
		}
		return  0;
	}
	
public:
	virtual sint* create();
	
	virtual sint* push();
	virtual void pop(sint* cells);
	
	virtual void init();
	
	virtual sint get(Position& pos);  
	virtual sint set(Position& pos, sint val);
	
	virtual void getMovesList(List& rList, int user);
	virtual void getMovesList(List& rList, int user, Position from);
	
	virtual bool testMove(Move& move, int user);
	virtual bool execMove(Move& move, int user);
	
	virtual int getBestMove(Move& bestMove, int user);
	virtual int getBestMove(Move& bestMove, int user, int depth);
	
	virtual int MiniMax(Move& bestMove, int user, int depth, int baseDepth);
	virtual int NegaMax(Move& bestMove, int user, int depth, int baseDepth);
	
	virtual int AlpaBeta(Move& bestMove, int user, int depth, int baseDepth, int alpha, int beta);
	
	virtual int getEvaluation();
	
	virtual void infoMove(int user, int depth, Move& move);
	
	virtual int findLines(bool bdelLine, int nbCellPerLine, int typeCell, bool bDiagonal=true);
	virtual int findLines(bool bdelLine, int nbCellPerLine, int typeCell, int x, int y, int dx, int dy);
	virtual int findLines(bool bdelLine, int nbCellPerLine, int typeCell, int x, int y, int dx, int dy, int nbCell);
	
};
