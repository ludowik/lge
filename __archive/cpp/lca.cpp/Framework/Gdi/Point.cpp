#include "System.h"
#include "Point.h"

Point::Point() : Object("Point") {
	x = 0;
	y = 0;
}

Point::Point(double _x, double _y) : Object("Point") {
	x = _x;
	y = _y;
}

void Point::inset(double _x, double _y) {
	x += _x;
	y += _y;
}

void Point::outset(double _x, double _y) {
	x -= _x;
	y -= _y;
}

void Point::inset(PointRef pt) {
	x += pt->x;
	y += pt->y;
}

void Point::outset(PointRef pt) {
	x -= pt->x;
	y -= pt->y;
}
