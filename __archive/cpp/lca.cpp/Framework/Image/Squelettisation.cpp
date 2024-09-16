#include "System.h"
#include "TransformImage.h"
#include "Squelettisation.h"
#include "grayscale.h"

int squelettisation[8][3][3] =  {
{ {2, 0, 1},  {2, 1, 1},  {2, 0, 1} },
{ {2, 2, 0},  {2, 1, 1},  {0, 1, 1} },
{ {2, 2, 2},  {0, 1, 0},  {1, 1, 1} },
{ {0, 2, 2},  {1, 1, 2},  {1, 1, 0} },
{ {1, 0, 2},  {1, 1, 2},  {1, 0, 2} },
{ {1, 1, 0},  {1, 1, 2},  {0, 2, 2} },
{ {1, 1, 1},  {0, 1, 0},  {2, 2, 2} },
{ {0, 1, 1},  {2, 1, 1},  {2, 2, 0} },
};

Squelettisation::Squelettisation(GdiRef source) : TraitementImage(source) {
	m_txt = "Squel.";
	m_n = 8;
	
	wf = (int)(sqrt(sizeof(squelettisation[0])/sizeof(int)));
	hf = wf;
}

Squelettisation::~Squelettisation() {
}

Color Squelettisation::run(GdiRef source, int x, int y, int wf, int hf, int matrice[3][3]) {
	Color color = white;
	
	bool b1 = true;
	bool b2 = false;
	
	int xs = x - 1;  
	for ( int xf = 0 ; xf < wf ; ++xf, ++xs ) {
		int ys = y - 1;
		for ( int yf = 0 ; yf < hf ; ++yf, ++ys )
		{ 
			switch ( matrice[xf][yf] ) {
				case 1: {
					color = getPixel(source, xs, ys);
					b1 = b1 && ( color != white ? true : false );
					break;
				}
				case 2: {
					color = getPixel(source, xs, ys);
					b2 = b2 || ( color != white ? true : false );
					break;
				}
			}
		}
	}
	
	return ( b1 && !b2 ) ? white : getPixel(source, x, y);
}

void Squelettisation::preTraitement() {
	GrayScale(m_source).traitement();
}

Color Squelettisation::traitementPixel(int x, int y) {
	return run(tmp1, x, y, wf, hf, squelettisation[m]);
}
