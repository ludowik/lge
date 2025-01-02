#pragma once

#define Rect lcaRect

ImplementClass(Rect) : public Object {
public:
	double x;
	double y;
	double w;
	double h;
	
public:
	Rect();
	Rect(double x, double y, double w, double h);
	
public:
	double left ();
	double right();
	
	double top   ();
	double bottom();
	
	double width ();
	double height();

public:
	void set_xy(double x, double y);
	void set_wh(double w, double h);

public:
	void setRight (double r);
	void setBottom(double b);

public:
	Point center();
	Rect add(Rect rect);
	
public:
	void inset(double x, double y);
	void inset(PointRef pt);

	void outset(double x, double y);
	void outset(PointRef pt);
	
public:
	bool contains(double x, double y);
	
};
