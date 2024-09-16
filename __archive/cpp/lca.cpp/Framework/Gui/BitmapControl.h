#pragma once

#include "Control.h"

ImplementClass(BitmapControl) : public Control {
private:
	Bitmap m_bitmap;
	
public:
	BitmapControl(char* id=0, int w=0, int h=0);
	virtual ~BitmapControl();
	
protected:
	virtual void computeSize(GdiRef gdi);
	virtual void draw(GdiRef gdi);
	
};
