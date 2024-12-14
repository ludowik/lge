#include "System.h"
#include "CalendarControl.h"

CalendarControl::CalendarControl() {
	m_class = "CalendarControl";
	
	// Memo des jours et des mois
	char s[256+1];
	memset(s, 0, sizeof(s));
	
	for ( int i = 0 ; i < NB_MONTH ; ++i ) {
		m_csLMonths[i] = System::Time::getMonthName(i, true);
		m_csSMonths[i] = System::Time::getMonthName(i, false);
	}
	
	for ( int i = 0 ; i < NB_DAY ; ++i ) {
		m_csLWeekDays[i] = System::Time::getDayName(i, true);
		m_csSWeekDays[i] = System::Time::getDayName(i, false);
	}
	
	m_iFirstDayOfWeek = System::Time::getFirstDayOfWeek();
	
	// Mode d'affichage
	m_eDayMode  = dmLetter;
	m_eDrawMode = dmEnlarge;
	m_eWeekMode = wm1Month7Days;
	
	// Aujourd'hui
	m_rToday = Date();
	
	cx = 0; // Decalage x
	cy = 0; // Decalage y
	
	mx = 2; // Marge x
	my = 2; // Marge y
	
	wmax = 0;
	hmax = 0;
}

CalendarControl::~CalendarControl() {
}

Date CalendarControl::getNextMonth(Date rCurrMonth) {
	Date rNextMonth;
	rNextMonth = rCurrMonth;
	
	// Debut du mois de base
	rNextMonth.add(-NB_DAYS(rNextMonth.getDay()-1));
	
	// On change de mois
	rNextMonth.add(NB_DAYS(31));
	
	// On se met au debut
	rNextMonth.add(-NB_DAYS(rNextMonth.getDay()-1));
	return rNextMonth;
}

Date CalendarControl::getPrevMonth(Date rCurrMonth) {
	Date rPrevMonth;
	rPrevMonth = rCurrMonth;
	
	// Fin du mois de base
	rPrevMonth.add(-NB_DAYS(rPrevMonth.getDay()-1));
	rPrevMonth.add(NB_DAYS(DaysInMonth(rPrevMonth)-1));
	
	// On change de mois
	rPrevMonth.add(NB_DAYS(31));
	
	// On se met au debut
	rPrevMonth.add(NB_DAYS(rPrevMonth.getDay()-1));
	return rPrevMonth;
}

int CalendarControl::getIndexDayInWeek(int iFirstIsMonday, int iFirstIsParam) {
	if ( iFirstIsParam==-1 ) {
		iFirstIsParam = m_iFirstDayOfWeek;
	}
	
	int iIndex = iFirstIsParam+iFirstIsMonday;
	if ( iIndex>6 ) {
		iIndex = (iIndex-1)%6;
	}
	return iIndex;
}

int CalendarControl::DaysInMonth(Date rCurrMonth) {
	Date d(getNextMonth(rCurrMonth)-rCurrMonth);
	return d.getDay();
}

const char* CalendarControl::getDay(int i) {
	// TODO
	return "";

	switch ( m_eDayMode ) {
		case dmLetter: {
			return m_csSWeekDays[i].left(1);
		}
		case dmShort: {
			return m_csSWeekDays[i];
		}
		case dmLong: {
			return m_csLWeekDays[i];
		}
		default: {
			assert(0);
			break;
		}
	}
	return "";
}

int CalendarControl::SetFirstDayOfWeek(int iFirst) {
	int iOldFirst = m_iFirstDayOfWeek;
	m_iFirstDayOfWeek = iFirst;
	if ( m_iFirstDayOfWeek!=0 ) {
		m_eWeekMode = wm1Month7Days;
	}
	return iOldFirst;
}

int CalendarControl::getFirstDayOfWeek() {
	return m_iFirstDayOfWeek;
}

CalendarControl::enumDayMode CalendarControl::SetDayMode(enumDayMode  eMode) {
	CalendarControl::enumDayMode eOldMode = m_eDayMode;
	m_eDayMode = eMode;
	return eOldMode;
}

CalendarControl::enumDrawMode CalendarControl::SetDrawMode(enumDrawMode eMode) {
	CalendarControl::enumDrawMode eOldMode = m_eDrawMode;
	m_eDrawMode = eMode;
	return eOldMode;
}

