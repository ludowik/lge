#pragma once

#include "Control.h"

ImplementClass(IntegerControl) : public Control {
private:
	int m_data;
	
public:
	int& m_value;
	int m_digit;
	
public:
	IntegerControl(int value=0, int digit=8);
	IntegerControl(int* pvalue, int digit=8);

	virtual ~IntegerControl();
	
public:
	virtual void computeSize(GdiRef gdi);  
	virtual void draw(GdiRef gdi);
	
};
