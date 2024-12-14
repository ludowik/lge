#include "System.h"

TestObject<Rect> testRect("Rect");

template<> void TestObject<Rect>::test() {
	int x = 143;
	int y = 5345;
	int w = 2424;
	int h = 113234;
	
	Rect rect(x, y, w, h);
	
	rect.inset (x, y);
	rect.outset(x, y);
	
	Point p(x, y);
	rect.inset (&p);
	rect.outset(&p);
	
	assert(rect.x==x);
	assert(rect.y==y);
	assert(rect.w==w);
	assert(rect.h==h);
}
