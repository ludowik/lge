#include "System.h"
#include "TransformImage.h"
#include "Dilatation.h"
#include "GrayScale.h"

int dilatation[3][3] =  {
{1, 1, 1},
{1, 0, 1},
{1, 1, 1}
};

Dilatation::Dilatation(GdiRef source) : TraitementImage(source) {
	m_txt = "Dilater";
	
	wf = (int)(sqrt(sizeof(dilatation)/sizeof(int)));
	hf = wf;
	
	GrayScale(m_source).traitement();
}

Dilatation::~Dilatation() {
}

Color Dilatation::run(GdiRef source, int x, int y, int wf, int hf, int matrice[3][3]) {
	Color color = white;
	
	bool b = false;
	
	int xs = x - 1;  
	for ( int xf = 0 ; xf < wf ; ++xf, ++xs ) {
		int ys = y - 1;
		for ( int yf = 0 ; yf < hf ; ++yf, ++ys )
		{ 
			switch ( matrice[xf][yf] ) {
				case 1: {
					color = getPixel(m_source, xs, ys);
					b = b || ( color != white ? true : false );
					break;
				}
			}
		}
	}
	
	return b ? black : getPixel(m_source, x, y);
}

Color Dilatation::traitementPixel(int x, int y) {
	return run(m_source, x, y, wf, hf, dilatation);
}