CalendarControl::enumWeekMode CalendarControl::SetWeekMode(enumWeekMode eMode) {
	CalendarControl::enumWeekMode eOldMode = m_eWeekMode;
	m_eWeekMode = eMode;
	switch ( m_eWeekMode ) {
		case wm1Month7Days:
		case wm1Week7Days: {
			m_iFirstDayOfWeek = System::Time::getFirstDayOfWeek();
			break;
		}
		case wm1Month5Days:
		case wm1Week5Days: {
			m_iFirstDayOfWeek = 0;
			break;
		}
		case wm1Month5DaysWE:
		case wm1Week5DaysWE: {
			m_iFirstDayOfWeek = 0;
			break;
		}
	}
	return eOldMode;
}

CalendarControl::enumDayMode  CalendarControl::getDayMode () { return m_eDayMode ;};
CalendarControl::enumDrawMode CalendarControl::getDrawMode() { return m_eDrawMode;};
CalendarControl::enumWeekMode CalendarControl::getWeekMode() { return m_eWeekMode;};

/////////////////////////////////////////////////////////////////////////////
// CalendarControl drawing

#define WC (wmax+2*mx) // Largeur d'une cellule
#define HC (hmax+2*my) // Hauteur d'une cellule
#define HE (hj  +2*my) // Hauteur d'entÍte

void CalendarControl::computeSize(GdiRef gdi) {
	m_rect.w = 200;
	m_rect.h = 140;
}

void CalendarControl::draw(GdiRef gdi,
						   Date& rNextDate,
						   Rect& rCellRect,
						   int iDayOfWeek,
						   int iCurDayOfWeek,
						   int i,
						   int nbDaysInCurrMonth,
						   int x,
						   int y,
						   enumDrawMode eDrawMode) {
	String csDay;
	
	// Le texte
	if ( m_eDrawMode == dmEnlarge ) {
		// Le premier jour du mois precedent
		if ( i == -iDayOfWeek )
			csDay.format("%d %s", rNextDate.getDay(), rNextDate.getMonthName());
		// Le premier jour du mois
		else if ( i == 0 )
			csDay.format("%d %s", rNextDate.getDay(), rNextDate.getMonthName());
		// Le premier jour du mois suivant
		else if ( i == nbDaysInCurrMonth )
			csDay.format("%d %s", rNextDate.getDay(), rNextDate.getMonthName());
		// Tous les autres
		else
			csDay = rNextDate.getDay();
	}
	else {
		csDay = rNextDate.getDay();
	}
	
	Color textColor = white;
	if ( eDrawMode!=dmCalc ) {
		switch ( m_eWeekMode ) {
			case wm1Month5DaysWE:
			case wm1Week5DaysWE: {
				if ( iCurDayOfWeek == 5 )  {
					rCellRect.x = x+mx;
					rCellRect.y = y+my;
					
					rCellRect.w = wmax;
					rCellRect.y = hmax/2 - my;
					break;
				}
				else if ( iCurDayOfWeek == 6 ) 
				{                                          
					rCellRect.h = hmax;
					
					rCellRect.x = (int)(x+mx-(WC));
					rCellRect.y = (int)(y+my+hmax/2+my);
					
					rCellRect.w = wmax;
					break;
				}
			}
			default: {
				rCellRect.x = x+mx;
				rCellRect.y  = y+my;
				
				rCellRect.w = wmax;
				rCellRect.h = hmax;
				break;
			}
		}
		
		// Couleur du fond
		Color rgbBack;
		if ( i < 0 || nbDaysInCurrMonth <= i ) // Jour precedent et suivant le mois
			rgbBack = blue;
		else                               // Jour du mois
			rgbBack = white;
		
		// Le cadre
		rCellRect.inset(1, 1);
		gdi->rect(&rCellRect);
		
		// Couleur du texte
		if ( i < 0 || nbDaysInCurrMonth <= i ) // Jour precedent et suivant le mois
			textColor = silver;
		else if ( rNextDate == m_rToday )    // Aujourd'hui
			textColor = red;
		else                               // Jour du mois
			textColor = black;
	}
	
	// Affichage du texte
	gdi->text(rCellRect.x, rCellRect.y, csDay, textColor);
	
	if ( eDrawMode==dmCalc ) {
		switch ( m_eWeekMode ) {
			case wm1Month5DaysWE:
			case wm1Week5DaysWE: {
				if ( iCurDayOfWeek==5 )  {
					wmax = max(wmax, rCellRect.w);
					hmax = max(hmax, rCellRect.h*2);
				}
				break;
			}
			default: {
				wmax = max(wmax, rCellRect.w);
				hmax = max(hmax, rCellRect.h);
				break;
			}
		}
	}
}

