#include "System.h"
#include "LcaDate.h"

Date::Date() : Object("Date") {
	update();
}

Date::Date(int time) : Object("Date") {
	assert(0);
	update();
}

Date::~Date() {
}

const char* Date::asString() {
	return asString(false);
}

const char* Date::asString(bool showLongDate) {
	System::Time::Time time = System::Time::getTime();
	
	static String info;
	info.format("%ld ", time.day);
	
	info += getMonthName(showLongDate);
	
	if ( showLongDate ) {
		static String year;
		year.format(" %ld", time.year);
		info += year;
	}
	
	return info.getBuf();
}

void Date::update() {
	m_time = System::Time::getTime(); 
}

int Date::getTime() {
	return ( m_time.second+
		( m_time.minute +
		( m_time.hour +
		( m_time.day +
		( m_time.month + m_time.year*12)*30)*24)*60)*60);
}

int Date::getDay() {
	return System::Time::getTime().day;
}

int Date::getMonth() {
	return System::Time::getTime().month;
}

int Date::getYear() {
	return System::Time::getTime().year;
}

int Date::getDayOfWeek() {
	return 1;
}

const char* Date::getMonthName(bool longName) {
	return System::Time::getMonthName(getMonth(), longName);
}

void Date::add(int nday) {
}

bool Date::operator == (Date& date) {
	if ( getTime() == date.getTime() ) {
		return true;
	}
	return false;
}

void Date::operator += (int day) {
	add(day);
}

void Date::operator -= (int day) {
	add(-day);
}

int operator - (Date d1, Date d2) {
	return d1.getTime() - d2.getTime();
}
