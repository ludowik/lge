#pragma once

#include "LinesModel.h"

ImplementClass(LinesView) : public BoardView {
public:
	LinesView();
	
public:
	virtual void loadResource();
	
public:
	virtual void draw(GdiRef gdi);
	
};
