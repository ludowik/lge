#include "System.h"
#include "RadioButtonControl.h"

int RadioButtonControl::g_iidButton = 0;

RadioButtonControl::RadioButtonControl(const char* text, int* iidButton, int oid) : Control() {
	m_class = "RadioButtonControl";
	m_text = text;
	m_layoutText = posLeftAlign|posHCenter;
	
	m_iidButton = iidButton;
	if ( m_iidButton && *m_iidButton == oid ) {
		m_checked = true;
	}
	else {
		m_checked = false;
	}
}

RadioButtonControl::~RadioButtonControl() {
}

void RadioButtonControl::computeSize(GdiRef gdi) {
	Control::computeSize(gdi, m_text);
	m_rect.w += m_hText;
}

void RadioButtonControl::draw(GdiRef gdi) {
	Color color = blueLight;

	int r = System::Media::getMachineType()==iPad?12:6;

	int x = m_rect.x+r;
	int y = m_rect.bottom()-m_rect.h/2;
	
	gdi->circle(x, y, r, color, color);
	
	r -= 1;
	gdi->circle(x, y, r, white, white);
	
	if ( m_checked ) {
		r -= 2;
		gdi->circle(x, y, r, color, color);
	}
	
	gdi->text(xLayoutText()+m_rect.h, yLayoutText(), m_text, m_textColor);
}

bool RadioButtonControl::touchBegin(int x, int y) {
	m_checked = true;
	
	foreach ( ControlRef , ctrl , *m_parent ) {
		if ( ctrl != this && ctrl->isKindOf("RadioButtonControl") ) {
			RadioButtonControl* radio = (RadioButtonControl*)ctrl;
			radio->m_checked = false;
		}
	}
	
	if ( m_iidButton ) {
		m_iidButton[0] = m_id;
	}
	
	return true;
}
