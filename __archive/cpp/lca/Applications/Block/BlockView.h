#pragma once

#include "BlockModel.h"

ImplementClass(BlockView) : public BoardView {
public:
	BlockView();
	virtual ~BlockView();

public:
	virtual void loadResource(); 
};
