#pragma once

#include "3DPoly.h"

ImplementClass(C3DObject) : public Object {
public:
	C3DPolyList m_array;
	
public:
	C3DObject();
	C3DObject(C3DObject& obj);
	
	virtual ~C3DObject();
	
public:
	int getCount();
	
	void releaseAll();
	
	C3DPoly* Add(C3DPoly* poly=NULL, InsertMode eInsertMode=eAddTail);
	C3DPoly* Add(InsertMode eInsertMode, ...);
	
	C3DPoly* Get(int iPos);
	C3DPoly* operator [] (int iPos);
	
	void Pixel     (coord x, coord y, coord z);
	C3DPoly* Vector(coord x, coord y, coord z);
	void Box       (coord w, coord h, coord d);
	void Cylinder  (coord r, coord h);
	void Cone      (coord b, coord s, coord h);
	void Sphere    (coord r);
	void Pyramid   (coord b);
	
};
