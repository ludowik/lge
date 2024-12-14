#pragma once

ImplementClass(DameModel) : public GameBoardModel {
public:
	DameModel();
	virtual ~DameModel();
	
};

ImplementClass(Dame) : public Board {
public:
	Dame(int w, int h);
	virtual ~Dame();
	
public:
	virtual void getMovesList(List& rList, int user, Position from);
	virtual int getEvaluation();
	
	virtual void init();
	
};
