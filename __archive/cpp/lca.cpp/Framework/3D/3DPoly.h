#pragma once

#include "3DPoint.h" 

ImplementClass(C3DPoly) : public Object {
public:
	Color m_rgb;
	
public:
	C3DPointList m_array;
	
public:
	C3DPoly();
	virtual ~C3DPoly();
	
public:
	int getCount();
	
	void releaseAll();
	
	C3DPoint* Add(coord x, coord y, coord z, coord w=1, InsertMode eInsertMode=eAddTail);
	C3DPoint* Add(C3DPoint* point, InsertMode eInsertMode=eAddTail);
	C3DPoint* Add(InsertMode eInsertMode, ...);
	
	C3DPoint* Get(int iPos);
	C3DPoint* operator [] (int iPos);
	
	C3DPoint* GetCenter(C3DPoint* center);
	
	void Line(coord x1, coord y1, coord z1,
			  coord x2, coord y2, coord z2);
	
	void Face();
	
	void Rect(coord x, coord y, coord z,
			  coord w, coord h, coord d);
	
};

typedef class CollectionObject<Array, C3DPoly> C3DPolyList;
