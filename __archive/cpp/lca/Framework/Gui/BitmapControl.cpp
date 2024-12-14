#include "System.h"
#include "BitmapControl.h"

BitmapControl::BitmapControl(char* id, int w, int h) : Control() {
	m_class = "BitmapControl";
	m_layoutText = posWCenter|posHCenter;
	if ( id ) {
		m_bitmap.loadRes(id, w, h);
	}
}

BitmapControl::~BitmapControl() {
}

void BitmapControl::computeSize(GdiRef gdi) {
	Rect rect = m_bitmap.m_rect;

	m_rect.w = rect.w;
	m_rect.h = rect.h;
}

void BitmapControl::draw(GdiRef gdi) {
	Rect rect = m_bitmap.m_rect;
	gdi->copy(&m_bitmap, xLayout(m_layoutText, rect.w), yLayout(m_layoutText, rect.h));
}
