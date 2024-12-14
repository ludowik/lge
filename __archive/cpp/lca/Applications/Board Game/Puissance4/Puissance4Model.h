#pragma once

#include "Board.h"
#include "Board.Model.h"

ImplementClass(Puissance4Model) : public GameBoardModel {
public:
	Puissance4Model();

};

ImplementClass(Puissance4) : public Board {
public:
	Puissance4(int w, int h);
	
public:  
	virtual void getMovesList(List& rList, int user);
	virtual int getEvaluation();
	
};
