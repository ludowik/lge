#include "System.h"
#include "3DVector.h"
#include "Matrix.h"

Vector::Vector(double x, double y, double z) : C3DPoint(x, y, z) {
}

C3DPoint* Vector::Subtract(C3DPoint* pOut,
                            C3DPoint* v1,
                            C3DPoint* v2) {
	pOut->x = v1->x - v2->x;
	pOut->y = v1->y - v2->y;
	pOut->z = v1->z - v2->z;
	
	pOut->w = 1;
	
	return pOut;
}

double Vector::GetNorm(C3DPoint* v1) {
	double dNorme = sqrt(pow(v1->x,2)+
						 pow(v1->y,2)+
						 pow(v1->z,2));
	
	return dNorme;
}

double Vector::GetNorm(C3DPoint* v1, C3DPoint* v2) {
	double dNorme = sqrt(pow(v2->x-v1->x,2)+
						 pow(v2->y-v1->y,2)+
						 pow(v2->z-v1->z,2));
	
	return dNorme;
}

double Vector::GetNorm() {
	double dNorme = sqrt(pow(x,2)+
						 pow(y,2)+
						 pow(z,2));
	
	return dNorme;
}

C3DPoint* Vector::SetNorm(C3DPoint* pOut,
						  C3DPoint* v1,
						  double dNorme) {
	pOut->x = v1->x*dNorme;
	pOut->y = v1->y*dNorme;
	pOut->z = v1->z*dNorme;
	
	return pOut;
}

C3DPoint* Vector::Normalize(C3DPoint* pOut,
                             C3DPoint* v1) {
	double dNorme = sqrt(pow(v1->x,2)+
						 pow(v1->y,2)+
						 pow(v1->z,2));
	
	if ( !dNorme ) {
		dNorme = 1;
	}
	
	pOut->x = v1->x/dNorme;
	pOut->y = v1->y/dNorme;
	pOut->z = v1->z/dNorme;
	
	return pOut;
}

void Vector::SetNorm(double dNorme) {
	x = x * dNorme;
	y = y * dNorme;
	z = z * dNorme;
}

double Vector::Normalize() {
	if ( !x && !y && z ) {
		double r = z;
		z = sign(r);
		return r;
	}
	
	if ( !x && !z && y )
	{
		double r = y;
		y = sign(r);
		return r;
	}
	
	if ( !y && !z && x )
	{
		double r = x;
		x = sign(r);
		return r;
	}
	
	double dNorme = sqrt(pow(x,2)+
						 pow(y,2)+
						 pow(z,2));
	
	if ( !dNorme )
	{
		dNorme = 1;
	}
	
	x = x/dNorme;
	y = y/dNorme;
	z = z/dNorme;
	
	return dNorme;
}

C3DPoint* Vector::CrossProduct(C3DPoint* pOut,
                                C3DPoint* v1,
                                C3DPoint* v2)
{
	pOut->x = v1->y * v2->z - v1->z * v2->y;
	pOut->y = v1->z * v2->x - v1->x * v2->z;
	pOut->z = v1->x * v2->y - v1->y * v2->x;
	
	return pOut;
}

double Vector::DotProduct(C3DPoint* v1,
                           C3DPoint* v2)
{
	return v1->x*v2->x +
	v1->y*v2->y + 
	v1->z*v2->z;
}           

Matrix* Vector::MatrixLookAtLH(Matrix* pOut,
                                 C3DPoint* pEye,
                                 C3DPoint* pAt,
                                 C3DPoint* pUp) 
{
	assert(pOut&&pEye&&pAt&&pUp);
	
	C3DPoint XAxis, YAxis, ZAxis;
	
	// Get the z basis vector, which points straight ahead; the
	// difference from the eye point to the look-at point. This is the 
	// direction of the gaze (+z).
	Subtract(&ZAxis, pAt, pEye);
	
	// Normalize the z basis vector.
	Normalize(&ZAxis, &ZAxis);
	
	// Compute the orthogonal axes from the cross product of the gaze 
	// and the pUp vector.
	CrossProduct(&XAxis, pUp, &ZAxis);
	Normalize(&XAxis, &XAxis);
	CrossProduct(&YAxis, &ZAxis, &XAxis);
	
	// Start building the matrix. The first three rows contain the 
	// basis vectors used to rotate the view to point at the look-at 
	// point. The fourth row contains the translation values. 
	// Rotations are still about the eyepoint.
	pOut->set(0, 0, XAxis.x);
	pOut->set(1, 0, XAxis.y);
	pOut->set(2, 0, XAxis.z);
	pOut->set(3, 0, -DotProduct(&XAxis, pEye));
	
	pOut->set(0, 1, YAxis.x);
	pOut->set(1, 1, YAxis.y);
	pOut->set(2, 1, YAxis.z);
	pOut->set(3, 1, -DotProduct(&YAxis, pEye));
	
	pOut->set(0, 2, ZAxis.x);
	pOut->set(1, 2, ZAxis.y);
	pOut->set(2, 2, ZAxis.z);
	pOut->set(3, 2, -DotProduct(&ZAxis, pEye));
	
	pOut->set(0, 3, 0.0f);
	pOut->set(1, 3, 0.0f);
	pOut->set(2, 3, 0.0f);
	pOut->set(3, 3, 1.0f);
	
	pOut->transpose();
	
	return pOut;
}

C3DPoint* Vector::Normal(C3DPoint* pOut,
                          C3DPoint* v1,
                          C3DPoint* v2,
                          C3DPoint* v3)
{
	C3DPoint o1;
	C3DPoint o2;
	
	Subtract(&o1, v2, v1);
	Subtract(&o2, v3, v1);
	
	CrossProduct(pOut, &o2, &o1);
	Normalize(pOut, pOut);
	
	return pOut;
}

C3DPoint* Vector::Point(C3DPoint* pOut,
                         Matrix* pMat)
{
	pOut->x = pMat->get(0,0);
	pOut->y = pMat->get(1,0);
	pOut->z = pMat->get(2,0);
	
	return pOut;
}
