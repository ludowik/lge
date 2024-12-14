#include "System.h"
#include "3DObject.h"

C3DObject::C3DObject() {
}

C3DObject::~C3DObject() {
	releaseAll();
}

int C3DObject::getCount() {
	return m_array.getCount();
}

void C3DObject::releaseAll() {
	/*int iSize = m_array.getCount();
	 for ( int i=0 ; i<iSize ; ++i )  
	 {
	 delete m_array[i];
	 }
	 */
	
	m_array.releaseAll();
}

C3DPoly* C3DObject::Add(C3DPoly* poly, InsertMode eInsertMode) {
	if (!poly) {
		poly = new C3DPoly();
	}
	
	switch ( eInsertMode )
	{
		case eInit:
		{
			releaseAll();
		}
		case eAddTail:
		{
			m_array.add(poly);
			break;
		}
		case eAddHead:
		{
			m_array.add(0, poly);
			break;
		}
	}
	
	return poly;
}

C3DPoly* C3DObject::Add(InsertMode eInsertMode, ...)
{
	va_list arg_ptr;
	va_start(arg_ptr, eInsertMode);
	
	C3DPoly* poly = Add(NULL, eInsertMode);
	
	do
	{
		coord x = va_arg(arg_ptr, coord);
		coord y = va_arg(arg_ptr, coord);
		coord z = va_arg(arg_ptr, coord);
		
		coord w = 1;
		
		if (   x == END_COORD
			|| y == END_COORD
			|| z == END_COORD ) {
			break;
		}
		
		poly->Add(x, y, z, w);
	}
	while (1);
	
	return poly;
}

C3DPoly* C3DObject::Get(int iPos)
{
	return (C3DPoly*)m_array.get(iPos);
}

C3DPoly* C3DObject::operator [] (int iPos)
{
	return (C3DPoly*)m_array.get(iPos);
}

void C3DObject::Pixel(coord x, coord y, coord z)
{
	Add()->Add(x, y, z, 1);
}

C3DPoly* C3DObject::Vector(coord x, coord y, coord z)
{
	C3DPoly* poly = Add();
	
	poly->Add(0, 0, 0, 1);
	poly->Add(x, y, z, 1);
	
	return poly;
}

void C3DObject::Box(coord w, coord h, coord d)
{
	coord x = -w/2;
	coord y = -h/2;
	coord z = -d/2;
	
	Add()->Rect(x  , y  , z  ,  w,  h,  0);
	Add()->Rect(x+w, y  , z  ,  0,  h,  d);
	Add()->Rect(x+w, y  , z+d, -w,  h,  0);
	Add()->Rect(x  , y  , z+d,  0,  h, -d);
	Add()->Rect(x+w, y  , z  , -w,  0,  d);
	Add()->Rect(x  , y+h, z  ,  w,  0,  d);
}

void C3DObject::Cylinder(coord r, coord h)
{
	Cone(r, r, h);
}

void C3DObject::Cone(coord b, coord s, coord h)
{
	double xb1 = 0;
	double yb1 = 0;
	
	double xb2 = 0;
	double yb2 = 0;
	
	double xs1 = 0;
	double ys1 = 0;
	
	double xs2 = 0;
	double ys2 = 0;
	
	int mark = 16;
	
	double a = 0.;
	double step = (double)MAX_DEGREE/(double)mark;
	
	xb1 = cos(a)*b;
	yb1 = sin(a)*b;
	
	xs1 = cos(a)*s;
	ys1 = sin(a)*s;
	
	double hm = h/2;
	
	C3DPoly* sommet1 = Add();
	C3DPoly* sommet2 = Add();
	
	for ( a = step ; a <= MAX_DEGREE ; a += step )
	{
		xb2 = cos(a)*b;
		yb2 = sin(a)*b;
		
		xs2 = cos(a)*s;
		ys2 = sin(a)*s;
		
		C3DPoly* poly = Add();
		
		poly->Add((coord)xb1, (coord)yb1, +hm);
		poly->Add((coord)xb2, (coord)yb2, +hm);
		poly->Add((coord)xs2, (coord)ys2, -hm);
		poly->Add((coord)xs1, (coord)ys1, -hm);
		
		sommet1->Add((coord)xb1, (coord)yb1, +hm);
		sommet2->Add((coord)xs1, (coord)ys1, -hm);
		
		xb1 = xb2;
		yb1 = yb2;
		
		xs1 = xs2;
		ys1 = ys2;
	}
}

C3DPoint* SphereProc(coord r,
                     double a,
                     double b)
{
	static C3DPoint point;
	
	point.x = cos(a) * double(r);
	point.y = sin(a) * double(r);
	point.z = cos(a) * double(r);
	
	point.x = point.x * cos(b);
	point.z = point.z * sin(b);
	
	return &point;
}

void C3DObject::Sphere(coord r)
{	
	int mark = 32;
	
	double a = 0;
	double b = 0;
	
	double step = (double)MAX_DEGREE/(double)mark;
	
	C3DPoly* poly = NULL;
	
	int i=0;
	int j=0;
	
	for ( i=0, a=0 ; i<mark ; a+=step, ++i )
	{
		for ( j=0, b=MAX_DEGREE/4 ; j<mark/2 ; b+=step, ++j )
		{ 
			poly = Add();
			
			poly->Add(SphereProc(r, b     , a     ));
			poly->Add(SphereProc(r, b+step, a     ));
			poly->Add(SphereProc(r, b+step, a+step));
			poly->Add(SphereProc(r, b     , a+step));
		}
	}
}

void C3DObject::Pyramid(coord b)
{
	double mb = b/2;
	
	C3DPoly* poly = Add();
	
	poly->Add(-mb,0,-mb);
	poly->Add(-mb,0,+mb);
	poly->Add(+mb,0,+mb);
	poly->Add(+mb,0,-mb);
	
	poly = Add();
	poly->Add(-mb,0,+mb);
	poly->Add(-mb,0,-mb);
	poly->Add(0,b,0);
	
	poly = Add();
	poly->Add(+mb,0,+mb);
	poly->Add(-mb,0,+mb);
	poly->Add(0,b,0);
	
	poly = Add();
	poly->Add(+mb,0,-mb);
	poly->Add(+mb,0,+mb);
	poly->Add(0,b,0);
	
	poly = Add();
	poly->Add(-mb,0,-mb);
	poly->Add(+mb,0,-mb);
	poly->Add(0,b,0);
}
