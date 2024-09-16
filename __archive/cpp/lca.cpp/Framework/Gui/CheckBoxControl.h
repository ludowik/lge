#pragma once

#include "Control.h"

ImplementClass(CheckBoxControl) : public Control {
public:
	CheckBoxControl(const char* text);
	virtual ~CheckBoxControl();
	
public:
	virtual void computeSize(GdiRef gdi);
	virtual void draw(GdiRef gdi);
	
	virtual bool touchBegin(int x, int y);
	
};
