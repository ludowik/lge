#include "System.h"
#include "Cell.h"

Cell::Cell(int c, int l, sint* pvalue, int id) : Control(id), m_value(pvalue?*pvalue:m_rvalue) {
	m_class = "Cell";
	
	m_value = 0;
	m_level = 0;
    
	Position pos(c, l);
	pos.m_exist = true;
	
	m_posInBoard = pos;
}

Cell::~Cell() {
}

void Cell::unselect() {
	m_selected = false;
	m_checked = false;
}

int Cell::getIndexBitmapFromID() {
	if ( m_value != 0 ) {
		if ( m_value > 0 ) {
			return m_value-1;
		}
			
		return get_view()->m_resources.getCount()-abs(m_value);
	}
	return -1;
}

void Cell::draw(GdiRef gdi) {
	int x = m_rect.x;
	int y = m_rect.y;
	
	Rect rect(m_rect.x, m_rect.y, m_rect.w, m_rect.h);
	if ( m_selected ) {
		gdi->setPenSize(2);
		gdi->rect(&rect, m_selectColor, m_bgColor);
	}
	else {
		gdi->rect(&rect, m_fgColor, m_bgColor);
	}

	gdi->setPenSize(1);
	
	int indexBitmap = getIndexBitmapFromID();
	if ( indexBitmap != -1 ) {
		BitmapRef bitmap = (BitmapRef)get_view()->m_resources.get(indexBitmap);
		if ( bitmap ) {
			Rect rect = bitmap->m_rect;

			x += ( m_rect.w - rect.w ) / 2;
			y += ( m_rect.h - rect.h ) / 2;

			gdi->copy(bitmap, x, y);
		}
	}
}

bool Cell::load(File& file) {
	file >> m_value;
	return true;
}

bool Cell::save(File& file) {
	file << m_value;
	return true;
}
