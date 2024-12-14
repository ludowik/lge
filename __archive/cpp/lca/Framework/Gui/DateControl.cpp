#include "System.h"
#include "DateControl.h"

DateControl::DateControl() : StaticControl(&m_text) {
	m_class = "DateControl";
	m_layoutText = posWCenter|posHCenter;
	
	m_text = m_date.asString();
	
	m_showLongDate = false;
}

DateControl::~DateControl() {
}

void DateControl::computeSize(GdiRef gdi) {
	m_text = m_date.asString(m_showLongDate);
	StaticControl::computeSize(gdi);
}

void DateControl::draw(GdiRef gdi) {
	m_text = m_date.asString(m_showLongDate);
	StaticControl::draw(gdi);
}
