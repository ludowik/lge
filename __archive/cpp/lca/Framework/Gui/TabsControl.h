#pragma once

#include "Control.h"

ImplementClass(TabsPanel) : public Control {
public:
	Rect m_rectText;
	
public:
	TabsPanel(const char* text);
	virtual ~TabsPanel();
	
};

ImplementClass(TabsControl) : public Control {
public:
	int m_itab;
	
public:
	TabsControl(int id=-1);
	virtual ~TabsControl();
	
public:
	virtual void computeSize(GdiRef gdi);
	virtual void draw(GdiRef gdi);

public:
	virtual bool touchBegin(int x, int y);
	
};
