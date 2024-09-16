#include "System.h"
#include "CheckBoxControl.h"

CheckBoxControl::CheckBoxControl(const char* text) : Control() {
	m_class = "CheckBoxControl";
	m_text = text;
}

CheckBoxControl::~CheckBoxControl() {
}

void CheckBoxControl::computeSize(GdiRef gdi) {
	Control::computeSize(gdi, m_text);
	m_rect.w += m_hText;
}

void CheckBoxControl::draw(GdiRef gdi) {
	Color color = blueLight;
	
	int size = System::Media::getMachineType()==iPad?24:12;
	Rect in(m_rect.x, m_rect.bottom()-size/2-m_rect.h/2, size, size);

	int radius = 4;
	gdi->roundrect(&in, radius, color);
	
	in.inset(1, 1);
	gdi->roundrect(&in, radius, white);
	
	if ( m_checked ) {
		in.inset(2, 2);
		gdi->roundrect(&in, radius, color, color);
	}
	
	gdi->text(xLayoutText() + m_rect.h, yLayoutText(), m_text, m_textColor);
}

bool CheckBoxControl::touchBegin(int x, int y) {
	m_checked = !m_checked;
	return true;
}
