#pragma once

#include "Control.h"

ImplementClass(ToolBarControl) : public Control {
public:
	ToolBarControl();
	virtual ~ToolBarControl();
	
public:
	virtual void draw(GdiRef gdi);
	
};
