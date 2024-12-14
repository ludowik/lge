#include "System.h"
#include "GaugeControl.h"

// v1

GaugeControl::GaugeControl(int val, int max) : Control() {
	m_class = "GaugeControl";
	m_text = "100%";
	
	m_val = val!=-1?val:0;
	m_max = max!=-1?max:100;
	
	m_size = -1;
	
	m_readOnly = true;
	
	m_horizontal = true;
	
	m_layoutText = posWCenter|posHCenter;
}

GaugeControl::~GaugeControl() {
}

void GaugeControl::computeSize(GdiRef gdi) {
	if ( m_horizontal ) {
		m_layoutText = posRightAlign|posHCenter;
	} else {
		m_layoutText = posWCenter;
	}

	Control::computeSize(gdi, "100%");
	
	if ( m_horizontal == false ) {
		int wText = m_wText;
		m_wText = m_hText;
		m_hText = wText;
	}
	
	if ( m_size == -1 ) {
		m_size = m_rect.h; 
	}
	
	if ( m_horizontal ) {
		m_rect.h = m_size;
	} else {
		m_rect.h = m_rect.w;
		m_rect.w = m_size;
	}
}

double GaugeControl::percent() {
	return divby(m_val, m_max);
}

void GaugeControl::draw(GdiRef gdi) {
	double pct = percent();
		
	int radius = (int)System::Media::getRadius();
	gdi->roundgradient(m_rect.x, m_rect.y, m_rect.w, m_rect.h, radius, eDiagonal, black, black);
	
	if ( m_horizontal ) {
		int w = (int) ( m_rect.w * pct );
		if ( w > 0 ) {
			gdi->roundgradient(m_rect.x, m_rect.y, w, m_rect.h, radius, eDiagonal, m_fgColor, m_fgColor);
		}
	} else {
		int h = (int) ( m_rect.h * pct );
		if ( h > 0 ) {
			gdi->roundgradient(m_rect.x, m_rect.y, m_rect.w, h, radius, eDiagonal, m_fgColor, m_fgColor);
		}
	}

	gdi->roundrect(m_rect.x, m_rect.y, m_rect.w, m_rect.h, radius, white);
	
	m_text.format("%ld%%", (int)(100*pct));
	computeSizeText(gdi, m_text);
	gdi->textInRect(xLayoutText(), yLayoutText(), m_rect.right(), m_rect.bottom(), m_text, m_textColor);
}

bool GaugeControl::touchBegin(int x, int y) {
	if ( !m_readOnly ) {
		return onChange(x, y);
	}
	return false;
}

bool GaugeControl::touchMove(int x, int y) {
	if ( !m_readOnly ) {
		return onChange(x, y);
	}
	return false;
}

bool GaugeControl::touchDoubleTap(int x, int y) {
	if ( !m_readOnly ) {
		return onChange(x, y);
	}
	return false;
}

bool GaugeControl::onChange(int x, int y) {
	if ( m_horizontal ) {
		m_val = max(0,min(m_max,(x-m_rect.x)*m_max/(m_rect.w-1)));
	} else {
		m_val = max(0,min(m_max,(y-m_rect.y)*m_max/(m_rect.h-1)));
	}
	return true;
}
