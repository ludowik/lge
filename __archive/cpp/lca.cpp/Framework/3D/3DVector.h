#pragma once

#include "Matrix.h"
#include "3DPoint.h"

ImplementClass(Vector) : public C3DPoint {
public:
	Vector(double x=0, double y=0, double z=0);
	
public:
	static Matrix* MatrixLookAtLH(Matrix* pOut,
								   C3DPoint* pEye,
								   C3DPoint* pAt,
								   C3DPoint* pUp);
	
	static double GetNorm(C3DPoint* v1);
	static double GetNorm(C3DPoint* v1, C3DPoint* v2);
	
	static C3DPoint* SetNorm(C3DPoint* pOut,
							 C3DPoint* v1,
							 double dNorme);
	
	static C3DPoint* Normal(C3DPoint* pOut,
							C3DPoint* v1,
							C3DPoint* v2,
							C3DPoint* v3);
	
	static C3DPoint* CrossProduct(C3DPoint* pOut,
								  C3DPoint* v1,
								  C3DPoint* v2);
	
	static double DotProduct(C3DPoint* v1,
							 C3DPoint* v2);
	
	static C3DPoint* Subtract(C3DPoint* pOut,
							  C3DPoint* v1,
							  C3DPoint* v2);
	
	static C3DPoint* Normalize(C3DPoint* pOut,
							   C3DPoint* v1);
	
	static C3DPoint* Point(C3DPoint* pOut,
						   Matrix* pMat);
	
	double GetNorm();
	void SetNorm(double dNorme);
	double Normalize();
	
};
