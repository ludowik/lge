#pragma once

ImplementClass(BejeweledModel) : public BoardModel {
public:
	int m_nbCellPerLine;
	
public:
	BejeweledModel();
	virtual ~BejeweledModel();
	
public:
	virtual CellRef newCell(int id, int c, int l);

public:
	virtual bool action(CellRef cell);
	
public:
	bool update();
	
	bool isGameOver();
	
};
