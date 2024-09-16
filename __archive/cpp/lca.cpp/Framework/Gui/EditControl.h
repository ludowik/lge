#pragma once

#include "Control.h"

ImplementClass(EditControl) : public Control {
public:
	int m_max;
	
public:
	EditControl(char* text=0);
	virtual ~EditControl();
	
public:
	virtual void computeSize(GdiRef gdi);  
	virtual void draw(GdiRef gdi);
	
public:
	virtual bool touchBegin(int x, int y);
	virtual bool onKey(char c);
	
};
