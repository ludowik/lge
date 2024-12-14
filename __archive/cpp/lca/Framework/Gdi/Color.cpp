#include "System.h"
#include "Color.h"

byte grayScaleValue(Color color) {
	double sum = rValue(color) + gValue(color) + bValue(color);
	return (byte)( sum / 3. );
}

Color grayScaleColor(Color color) {
	byte gray = grayScaleValue(color);
	return Rgb(gray, gray, gray);
}

Color luminosity(Color color, double fluminosity) {
	if ( color == transparentColor ) {
		return white;
	}

	int h, s, l;
	rgb2hsl(color, h, s, l);

	l = minmax(fluminosity, 0., 1.)*240.;

	return hsl2rgb(h, s, l);
}

Color invert(Color color) {
	if ( color == transparentColor )
		return white;
	
	return Rgb((byte) ( 255 - rValue(color) ),
			   (byte) ( 255 - gValue(color) ),
			   (byte) ( 255 - bValue(color) ));
}

Color merge(Color color1, Color color2) {
	if ( color1 == transparentColor )
		return color2;
	if ( color2 == transparentColor )
		return color1;
	
	return Rgb((byte) ( divby2( rValue(color1) + rValue(color2) ) ),
			   (byte) ( divby2( gValue(color1) + gValue(color2) ) ),
			   (byte) ( divby2( bValue(color1) + bValue(color2) ) ));
}

Color randomColor() {
	return Rgb(System::Math::random(256),
			   System::Math::random(256),
			   System::Math::random(256));
}

double Hue_2_RGB(double v1, double v2, double vH) {
	if ( vH < 0 )
		vH += Hmax;
	if ( vH > Hmax )
		vH -= Hmax;
	
	if ( vH < 60 )
		return ( v1 + ( v2 - v1 ) * ( vH ) / 60. );
	if ( vH < 180 )
		return ( v2 );
	if ( vH < 240 )
		return ( v1 + ( v2 - v1 ) * ( 240 - vH ) / 60. );
	
	return v1;
}

Color hsl2rgb(int _h, int _s, int _l) {
	double h = (double)_h;
	
	double s = (double)_s / (double)Smax;
	double l = (double)_l / (double)Lmax;
	
	double r;
	double g;
	double b;
	
	if ( s == 0 ) {
		r = l * Rmax;
		g = l * Gmax;
		b = l * Bmax;
	}
	else {
		double v1;
		double v2;
		
		if ( l <= 0.5 ) {
			v2 = l + ( l * s );
		}
		else {
			v2 = l + s - ( l * s ) ; 		
		}
		
		v1 = 2. * l - v2;
		
		r = Rmax * Hue_2_RGB(v1, v2, h + 120);
		g = Gmax * Hue_2_RGB(v1, v2, h);
		b = Bmax * Hue_2_RGB(v1, v2, h - 120);
	}
	
	return Rgb(r, g, b);
}

void adjust(double& v) {
	while ( v < 0. )
		v += 360;
	while ( v > 360 )
		v -= 360;
}

void rgb2hsl(Color color, int& _h, int& _s, int& _l) {
	double r = rValue(color);
	double g = gValue(color);
	double b = bValue(color);
	
	double M = max(max(r, g), b);
	double m = min(min(r, g), b);
	
	double diff = M - m;
	double sum  = M + m;
	
	double h;
	double s;
	double l;
	
	l = sum / 510.;
	
	if ( M == m ) {
		s = 0;
		h = 0;
	}
	else {
		double nr = ( M - r )  / diff;
		double ng = ( M - g )  / diff;
		double nb = ( M - b )  / diff;
		
		if ( l <= 0.5 ) {
			s = diff / sum;
		}
		else {
			s = diff / ( 510. - sum );
		}
		
		if ( r == M ) 
			h = 60 * ( 6 + nb - ng );
		else if ( g == M )
			h = 60 * ( 2 + nr - nb );
		else if ( b == M )
			h = 60 * ( 4 + ng - nr );
		
		adjust(h);
	}
	
	_h = (int)(h);
	
	_s = (int)(Smax * s);
	_l = (int)(Lmax * l);
}

int hValue(Color color) {
	int h, s, l;
	rgb2hsl(color, h, s, l);
	return h;
}

int sValue(Color color) {
	int h, s, l;
	rgb2hsl(color, h, s, l);
	return s;
}

int lValue(Color color) {
	int h, s, l;
	rgb2hsl(color, h, s, l);
	return l;
}

const char* toHexa(int val) {
    static char hex[2] = "";
    hex[0] = '?';
    hex[1] = 0;
    
    if ( val >= 0 && val <=9 ) {
        hex[0] = '0'+val;
    }
    else if ( val >= 10 && val <= 16 ) {
        hex[0] = 'A'+val-10;
    }
    return hex;
}

String asHexa(int val) {
    String res;
    res += toHexa((int)(val/16));
    res += toHexa((int)(val%16));
    return res;
}

String asHexa(Color color) {
    int r = rValue(color);
	int g = gValue(color);
	int b = bValue(color);
    
    String res;
    res += asHexa(r);
    res += asHexa(g);
    res += asHexa(b);
    
    return res;
}

const Color black      = Rgb(  0,  0,  0);
const Color white      = Rgb(255,255,255);

const Color blueDark   = Rgb(  0,  0,192);
const Color blueLight  = Rgb(160,160,255);

const Color greenDark  = Rgb(  0,192,  0);
const Color greenLight = Rgb(160,255,160);

const Color redDark    = Rgb(192,  0,  0);
const Color redLight   = Rgb(255,160,160);

const Color grayDark2  = Rgb( 16, 16, 16);
const Color grayDark   = Rgb( 64, 64, 64);
const Color gray       = Rgb(128,128,128);
const Color grayLight  = Rgb(192,192,192);
const Color grayLight2 = Rgb(240,240,240);

const Color red        = Rgb(255,  0,  0);
const Color green      = Rgb(  0,255,  0);
const Color blue       = Rgb(  0,  0,255);

const Color yellow     = Rgb(255,255,  0);
const Color purple     = Rgb(128,  0,128);
const Color orange     = Rgb(255,165,  0);
const Color brown      = Rgb(165, 42, 42);

const Color silver     = Rgb(192,192,192);
