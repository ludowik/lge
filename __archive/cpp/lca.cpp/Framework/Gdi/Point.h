#pragma once

#define Point lcaPoint

ImplementClass(Point) : public Object {
public:
	double x;
	double y;
	
public:
	Point();
	Point(double _x, double _y);
	
public:
	void inset (double _x, double _y);
	void outset(double _x, double _y);
	
	void inset (PointRef pt);
	void outset(PointRef pt);
	
};
