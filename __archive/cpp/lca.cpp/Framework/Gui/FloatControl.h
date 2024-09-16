#pragma once

#include "Control.h"

ImplementClass(FloatControl) : public Control {
private:
	double m_data;
	
public:
	double& m_value;
	int m_digit;
	int m_decimal;
	
public:
	FloatControl(double value=0., int digit=8, int decimal=2);
	FloatControl(double* pvalue, int digit=8, int decimal=2);

	virtual ~FloatControl();
	
public:
	virtual void computeSize(GdiRef gdi);  
	virtual void draw(GdiRef gdi);
	
};
