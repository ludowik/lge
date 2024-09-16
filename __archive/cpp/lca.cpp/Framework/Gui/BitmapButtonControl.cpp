#include "System.h"
#include "BitmapButtonControl.h"

BitmapButtonControl::BitmapButtonControl(const char* id, const char* title, int w, int h) : Control() {
	m_class = "BitmapButtonControl";
	m_layoutText = posBottomAlign|posWCenter;
	if ( id ) {
		m_bitmap.loadRes(id, w, h);
	}
	m_text = title;
	m_border = false;
}

BitmapButtonControl::~BitmapButtonControl() {
}

void BitmapButtonControl::computeSize(GdiRef gdi) {
	Rect rect = m_bitmap.m_rect;
	if ( rect.w > 0 ) {
		m_rect.w = rect.w;
		m_rect.h = rect.h;
	}
	else {
		if ( System::Media::getMachineType() == iPad ) {
			m_rect.w = 120;
			m_rect.h = 120;
		} else {
			m_rect.w = 60;
			m_rect.h = 60;
		}
	}

	Rect size = gdi->getTextSize(m_text.getBuf());
	m_rect.h += size.h+m_marginIn.h();
}

void BitmapButtonControl::draw(GdiRef gdi) {
	Rect rect = m_rect;
	rect.inset(m_marginIn.left, m_marginIn.top);
	
	Rect size = gdi->getTextSize(m_text.getBuf());
	rect.h -= size.h+m_marginIn.h();
	
	if ( m_bitmap.isValid() ) {
		gdi->copy(&m_bitmap, rect.x+m_marginIn.left, rect.y+m_marginIn.top, rect.w-m_marginIn.w(), rect.h-m_marginIn.h());
	}
	else {
		int radius = (int)System::Media::getRadius();
		gdi->roundgradient(rect.x, rect.y, rect.w, rect.h, radius, eVertical, white, blue);
	}

	
	gdi->text(m_rect.x+m_rect.w/2-size.w/2, rect.bottom()+m_marginIn.top, m_text.getBuf(), m_textColor);
}
