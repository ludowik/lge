#pragma once

#include "Control.h"

ImplementClass(ButtonControl) : public Control {
public:
	ButtonControl(const char* text, int id=0);
	virtual ~ButtonControl();
	
public:
	virtual void computeSize(GdiRef gdi);  
	virtual void draw(GdiRef gdi);
	
};
