#include "System.h"
#include "Brush.h"

#if defined(_WINDOWS)

Brush::Brush(GdiWindowsRef gdi, Color color) {
	m_gdi = gdi;
	m_transparent = true;
	m_brush = NULL;
	m_oldBrush  = NULL;

	if ( color == nullColor ||
		 color == transparentColor ) {
		m_transparent = true;
		m_brush = (HBRUSH)GetStockObject(NULL_BRUSH);
	}
	else {
		m_transparent = false;
		m_brush = CreateSolidBrush(RGB(rValue(color), gValue(color), bValue(color)));
	}

	m_oldBrush = (HBRUSH)SelectObject(m_gdi->m_ctx, m_brush);
}

Brush::~Brush() {
	if ( m_oldBrush )
		SelectObject(m_gdi->m_ctx, m_oldBrush);
	if ( !m_transparent ) {
		DeleteObject(m_brush);
	}
}

#endif
