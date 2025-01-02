#pragma once

#include "Control.h"

ImplementClass(CalendarControl) : public Control {
public:
	CalendarControl();
	virtual ~CalendarControl();
	
public:
	enum enumDayMode {
		dmLetter,
		dmShort,
		dmLong
	};
	
	enum enumDrawMode {
		dmCalc,
		dmDraw,
		dmRepeat,
		dmEnlarge
	};
	
	enum enumWeekMode {
		wm1Month7Days,
		wm1Month5Days,
		wm1Month5DaysWE,
		wm1Week7Days,
		wm1Week5Days,
		wm1Week5DaysWE
	};
	
private:
	String m_csLMonths[12];
	String m_csSMonths[12];
	
	String m_csLWeekDays[7];
	String m_csSWeekDays[7];
	
	int m_iFirstDayOfWeek;
	
	enumDayMode  m_eDayMode;
	enumDrawMode m_eDrawMode;
	enumWeekMode m_eWeekMode;
	
	Date m_rToday;
	
	int cx; // Decalage x
	int cy; // Decalage y
	
	int mx; // Marge x
	int my; // Marge y
	
	int wmax;
	int hmax;
	
public:
	int SetFirstDayOfWeek(int iFirst);
	int getFirstDayOfWeek();
	
	enumDayMode  SetDayMode (enumDayMode  eMode);
	enumDrawMode SetDrawMode(enumDrawMode eMode);
	enumWeekMode SetWeekMode(enumWeekMode eMode);
	
	enumDayMode  getDayMode ();
	enumDrawMode getDrawMode();
	enumWeekMode getWeekMode();
	
protected:
	Date getNextMonth(Date rCurMonth);
	Date getPrevMonth(Date rCurMonth);
	
	int getIndexDayInWeek(int iFirstIsMonday, int iFirstIsParam=-1);
	
	int DaysInMonth(Date rCurMonth);
	
	const char* getDay(int i);
	
	virtual void computeSize(GdiRef gdi);
	
	void draw(GdiRef gdi, Date& rDay, Rect& rRect, enumDrawMode eDrawMode=dmDraw);
	void draw(GdiRef gdi,
			  Date& rNextDate,
			  Rect& rCellRect,
			  int iDayOfWeek,
			  int iCurDayOfWeek,
			  int i,
			  int nbDaysInCurrMonth,
			  int x,
			  int y,
			  enumDrawMode eDrawMode);
	
	
	virtual void draw(GdiRef gdi);
	
};

#define NB_DAYS(nb)  (nb)
#define NB_HOURS(nb) (nb)

#define NB_DAY    7
#define NB_MONTH 12
#define NB_WEEK   5
