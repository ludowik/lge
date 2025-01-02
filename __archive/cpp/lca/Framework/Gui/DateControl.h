#pragma once

#include "LcaDate.h"
#include "StaticControl.h"

ImplementClass(DateControl) : public StaticControl {
public:
	Date m_date;
	
	bool m_showLongDate;
	
public:
	DateControl();
	virtual ~DateControl();

public:
	virtual void computeSize(GdiRef gdi);  
	virtual void draw(GdiRef gdi);
		
};
