#pragma once

ImplementClass(EnlightModel) : public BoardModel {
public:
	int m_ilevel;
	int m_imovesLeft;
	int m_imovesTotal;
	
public:
	EnlightModel();
	
public:
	virtual void init();
	
	virtual bool action(CellRef cell);

	virtual bool isGameWin();

public:	
	virtual bool save(File& file);
	virtual bool load(File& file);

public:
	void enlightBoard();	
	
	void enlightCell(CellRef cell);
	void enlight(CellRef cell);
	
};
