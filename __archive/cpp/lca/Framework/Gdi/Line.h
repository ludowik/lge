#pragma once

#include "Point.h"
#include "Rect.h"

ImplementClass(Line) : public Rect {
protected:
	CollectionRef m_points;

	double m_precision;
	int m_n;
	
public:
	Line();
	Line(PointRef from, PointRef to, int precision, int n=-1);
	virtual ~Line();
	
public:
	int initLine();

public:
	int getCount();

public:
	Point get(int i);
	void release(int i);
	
public:
	IteratorRef getIterator();
	
};
