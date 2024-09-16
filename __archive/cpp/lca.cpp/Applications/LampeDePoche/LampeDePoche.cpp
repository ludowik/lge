#include "System.h"
#include "LampeDePoche.h"

ApplicationObject<LampeDePoche, Model> appLampe("Lampe", "Lampe", "flashlight.png");

void LampeDePoche::createUI() {
	m_marginIn.setMargin(0);
	m_marginEx.setMargin(0);
	
	m_bgColor = red;
	
	m_r = rValue(m_bgColor);
	m_g = gValue(m_bgColor);
	m_b = bValue(m_bgColor);

	add(new IntegerControl(&m_r))->m_wpercent = 100./3.;
	add(new IntegerControl(&m_g))->m_wpercent = 100./3.;
	add(new IntegerControl(&m_b))->m_wpercent = 100./3.;
}

void LampeDePoche::draw(GdiRef gdi) {
	View::draw(gdi);

	Rect windowsRect = System::Media::getWindowsSize();
	
	gdi->rect(windowsRect.w * 1./3., m_area->m_rect.bottom(), 1, windowsRect.bottom()-m_area->m_rect.bottom());
	gdi->rect(windowsRect.w * 2./3., m_area->m_rect.bottom(), 1, windowsRect.bottom()-m_area->m_rect.bottom());
}

bool LampeDePoche::touchBegin(int x, int y) {
	Rect rect = System::Media::getWindowsSize();
	
	if ( x < rect.w * 1./3. ) {
		m_mode = 1;
		m_v = rValue(m_bgColor);		
	}
	else if ( x < rect.w * 2./3. ) {
		m_mode = 2;
		m_v = gValue(m_bgColor);		
	}
	else {
		m_mode = 3;
		m_v = bValue(m_bgColor);		
	}
	
	m_from = y;
	m_to = y;
	
	return false;
}

bool LampeDePoche::touchMove(int x, int y) {
	m_to = y;
	
	int dec = m_from-m_to;
	int val = m_v+dec;
	
	val = minmax(val, 0, 255);
	
	if ( m_mode == 1 ) {
		m_bgColor = Rgb(val, gValue(m_bgColor), bValue(m_bgColor));
	}
	else if ( m_mode == 2 ) {
		m_bgColor = Rgb(rValue(m_bgColor), val, bValue(m_bgColor));
	}
	else {
		m_bgColor = Rgb(rValue(m_bgColor), gValue(m_bgColor), val);
	}
	
	m_r = rValue(m_bgColor);
	m_g = gValue(m_bgColor);
	m_b = bValue(m_bgColor);
	
	return false;
}

bool LampeDePoche::touchDoubleTap(int x, int y) {
	m_close = true;
	return false;
}
