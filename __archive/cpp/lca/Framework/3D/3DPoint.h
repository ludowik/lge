#pragma once

typedef double coord;

ImplementClass(C3DPoint) : public Object {
public:
	coord x;
	coord y;
	coord z;
	coord w;
	
public:
	C3DPoint();
	C3DPoint(coord _x, coord _y, coord _z, coord _w=1);
	
};

typedef class CollectionObject<Array, C3DPoint> C3DPointList;

enum InsertMode {
    eInit,
    eAddTail,
    eAddHead,

};

#define MIN_COORD ((coord)(LONG_MIN))
#define MAX_COORD ((coord)(LONG_MAX-1))
#define END_COORD ((coord)(LONG_MAX))