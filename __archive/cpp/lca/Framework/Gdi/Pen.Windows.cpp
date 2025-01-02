#include "System.h"
#include "Pen.h"

#if defined(_WINDOWS)

#include <Windows.h>

Pen::Pen(GdiWindowsRef gdi, Color color, int penSize) {
	m_gdi = gdi;
	m_transparent = true;
	m_pen = NULL;
	m_oldPen  = NULL;

	if ( color == nullColor ||
		 color == transparentColor ) {
		m_transparent = true;
		m_pen = (HPEN)GetStockObject(NULL_PEN);
	}
	else {
		m_transparent = false;
		m_pen = CreatePen(PS_SOLID, max(1, penSize), RGB(rValue(color), gValue(color), bValue(color)));
	}

	m_oldPen = (HPEN)SelectObject(gdi->m_ctx, m_pen);
}

Pen::~Pen() {
	if ( m_oldPen )
		SelectObject(m_gdi->m_ctx, m_oldPen);
	if ( !m_transparent ) {
		DeleteObject(m_pen);
	}
}

#endif
