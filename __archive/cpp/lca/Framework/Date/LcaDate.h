#pragma once

ImplementClass(Date) : public Object {
private:
	System::Time::Time m_time;
	
public:
	Date();
	Date(int time);
	virtual ~Date();

public:
	virtual const char* asString();
	virtual const char* asString(bool showLongDate);
	
public:
	void update();
	
public:
	int getTime ();
	int getDay  ();
	int getMonth();
	int getYear ();
	
public:
	int getDayOfWeek();

public:
	const char* getMonthName(bool longName=false);
	
public:
	void add(int nday);

public:
	bool operator == (Date& date);
	
	void operator = (int time);

	void operator += (int day);
	void operator -= (int day);

};

int operator - (Date d1, Date d2); 
