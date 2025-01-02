#pragma once

#include "Control.h"

ImplementClass(StaticControl) : public Control {
private:
	String m_data;

public:
	String& m_value;

public:
	StaticControl(const char* value);
	StaticControl(String* pvalue);
	virtual ~StaticControl();
	
public:
	virtual void computeSize(GdiRef gdi);  
	virtual void draw(GdiRef gdi);
	
};
