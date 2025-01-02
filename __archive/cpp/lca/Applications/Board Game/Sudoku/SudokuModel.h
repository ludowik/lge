#pragma once

ImplementClass(SudokuModel) : public GameBoardModel {
public:
	int m_level;
	
	int m_b;
	int m_n;
	
public:
	SudokuModel(int b=3);
	
public:
	virtual CellRef newCell(int id, int c, int l);
	
	virtual void init();
	
	virtual bool action(CellRef cell);

	virtual bool save(File& file);
	virtual bool load(File& file);
	
public:
	bool CheckBoard();
	bool CheckCell(int x, int y);
	
	bool CandidateBoard();
	bool CandidateCell(int x, int y);
	
public:
	virtual bool onReset   (ObjectRef obj);
	virtual bool onResolve (ObjectRef obj);
	virtual bool onNumber  (ObjectRef obj);
	virtual bool onGenerate(ObjectRef obj);

public:
	void reset(bool resetBoard);

	void generate();
	void generate(int srand);	
	
	bool resolve();
	
};
