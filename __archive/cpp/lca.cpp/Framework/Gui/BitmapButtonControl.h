#pragma once

#include "Control.h"

ImplementClass(BitmapButtonControl) : public Control {
public:
	Bitmap m_bitmap;
	
public:
	BitmapButtonControl(const char* id=0, const char* title=0, int w=0, int h=0);
	virtual ~BitmapButtonControl();
	
protected:
	virtual void computeSize(GdiRef gdi);	
	virtual void draw(GdiRef gdi);
	
};
