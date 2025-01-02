#include "System.h"
#include "ButtonControl.h"

ButtonControl::ButtonControl(const char* text, int id) : Control(id) {
	m_class = "ButtonControl";
	m_text = text;

	m_marginEx.setwMargin(7);
	m_marginEx.sethMargin(5);
	
	m_layoutText = posWCenter|posHCenter;
}

ButtonControl::~ButtonControl() {
}

void ButtonControl::computeSize(GdiRef gdi) {
	Control::computeSize(gdi, m_text);
}

void ButtonControl::draw(GdiRef gdi) {
	gdi->button(m_rect.x, m_rect.y, m_rect.w, m_rect.h, false, gray, black);
	
	if ( m_text.getLen() ) {
		gdi->text(xLayoutText(), yLayoutText(), m_text, m_textColor);
	}
}
