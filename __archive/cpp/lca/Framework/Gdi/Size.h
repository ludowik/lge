#pragma once

#define Size lcaSize

ImplementClass(Size) : public Object {
public:
	double w;
	double h;
	
public:
	Size();
	Size(double _w, double _h);
	
};
