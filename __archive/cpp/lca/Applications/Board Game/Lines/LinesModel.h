#pragma once

ImplementClass(LinesModel) : public BoardModel {
public:
	int m_nbCellPerLine;
	int m_nbAddCell;
	
	BoardModel* m_pNxtBoard;
	
public:
	LinesModel();
	virtual ~LinesModel();
	
public:
	virtual void init();
	
	virtual bool action(CellRef cell);

	virtual bool update();
	
public:	
	virtual bool save(File& file);
	virtual bool load(File& file);
	
};
