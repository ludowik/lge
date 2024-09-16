#include "System.h"
#include "3DPoly.h"

C3DPoly::C3DPoly() {
	m_rgb = black;
}

C3DPoly::~C3DPoly() {
	releaseAll();
}

int C3DPoly::getCount() {
	return m_array.getCount();
}

void C3DPoly::releaseAll() {
	m_array.releaseAll();
}

C3DPoint* C3DPoly::Add(coord x, coord y, coord z, coord w, InsertMode eInsertMode) {
	C3DPoint* point = new C3DPoint(x, y, z, w);
	
	switch ( eInsertMode ) {
		case eInit: {
			releaseAll();
		}
		case eAddTail: {
			m_array.add(point);
			break;
		}
		case eAddHead: {
			m_array.add(0, point);
			break;
		}
	}
	
	return point;
}

C3DPoint* C3DPoly::Add(C3DPoint* point, InsertMode eInsertMode) {
	return Add(point->x, point->y, point->z, point->w, eInsertMode);
}

C3DPoint* C3DPoly::Add(InsertMode eInsertMode, ...) {
	va_list arg_ptr;
	va_start(arg_ptr, eInsertMode);
	
	C3DPoint* point = NULL;
	
	switch ( eInsertMode ) {
		case eInit: {
			releaseAll();
		}
		case eAddTail: {
			eInsertMode = eAddTail;
			break;
		}
		case eAddHead: {
			break;
		}
	}
	
	do {
		coord x = va_arg(arg_ptr, coord);
		coord y = va_arg(arg_ptr, coord);
		coord z = va_arg(arg_ptr, coord);
		
		coord w = 1;
		
		if (   x == END_COORD
			|| y == END_COORD
			|| z == END_COORD )
		{
			break;
		}
		
		point = Add(x, y, z, w, eInsertMode);
	}
	while ( 1 );
	
	va_end(arg_ptr);
	
	return point;
}

C3DPoint* C3DPoly::Get(int iPos) {
	return (C3DPoint*)m_array.get(iPos);
}

C3DPoint* C3DPoly::operator [] (int iPos) {
	return (C3DPoint*)m_array.get(iPos);
}

C3DPoint* C3DPoly::GetCenter(C3DPoint* center) {
	foreach(C3DPoint*, point, m_array) {
		center->x += point->x;
		center->y += point->y;
		center->z += point->z;
	}
    
	center->x /= getCount();
	center->y /= getCount();
	center->z /= getCount();
	
	return center;
}

void C3DPoly::Line(coord x1, coord y1, coord z1, coord x2, coord y2, coord z2) {
	Add(eInit, x1, y1, z1, x2, y2, z2, END_COORD);
}

void C3DPoly::Face() {
}

void C3DPoly::Rect(coord x, coord y, coord z, coord w, coord h, coord d) {
	if ( !w )
		Add(eInit,
			x,  y  ,  z  ,
			x,  y  ,  z+d,
			x,  y+h,  z+d,
			x,  y+h,  z, END_COORD);
	else if ( !h )
		Add(eInit,
			x  ,  y,  z  ,
			x+w,  y,  z  ,
			x+w,  y,  z+d,
			x  ,  y,  z+d, END_COORD);
	else if ( !d )
		Add(eInit,
			x  ,  y  ,  z,
			x+w,  y  ,  z,
			x+w,  y+h,  z,
			x  ,  y+h,  z, END_COORD);
}
