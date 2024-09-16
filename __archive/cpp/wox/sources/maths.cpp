#include "headers.h"
#include "maths.h"

float interpolation(float a, float b, float n, float delta) {
    return interpolation3(a, b, n, delta);
}

float interpolation1(float a, float b, float n, float delta) {
    if ( n == 0 ) {
        return a;
    } else if ( n == 1 ) {
        return b;
    }
    
    return a + delta * ( b - a ) / n;
}

float interpolation2(float a, float b, float n, float delta) {
    if ( n == 0 ) {
        return a;
    } else if ( n == 1 ) {
        return b;
    }
    
    float pas = (float)delta / n;
    
    float v1 = 3 * pow(1 - pas, 2) - 2 * pow(1 - pas, 3);
    float v2 = 3 * pow(    pas, 2) - 2 * pow(    pas, 3);
    
    return a * v1 + b * v2;
}

float interpolation3(float a, float b, float n, float delta) {
    if ( n == 0 ) {
        return a;
    } else if ( n == 1 ) {
        return b;
    }
    
    float ft = delta * pi / n;
    
	float f = ( 1 - cos(ft) ) * 0.5;
    
	return  a * ( 1 - f ) +  b * f;
}
