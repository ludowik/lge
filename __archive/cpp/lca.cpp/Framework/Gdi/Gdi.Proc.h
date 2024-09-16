#pragma once

#define DEFAULT_METHOD 4

PointRef getPie(PointRef rPts,
	int& nPts,
	int x,
	int y,
	int r,
	double ad,
	double aa);

PointRef getRect(PointRef rPts,
	int& nPts,
	int x,
	int y,
	int w,
	int h,
	Point rRound);

PointRef getCircle(PointRef rPts,
	int& nPts,
	int x,
	int y,
	int w,
	int h,
	Point rRound);

PointRef getLine(PointRef rPts,
	int& nPts,
	int x1,
	int y1,
	int x2,
	int y2,
	int nPrecision=1,
	int iMethod=DEFAULT_METHOD);

#define ForEachInLine(_fromX, _fromY, _toX, _toY, _x, _y)\
{\
	int _nb=0;\
	int _x=0;\
	int _y=0;\
	PointRef _arr = getLine(NULL, _nb, _fromX, _fromY, _toX, _toY);\
	if ( _arr )\
{\
	TableIterator<Point> iter(_arr, _nb);\
	while ( iter.hasNext() )\
{\
	Point p = iter.next();\
	_x = p.x;\
	_y = p.y;

#define ForEachInLineEx(_fromX, _fromY, _toX, _toY, _x, _y, _precision, _mode)\
{\
	int _nb=0;\
	int _x=0;\
	int _y=0;\
	PointRef _arr = getLine(NULL, _nb, _fromX, _fromY, _toX, _toY, _precision, _mode);\
	if ( _arr )\
{\
	TableIterator<Point> iter(_arr, _nb);\
	while ( iter.hasNext() )\
{\
	Point p = iter.next();\
	_x = p.x;\
	_y = p.y;

#define ForEachInRect(_fromX, _fromY, _toX, _toY, _rayon, _x, _y)\
{\
	int _nb=0;\
	int _x=0;\
	int _y=0;\
	int _xn=0;\
	int _yn=0;\
	PointRef _arr = getRect(NULL, _nb, _fromX<_toX?_fromX:_toX, _fromY<_toY?_fromY:_toY, abs(_toX-_fromX), abs(_toY-_fromY), Point(_rayon, _rayon));\
	if ( _arr )\
{\
	TableIterator<Point> iter(_arr, _nb);\
	while ( iter.hasNext() )\
{\
	Point p = iter.next();\
	_x  = p.x;\
	_y  = p.y;

#define ForEachInCircle(_fromX, _fromY, _toX, _toY, _rayon, _x, _y)\
{\
	int _nb=0;\
	int _x=0;\
	int _y=0;\
	int _xn=0;\
	int _yn=0;\
	PointRef _arr = getCircle(NULL, _nb, _fromX<_toX?_fromX:_toX, _fromY<_toY?_fromY:_toY, abs(_toX-_fromX), abs(_toY-_fromY), PointCPoint(abs(_toX-_fromX)/2, divby2(abs(_toY-_fromY))));\
	if ( _arr )\
{\
	TableIterator<Point> iter(_arr, _nb);\
	while ( iter.hasNext() )\
{\
	Point p = iter.next();\
	_x  = p.x;\
	_y  = p.y;

#define ForEachInPie(_fromX, _fromY, _toX, _toY, _rayon, _ad, _aa, _x, _y)\
{\
	int _nb=0;\
	int _x=0;\
	int _y=0;\
	int _xn=0;\
	int _yn=0;\
	PointRef _arr = getPie(NULL, _nb, _fromX<_toX?_fromX:_toX, _fromY<_toY?_fromY:_toY, _rayon, _ad, _aa);\
	if ( _arr )\
{\
	TableIterator<Point> iter(_arr, _nb);\
	while ( iter.hasNext() )\
{\
	Point p = iter.next();\
	_x  = p.x;\
	_y  = p.y;

#define End()\
}\
	global::getInstance().freePoints(_arr, _nb);\
}\
}

ImplementClass(Points) : public Object {
public:
	virtual ~Points();

	int npts;
	PointRef pts;

};

ImplementClass(global) : public Singleton<global> {
public:
	int m_i;
	Array m_lst;

public:
	global();

public:
	PointRef createPoints(int n);
	void freePoints(PointRef pts, int n);

};
