#include "System.h"
#include "EditControl.h"

EditControl::EditControl(char* text) : Control() {
	m_class = "EditControl";
	m_text = text?text:"";
	m_max = 8;
}

EditControl::~EditControl() {
}

void EditControl::computeSize(GdiRef gdi) {
	String str('W', m_max);
	Control::computeSize(gdi, str);
}

void EditControl::draw(GdiRef gdi) {
	gdi->text(xLayoutText(), yLayoutText(), m_text, m_textColor);
	gdi->rect(m_rect.x, m_rect.y, m_rect.w, m_rect.h, m_fgColor);
}

bool EditControl::touchBegin(int x, int y) {
	/*Control::touchBegin(x, y);
	
	GetForm()->m_pfocus = this;
	
	if ( m_parent->m_cid != objKeyboardForm ) {
		KeyboardView rKeyboardForm(m_text);
		rKeyboardForm.Run();
		
		m_text = rKeyboardForm.m_pEdit->m_text;
		
		Draw();
	}*/
	
	return true;
}

bool EditControl::onKey(char c) {
	m_text += String(c);
	return true;
}
