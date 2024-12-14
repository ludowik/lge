#pragma once

#include "Control.h"

ImplementClass(ColorControl) : public Control {
public:
	Color m_rgb;
	
public:
	ColorControl(Color rgb=transparentColor);
	virtual ~ColorControl();
	
public:
	virtual void computeSize(GdiRef gdi);
	virtual void draw(GdiRef gdi);
	
};
