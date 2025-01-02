#include "System.h"
#include "IntegerControl.h"

IntegerControl::IntegerControl(int value, int digit) : Control(), m_value(m_data) {
	m_class = "IntegerControl";
	m_value = value;
	m_digit = digit;
	m_layoutText = posRightAlign|posHCenter;
}

IntegerControl::IntegerControl(int* pvalue, int digit) : Control(), m_value(*pvalue) {
	m_class = "IntegerControl";
	m_digit = digit;
	m_layoutText = posRightAlign|posHCenter;
}

IntegerControl::~IntegerControl() {
}

void IntegerControl::computeSize(GdiRef gdi) {
	String str('9', m_digit);
	Control::computeSize(gdi, str);
}

void IntegerControl::draw(GdiRef gdi) {
	m_text = m_value;
	
	Rect size = gdi->getTextSize(m_text);
	gdi->text(xLayout(m_layoutText, size.w), yLayoutText(), m_text, m_textColor);
}
