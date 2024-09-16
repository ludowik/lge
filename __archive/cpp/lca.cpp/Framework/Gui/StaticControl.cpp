#include "System.h"
#include "StaticControl.h"

StaticControl::StaticControl(const char* value) : Control(), m_value(m_data) {
	m_class = "StaticControl";
	m_value = value;
}

StaticControl::StaticControl(String* pvalue) : Control(), m_value(*pvalue) {
	m_class = "StaticControl";
}

StaticControl::~StaticControl() {
}

void StaticControl::computeSize(GdiRef gdi) {
	Control::computeSize(gdi, m_value);
}

void StaticControl::draw(GdiRef gdi) {
    Control::draw(gdi);
	gdi->text(
		xLayoutText(),
		m_yOrigin+yLayoutText(), m_value, m_textColor, m_fontName, m_fontSize);
}