void CalendarControl::draw(GdiRef gdi, Date& rDay, Rect& rRect, enumDrawMode eDrawMode) {
	// Definition des alignements
	cx = 0; // Decalage x
	cy = 0; // Decalage y
	
	mx = 2; // Marge x
	my = 2; // Marge y
	
	int hj = 22;
	
	switch ( eDrawMode ) {
		case dmCalc:
		case dmRepeat:
		case dmDraw: {
			cx = 1;
			cy = 1;
			break;
		}
	}
	
	// On part de...
	int X = rRect.x+cx;
	int Y = rRect.y+cy;
	
	// Debut du mois
	Date rCurrMonth(rDay);
	rCurrMonth -= NB_DAYS(rCurrMonth.getDay()-1);
	
	// Mois precedent
	Date rPrevMonth = getPrevMonth(rCurrMonth);
	
	// Mois suivant
	Date rNextMonth = getNextMonth(rCurrMonth);
	
	// Nombre de jour dans le mois et dans le mois precedent
	int nbDaysInCurrMonth = DaysInMonth(rCurrMonth);
//	int nbDaysInPrevMonth = DaysInMonth(rPrevMonth);
	
	// Jour de le semaine de depart
	int iDayOfWeek = rCurrMonth.getDayOfWeek()-1;
	
	// Calage sur semaine commencant au lundi
	iDayOfWeek = getIndexDayInWeek(iDayOfWeek, 6);
	
	// Et decalage par rapport au premier jour affiche dans la semaine
	int nbDay  = NB_DAY;
	int nbWeek = NB_WEEK;
	switch ( m_eWeekMode ) {
		case wm1Month7Days: {
			iDayOfWeek -= m_iFirstDayOfWeek;
			if ( iDayOfWeek<0 ) {
				iDayOfWeek = NB_DAY+iDayOfWeek;
			}
			nbDay  = NB_DAY;
			nbWeek = NB_WEEK;
			break;
		}
		case wm1Month5DaysWE: {
			nbDay  = NB_DAY-1;
			nbWeek = NB_WEEK;
			break;
		}
		case wm1Month5Days: {
			nbDay  = NB_DAY-2;
			nbWeek = NB_WEEK;
			break;
		}
		case wm1Week7Days: {
			iDayOfWeek -= m_iFirstDayOfWeek;
			if ( iDayOfWeek<0 ) {
				iDayOfWeek = NB_DAY+iDayOfWeek;
			}
			nbDay  = NB_DAY;
			nbWeek = 1;
			break;
		}
		case wm1Week5DaysWE: {
			nbDay  = NB_DAY-1;
			nbWeek = 1;
			break;
		}
		case wm1Week5Days: {
			nbDay  = NB_DAY-2;
			nbWeek = 1;
			break;
		}
	}
	
	// Jour en cours d'affichage
	Date rNextDate(rCurrMonth);
	rNextDate -= NB_DAYS(iDayOfWeek);
	
	// Calcul de la taille mini d'une cellule
	Rect rCellRect(0,0,0,0);
	
	switch ( eDrawMode ) {
		case dmCalc: {
			wmax = 0;
			hmax = 0;
			break;
		}
		case dmDraw:
		case dmRepeat: {
			draw(gdi, m_rToday, rRect, dmCalc);
			break;
		}
		case dmEnlarge: {
			wmax = (rRect.w-(nbDay )*2*mx-2*cx   )/(nbDay );
			hmax = (rRect.h-(nbWeek)*2*my-2*cy-HE)/(nbWeek);
			
			X = rRect.x+(int)((rRect.w-((nbDay )*(WC)+2*cx   ))/2);
			Y = rRect.y+(int)((rRect.h-((nbWeek)*(HC)+2*cy+HE))/2);
			break;
		}
	}
	
	int x = X;
	int y = Y;
	
	// Affichage des entÍtes des jours
	int i = 0;
	for ( i = 0 ; i < nbDay ; ++i ) {
		if ( eDrawMode!=dmCalc ) {
			rCellRect.x = x+mx;
			rCellRect.y = y+my;
			
			rCellRect.w  = wmax;
			rCellRect.h = hj;
			
			rCellRect.inset(1, 1);
			gdi->rect(&rCellRect, silver);
			rCellRect.outset(1, 1);
			
			gdi->rect(&rCellRect);
		}
		
		switch ( m_eWeekMode ) {
			case wm1Month7Days:
			case wm1Week7Days: {
				String s(getDay(getIndexDayInWeek(i)));
				gdi->text(rCellRect.x, rCellRect.y, s);
				break;
			}
			case wm1Month5DaysWE:
			case wm1Week5DaysWE: {
				if ( i==5 ) {
					String csDay;
					if ( m_eDayMode==dmLong ) {
						m_eDayMode = dmShort;
						String d1(getDay(i)); 
						String d2(getDay(i+1)); 
						csDay = d1+"/"+d2;
						m_eDayMode = dmLong;
					}
					else {
						String d1(getDay(i)); 
						String d2(getDay(i+1)); 
						csDay = d1+"/"+d2;
					}
					gdi->text(rCellRect.x, rCellRect.y, csDay);
				}
				else {
					String s(getDay(i));
					gdi->text(rCellRect.x, rCellRect.y, s);
				}
				break;
			}
			default: {
				String s(getDay(i));
				gdi->text(rCellRect.x, rCellRect.y, s);
				break;
			}
		}
		
		if ( eDrawMode==dmCalc ) {
			wmax = max(wmax, rCellRect.w);
			hmax = max(hmax, rCellRect.h);
		}
		
		x += WC;
	}
	
	// Affichage des jours
	x  = X;
	y += HE;
	
	i = -iDayOfWeek;// Pour les jours avant le mois courant
	int j = NB_DAY*NB_WEEK-nbDaysInCurrMonth+i;
	int iCurDayOfWeek = 0;
	
	for ( int l=0 ; l<nbWeek && i<nbDaysInCurrMonth+j ; ++l ) {
		for ( int c=0 ; c<nbDay && i<nbDaysInCurrMonth+j ; ++c ) {
			draw(gdi,
				 rNextDate,
				 rCellRect,
				 iDayOfWeek,
				 iCurDayOfWeek,
				 i,
				 nbDaysInCurrMonth,
				 x,
				 y,
				 eDrawMode);
			
			if ( eDrawMode!=dmCalc ) {
				switch ( m_eWeekMode ) {
					case wm1Month5DaysWE:
					case wm1Week5DaysWE: {
						if ( iCurDayOfWeek==5 )  {
							c--;
						}
					}
				}
			}
			
			iCurDayOfWeek++;
			
			if ( eDrawMode!=dmCalc ) {
				bool bChangeLine = false;
				if (( m_eWeekMode==wm1Month7Days   || m_eWeekMode==wm1Week7Days   ) && iCurDayOfWeek>=NB_DAY ||
					( m_eWeekMode==wm1Month5DaysWE || m_eWeekMode==wm1Week5DaysWE ) && iCurDayOfWeek>=NB_DAY ||
					( m_eWeekMode==wm1Month5Days   || m_eWeekMode==wm1Week5Days   ) && iCurDayOfWeek>=NB_DAY-2 ) {
					bChangeLine = true;
				}
				
				if ( bChangeLine ) {
					switch ( m_eWeekMode ) {
						case wm1Month5Days:
						case wm1Week5Days: {
							rNextDate += NB_DAYS(2);
							i += 2;
							break;
						}
					}
					
					// On passe la ligne car fin de semaine
					iCurDayOfWeek = 0;
					x = X;
					y += HC;
				}
				else {
					x += WC;
				}
			}
			
			rNextDate += NB_DAYS(1);
			i += 1;
		}
	}
	
	switch ( eDrawMode ) {
		case dmCalc:
		case dmDraw:
		case dmRepeat: {
			rRect.w = (nbDay )*(WC)+2*cx;
			rRect.h = (nbWeek)*(HC)+2*cy+HE;
			break;
		}
	}
	
	if ( eDrawMode!=dmCalc ) {
		gdi->rect(&rRect);
	}
}

void CalendarControl::draw(GdiRef gdi) {
	gdi->rect(&m_rect);
	
	switch ( m_eDrawMode ) {
		case dmDraw: {
			Rect rRect(m_rect);
			draw(gdi, m_rToday, rRect, dmDraw);
			break;
		}
		case dmRepeat: {
			Rect rRect(m_rect);
 			draw(gdi, m_rToday, rRect, dmCalc);
			
			int w = rRect.w;
			int h = rRect.h;
			
			int c = m_rect.w/w;
			int l = m_rect.h/h;
			
			int x = (int)((m_rect.w-w*c)/2);
			int y = (int)((m_rect.h-h*l)/2);
			
			rRect.y = y;
			
			Date rCurrDate = m_rToday;
			for ( int il=0;il<l;++il ) {
				rRect.x = x;
				
				for ( int ic=0;ic<c;++ic ) {
					draw(gdi, rCurrDate, rRect);
					rCurrDate = getNextMonth(rCurrDate);
					
					rRect.x = rRect.right();
				}
				
				rRect.y = rRect.bottom();
			}
			break;
		}
		case dmEnlarge: {
			draw(gdi, m_rToday, m_rect, dmEnlarge);
			break;
		}
	}
}
