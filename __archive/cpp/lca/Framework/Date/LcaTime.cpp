#include "System.h"
#include "LcaTime.h"

Time::Time() : Object("Time") {
	m_time = System::Time::getTime();
}

char* Time::asString(bool showSecond) {
	System::Time::Time time = m_time;
	
	static String info;
	if ( showSecond ) {
		info.format("%02ld:%02ld:%02ld", time.hour, time.minute, time.second);		
	}
	else {
		info.format("%02ld:%02ld", time.hour, time.minute);		
	}
	
	return info.getBuf();
}

int Time::update() {
	m_time = System::Time::getTime();
	return 0;
}

void Time::set(int hour, int minute, int second) {
	m_time.hour = hour+minute/60;
	m_time.minute = minute%60+second/60;
	m_time.second = second%60;
}

void Time::add(int second) {
	m_time.hour += second/60/60;
	m_time.minute += second/60;
	m_time.second += second%60;
	
	if ( m_time.second >= 60 ) {
		m_time.minute += m_time.second / 60;
		m_time.second = m_time.second % 60;
	}
	
	if ( m_time.minute >= 60 ) {
		m_time.hour += m_time.minute / 60;
		m_time.minute = m_time.minute % 60;
	}	
}

void Time::sub(int second) {
	m_time.hour   -= second/60/60;
	m_time.minute -= second/60;
	m_time.second -= second%60;
	
	if ( m_time.second < 0 ) {
		m_time.minute -= 1 + abs(m_time.second) / 60;
		m_time.second = 60 - abs(m_time.second) % 60;

		if ( m_time.minute < 0 ) {
			m_time.hour -= 1 + abs(m_time.minute) / 60;
			m_time.minute = 60 - abs(m_time.minute) % 60;
			
			if ( m_time.hour < 0 ) {
				m_time.hour   = 0;
				m_time.minute = 0;
				m_time.second = 0;
			}
		}
	}
}

int Time::get() {
	return ( ( m_time.hour * 60 ) + m_time.minute ) * 60 + m_time.second;
}

int Time::hour() {
	return m_time.hour;
}

int Time::minute() {
	return m_time.minute;
}

int Time::second() {
	return m_time.second;
}

// TODO : gérer intelligement le timer
Timer::Timer() : Time() {
	m_modeChrono = true;
	m_ellapsedTimeMilliseconds = 0;

	timerInit(true);

	set(0, 0, 0);
}

int Timer::timerInit(bool set) {
	if ( set ) {
		m_startTimeSeconds = ellapsedSeconds();
		m_startTimeMilliseconds = ellapsedMilliseconds();
	}
	return m_startTimeMilliseconds;
}

int Timer::timerWait(int delay) {
	int to;
	int from = System::Time::ellapsedMilliseconds();
	do {
		to = System::Time::ellapsedMilliseconds();
	}
	while ( to-from < delay );
	
	delay = to-from;	
	return delay;
}

int Timer::timerUpdate() {
	int toSeconds = ellapsedSeconds();
	int toMilliseconds = ellapsedMilliseconds();

	int delaySeconds = toSeconds-m_startTimeSeconds;
	int delayMilliseconds = toMilliseconds-m_startTimeMilliseconds;
	
	if ( m_modeChrono ) {
		add(delaySeconds);
	}
	else {
		sub(delaySeconds);
	}
	
	m_startTimeSeconds = toSeconds;
	m_startTimeMilliseconds = toMilliseconds;

	m_ellapsedTimeMilliseconds += delayMilliseconds;
	
	return delayMilliseconds;
}

int Timer::timerDelay() {
	return System::Time::ellapsedMilliseconds()-m_startTimeMilliseconds;
}

int Timer::ellapsedSeconds() {
	System::Time::Time time = System::Time::getTime();
	return ( ( time.hour * 60 ) + time.minute ) * 60 + time.second;
}

int Timer::ellapsedMilliseconds() {
	return System::Time::ellapsedMilliseconds();
}

int Timer::ellapsedTicks() {
	return System::Time::ellapsedTicks();
}

void Timer::sleep(int delay) {
	System::Time::sleep(delay);
}
