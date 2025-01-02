#pragma once

#include "View.h"

ImplementClass(Menu) : public View {
public:
	Menu();
	virtual ~Menu();

public:
	virtual bool touchBegin(int x, int y);
	
public:
	virtual void createView();

};
