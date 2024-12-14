#include "System.h"
#include "ColorControl.h"

ColorControl::ColorControl(Color rgb) {
	m_class = "ColorControl";
	m_rgb = rgb;
}

ColorControl::~ColorControl() {
}

void ColorControl::computeSize(GdiRef gdi) {
	Control::computeSize(gdi, "W");
    
    m_rect.w = max(m_rect.w, m_rect.h);
    m_rect.h = m_rect.w;
}

void ColorControl::draw(GdiRef gdi) {
	gdi->rect(m_rect.x, m_rect.y, m_rect.w, m_rect.h, white, m_rgb);
}
