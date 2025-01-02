#pragma once

ImplementClass(SudokuCell) : public Cell {
public:
	bool m_system;
	bool m_selectNumber;
	
public:
	bool m_number[9];
	
public:
	SudokuCell(int c, int y, sint* pvalue, int id);
	virtual ~SudokuCell();
	
public:
	virtual void unselect();

public:
	virtual void draw(GdiRef gdi);
	
public:
	int get1Candidat();
	
public:
	virtual bool load(File& file);
	virtual bool save(File& file);

};

