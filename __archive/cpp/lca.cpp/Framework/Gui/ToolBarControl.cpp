#include "System.h"
#include "ToolBarControl.h"

ToolBarControl::ToolBarControl() : Control() {
	m_class = "ToolBarControl";
	
	m_wpercent = 100;
	m_hpercent = 0;
	
	m_marginEx.setMargin(4);
	m_marginIn.setMargin(3);
	
	m_layout = posLeftAlign | posBottomAlign;
	
	m_border = false;
}

ToolBarControl::~ToolBarControl() {
}

void ToolBarControl::draw(GdiRef gdi) {
	gdi->gradient(m_rect.x, m_rect.y, m_rect.w, m_rect.h, eVertical, grayLight2, grayDark2);
	Control::draw(gdi);
}

