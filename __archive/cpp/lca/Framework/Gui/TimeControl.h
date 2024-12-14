#pragma once

#include "Time.h"
#include "StaticControl.h"

ImplementClass(TimeControlImpl) : public StaticControl {
public:
	bool m_showSeconds;
	
public:
	TimeControlImpl(bool showSeconds);
	virtual ~TimeControlImpl();
	
};

ImplementClass(TimeControl) : public TimeControlImpl {
public:
	Time m_time;
	
public:
	TimeControl(bool showSeconds=false);
	virtual ~TimeControl();
	
public:
	virtual void computeSize(GdiRef gdi);  
	virtual void draw(GdiRef gdi);
	
};

ImplementClass(TimerControl) : public TimeControlImpl {
public:
	Timer m_timer;

public:
	TimerControl(bool showSeconds=true);
	virtual ~TimerControl();
	
public:
	virtual void computeSize(GdiRef gdi);  
	virtual void draw(GdiRef gdi);
	
};
