#pragma once

#include "BejeweledModel.h"

ImplementClass(BejeweledView) : public BoardView {
public:
	BejeweledView();
	virtual ~BejeweledView();
	
public:
	virtual void loadResource();
	
};
