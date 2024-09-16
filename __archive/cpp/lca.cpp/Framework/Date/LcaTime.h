#pragma once

ImplementClass(Time) : public Object {
public:
	System::Time::Time m_time;
	
public:
	Time();
	Time(int second);

public:
	virtual char* asString(bool showSecond);
	
public:
	int update();

public:
	void set(int hour, int minute, int second);
	int get();
	
public:
	void add(int second);
	void sub(int second);
	
public:
	int hour();
	int minute();
	int second();
	
};

ImplementClass(Timer) : public Time {
public:
	bool m_modeChrono;

	int m_ellapsedTimeMilliseconds;
	
private:
	int m_startTimeSeconds;
	int m_startTimeMilliseconds;
	
public:
	Timer();
	
public:
	int timerInit(bool set=true);
	int timerWait(int delay);
	int timerUpdate();
	int timerDelay();
	
public:
	int ellapsedSeconds();
	int ellapsedMilliseconds();
	int ellapsedTicks();
	
public:
	void sleep(int delay);
	
};
