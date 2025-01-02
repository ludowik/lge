#pragma once

#include "Control.h"

ImplementClass(StatusBarControl) : public Control {
public:
	StatusBarControl();
	virtual ~StatusBarControl();

public:
	virtual ControlRef add(ControlRef ctrl, LayoutType layout=0);
	virtual void draw(GdiRef gdi);
	
};
