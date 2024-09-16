#include "System.h"
#include "Rect.h"

Rect::Rect() : Object("Rect") {
	x = 0;
	y = 0;
	w = 0;
	h = 0;
}

Rect::Rect(double _x, double _y, double _w, double _h) : Object("Rect") {
	x = _x;
	y = _y;
	w = _w;
	h = _h;
}

double Rect::left() {
	return x;
}

double Rect::right() {
	return x + w;
}

double Rect::top() {
	return y;
}

double Rect::bottom() {
	return y + h;
}

double Rect::width() {
	return w;
}

double Rect::height() {
	return h;
}

void Rect::inset(double _x, double _y) {
	x += _x;
	y += _y;
	
	w -= 2*_x;
	h -= 2*_y;
}

void Rect::outset(double _x, double _y) {
	x -= _x;
	y -= _y;
	
	w += 2*_x;
	h += 2*_y;
}

void Rect::inset(PointRef pt) {
	x += pt->x;
	y += pt->y;
	
	w -= 2*pt->x;
	h -= 2*pt->y;
}

void Rect::outset(PointRef pt) {
	x -= pt->x;
	y -= pt->y;
	
	w += 2*pt->x;
	h += 2*pt->y;
}

bool Rect::contains(double _x, double _y) {
	if ( _x >= x && _x < x + w &&
		 _y >= y && _y < y + h ) {
		return true;
	}
	return false;
}

Point Rect::center() {
	return Point(x + divby2(w), y + divby2(h));
}

Rect Rect::add(Rect rect) {
	int xm = min( x, rect.x );
	int ym = min( y, rect.y );
	
	w = max( x+w, rect.x+rect.w ) - xm;
	h = max( y+h, rect.y+rect.h ) - ym;
    
    x = xm;
    y = ym;
	
	return *this;
}

void Rect::set_xy(double _x, double _y) {
	x = _x;
	y = _y;
}

void Rect::set_wh(double _w, double _h) {
	w = _w;
	h = _h;
}

void Rect::setRight(double r) {
	w = r-x;
}

void Rect::setBottom(double b) {
	h = b-y;
}
