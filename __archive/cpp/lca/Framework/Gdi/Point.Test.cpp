#include "System.h"

TestObject<Point> testPoint("Point");

template<> void TestObject<Point>::test() {
	int x =  13124125;
	int y = -24234;
	
	Point pt(x, y);
	
	pt.inset (x, y);
	pt.outset(x, y);
	
	Point p(x, y);
	pt.inset(&p);
	pt.outset(&p);
	
	assert(pt.x==x);
	assert(pt.y==y);
}
