#pragma once

ImplementClass(Board);
ImplementClass(Cell);

#include "Game.Model.h"

ImplementClass(BoardModel) : public ModelGame {
public:
	Board* m_board;
	
	Array m_cells;
	
	int m_nbUser;
	
	int m_cMax;
	int m_lMax;
	
	int m_curCell;
	
	int m_nbBitmap;
	int m_nbStartCell;
	
	bool m_damier;
	
	Color m_bgColor1;
	Color m_bgColor2;
	
public:
	BoardModel(int cMax,
			   int lMax,
			   int nbStartCell=0,
			   Board* board=0);
	virtual ~BoardModel();
	
	virtual void init();
	
	virtual CellRef newCell(int id, int c, int l);
	
	virtual bool load(File& file);
	virtual bool save(File& file);
		
	virtual bool onHelp(ObjectRef obj);

public:
	int getNbFreeCell();
	void resetCell();
	
	bool addCell(int nbCell);
	
	CellRef get(int i);
	CellRef get(int c, int l);
	
	int getCount();
	
	bool findWay(CellRef pfrom, CellRef pto, ListRef chemin);
	bool findWay(CellRef pfrom, CellRef pto);
	
	void checkCell(int& c, int& l, int dc, int dl, int iLevel, bool& bAsWay, bool& bFindWay, CellRef pto);
	bool goCell   (int& c, int& l, int dc, int dl, int iLevel, CellRef& pCell);
	bool moveCell (int& c, int& l, int dc, int dl, int iLevel, CellRef& pCell);
	
	void echangeCell(CellRef pfrom, CellRef pto, bool bdraw=true);
	
	virtual bool update();
	
	virtual void unselect();
	
};

ImplementClass(GameBoardModel) : public BoardModel {
public:
	int m_user;
	int m_showMoves;
	
public:
	GameBoardModel(int cMax,
				   int lMax,
				   int nbStartCell,
				   Board* board=0);
	
	virtual void init();
	
	virtual CellRef newCell(int id, int c, int l);
	
	virtual bool action(CellRef cell);
	
	virtual bool idle();
	
	virtual void unselect();
	
public:
	void autoPlay();
	void execMove(Move& move);
	
	void nextUser();
	
	bool moveTo    (CellRef cell);
	bool moveFromTo(CellRef cell);
	
};

ImplementClass(BoardAction) : public Action {
public:
	CellRef m_from;
	CellRef m_to;
	
	int m_value;
	
public:
	BoardAction(ModelRef model, CellRef from, CellRef to, int m_value);
	
public:
	virtual void execute();
	virtual void undo();
	
};
