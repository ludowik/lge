#pragma once

ImplementClass(BlockModel) : public BoardModel {
public:
	BlockModel();
	virtual ~BlockModel();
	
public:
	virtual bool action(CellRef cell);
	
public:
	virtual int killItem(int id, int iObject, int bShowKillOrCalc);
	
	virtual bool update();
	
};
