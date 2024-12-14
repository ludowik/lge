#pragma once

ImplementClass(Cell) : public Control {
private:
	sint m_rvalue;

public:
	sint& m_value;
	
	Position m_posInBoard;
	
	int m_margin;
	int m_level;
	
public:
	Cell(int c, int l, sint* pvalue, int id);
	virtual ~Cell();
	
public:
	virtual void unselect();

public:
	virtual int getIndexBitmapFromID();

public:
	virtual void draw(GdiRef gdi);
	
public:
	virtual bool load(File& file);
	virtual bool save(File& file);
	
};