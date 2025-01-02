#pragma once

#undef min
#undef max

#define min(a,b) ((a)<(b)?(a):(b))
#define max(a,b) ((a)>(b)?(a):(b))

#define minmax(a,_min,_max) max(min(a, _max), _min)

#define divby(a, b) ((b)?((double)(a))/((double)(b)):0)
#define mulby(a, b) ((b)?((double)(a))*((double)(b)):0)

#define muldiv(a, b, c) divby((a)*(b),(c))

#define divby2(a) ((a)/(2.)) // ((a)>>1)
#define mulby2(a) ((a)*(2.)) // ((a)<<1)

const double PI = 3.141592654;
const double PI2 = PI*2.;

const double _radian2degree = 180./PI; 
#define radian2degree(a) ((a)*_radian2degree)
#define degree2radian(a) ((a)/_radian2degree)

#define MIN_RADIAN ((double)0)
#define MAX_RADIAN ((double)PI2)

#define MIN_DEGREE (0)
#define MAX_DEGREE (360)

ImplementClass(Math) {
public:
	Math();
	
	static double Blend(int k, int n, double u);
	
	static double Factorial(int n);
	static double Combinative(int n, int k);
	
	static int Round(double x);
	
	static int MulDiv(int nNumber,
					  int nNumerator,
					  int nDenominator);
	
	static double Normal(double x, double y);
	
};

int Round(double v);
