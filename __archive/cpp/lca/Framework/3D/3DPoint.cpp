#include "System.h"
#include "3DPoint.h"

C3DPoint::C3DPoint() {
	x = 0;
	y = 0;
	z = 0;
	w = 1;
}

C3DPoint::C3DPoint(coord _x, coord _y, coord _z, coord _w) {
	x = _x;
	y = _y;
	z = _z;
	w = _w;
}
