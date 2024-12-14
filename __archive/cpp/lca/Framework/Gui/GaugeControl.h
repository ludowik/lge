#pragma once

#include "Control.h"

ImplementClass(GaugeControl) : public Control {
public:
	int m_val;
	int m_max;
	
	int m_size;
	
	bool m_horizontal;
	
public:
	GaugeControl(int val=0, int max=100);
	virtual ~GaugeControl();
	
public:
	double percent();
	
public:
	virtual void computeSize(GdiRef gdi);
	virtual void draw(GdiRef gdi);
	
public:
	virtual bool touchBegin    (int x, int y);
	virtual bool touchMove     (int x, int y);
	virtual bool touchDoubleTap(int x, int y);
	
	virtual bool onChange(int x, int y);
	
};
