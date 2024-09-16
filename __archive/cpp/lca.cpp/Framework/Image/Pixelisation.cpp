#include "System.h"
#include "TransformImage.h"
#include "Pixelisation.h"

Pixelisation::Pixelisation(GdiRef source, int np) : TraitementImage(source) {
	m_txt = "Pixel";
	m_np = np;
}

Pixelisation::~Pixelisation() {
}

void Pixelisation::getParam() {
	Menu menu;
	
	menu.add(new ButtonControl("2", 2));
	menu.add(new ButtonControl("4", 4));
	menu.add(new ButtonControl("6", 6));
	menu.add(new ButtonControl("8", 8));
	
	int np = menu.run();
	if ( np > 0 ) { 
		m_np = np;
	}
}

Color Pixelisation::traitementPixel(int x, int y) {
	if ( ( x % m_np ) != 0 || ( y % m_np ) != 0 ) {
		return nullColor;
	}
	
	int nb = m_np * m_np;
	
	r = 0;
	g = 0;
	b = 0;
	
	for ( int xp = x ; xp < x + m_np ; ++xp )  {
		for ( int yp = y ; yp < y + m_np ; ++yp ) {
			color = getPixel(m_source, xp, yp);
			
			r += rValue(color);
			g += gValue(color);
			b += bValue(color);
		}
	}
	
	color = Rgb(
				(byte)divby(r, nb),
				(byte)divby(g, nb),
				(byte)divby(b, nb));
	
	for ( int xp = x ; xp < x + m_np ; ++xp )  {
		for ( int yp = y ; yp < y + m_np ; ++yp ) {
			m_cible->pixel(xp, yp, color);
		}
	}
	
	return color;
}
