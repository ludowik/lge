#pragma once

#include "Control.h"

ImplementClass(RadioButtonControl) : public Control {
public:
	static int g_iidButton;
	int* m_iidButton;
	
public:
	RadioButtonControl(const char* text, int* pidButton=&g_iidButton, int oid=-1);
	virtual ~RadioButtonControl();
	
public:
	virtual void computeSize(GdiRef gdi);  
	virtual void draw(GdiRef gdi);
	
	virtual bool touchBegin(int x, int y);
	
};
