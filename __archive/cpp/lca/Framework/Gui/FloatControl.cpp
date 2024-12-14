#include "System.h"
#include "FloatControl.h"

FloatControl::FloatControl(double value, int digit, int decimal) : Control(), m_value(m_data) {
	m_class = "FloatControl";
	m_value = value;
	m_digit = digit;
	m_decimal = decimal;
	m_layoutText = posRightAlign|posHCenter;
}

FloatControl::~FloatControl() {
}

FloatControl::FloatControl(double* pvalue, int digit, int decimal) : Control(), m_value(*pvalue) {
	m_class = "FloatControl";
	m_digit = digit;
	m_decimal = decimal;
	m_layoutText = posRightAlign|posHCenter;
}

void FloatControl::computeSize(GdiRef gdi) {
	String str('9', m_digit);
	Control::computeSize(gdi, str);
}

void FloatControl::draw(GdiRef gdi) {
	m_text = m_value;

	Rect size = gdi->getTextSize(m_text);
	gdi->text(xLayout(m_layoutText, size.w), yLayoutText(), m_text, m_textColor);
}
