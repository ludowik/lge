#include "System.h"
#include "Maths.h"

#include <math.h>

double Math::Blend(int k, int n, double u) {
	double v = Combinative(n, k);
	
	int j;
	for ( j = 1 ; j <= k ; ++j ) {
		v *= u;
	}
	for ( j = k ; j <= n-1 ; ++j ) {
		v *= ( 1. - u );
	}
	return v;
}

double Math::Factorial(int n) {
	double b = 1;
	for ( int i = 2 ; i <= n ; ++i ) {
		b *= i;
	}
	return b;
}

double Math::Combinative(int n, int k) {
	return Factorial(n) / ( Factorial(k) * Factorial(n-k) );
}

int Round(double v) {
	return Math::Round(v);
}

int Math::Round(double v) {
	int w = (int)v;
	if ( fabs ( v - (double)w ) >= 0.5 ) {
		w = w + ( v > 0 ? 1 : -1 );
	}
	return w;
}

int Math::MulDiv(int nNumber,
				  int nNumerator,
				  int nDenominator) {
	return nNumber * nNumerator / nDenominator;
}

double Math::Normal(double x, double y) {
	return ::sqrt(x*x + y*y);
}

double Rounded(double val) {
	double lCeil = ::ceil(val);
	return (val-lCeil)>.5?lCeil:floor(val);
}
