#include "System.h"
#include "TransformImage.h"
#include "Blur.h"

int blur[3][3] = {
{ 0, 1, 0},
{ 1, 0, 1},
{ 0, 1, 0},
};

Blur::Blur(GdiRef source) : TraitementImage(source) {
	m_txt = "Blur";
	
	wf = (int)(sqrt(sizeof(blur)/sizeof(int)));
	hf = wf;
	
	total = Total(wf, hf, blur);
}

Blur::~Blur() {
}

int Blur::Total(int wf, int hf, int matrice[3][3]) {
	int total = 0;
	
	for ( int xf = 0 ; xf < wf ; ++xf ) {
		for ( int yf = 0 ; yf < hf ; ++yf ) {
			total += matrice[xf][yf];
		}
	}
	
	return total;
}

Color Blur::Convolution(GdiRef source, int x, int y, int wf, int hf, int matrice[3][3], int total) {
	Color color;
	
	int r = 0;
	int g = 0;
	int b = 0;
	
	int coef = 0;
	
	for ( int xf = 0 ; xf < wf ; ++xf ) {
		for ( int yf = 0 ; yf < hf ; ++yf ) {
			int xs = x + xf - 1;
			int ys = y + yf - 1;
			
			color = getPixel(source, xs, ys);
			
			coef = matrice[xf][yf];
			
			r += rValue(color) * coef;
			g += gValue(color) * coef;
			b += bValue(color) * coef;
		}
	}
	
	r = (int)divby(r, total);
	g = (int)divby(g, total);
	b = (int)divby(b, total);
	
	return Rgb(
			   (byte)r,
			   (byte)g,
			   (byte)b);
}

Color Blur::traitementPixel(int x, int y) {
	return Convolution(m_source, x, y, wf, hf, blur, total);
}
