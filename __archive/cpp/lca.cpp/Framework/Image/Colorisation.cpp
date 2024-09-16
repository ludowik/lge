#include "System.h"
#include "TransformImage.h"
#include "Colorisation.h"

Colorisation::Colorisation(GdiRef source, int clr) : TraitementImage(source) {
	m_txt = "Color";
	m_clr = clr;
}

Colorisation::~Colorisation() {
}

void Colorisation::getParam() {
	Menu menu;
	
	menu.add(new ButtonControl("grb", 1));
	menu.add(new ButtonControl("rbg", 2));
	menu.add(new ButtonControl("bgr", 3));
	menu.add(new ButtonControl("rrr", 4));
	menu.add(new ButtonControl("ggg", 5));
	menu.add(new ButtonControl("bbb", 6));
	menu.add(new ButtonControl("r", 7));
	menu.add(new ButtonControl("g", 8));
	menu.add(new ButtonControl("b", 9));
	
	m_clr = menu.run();
}

Color Colorisation::traitementPixel(int x, int y) {
	color = getPixel(m_source, x, y);
	
	if ( color != white ) {
		r = rValue(color);
		g = gValue(color);
		b = bValue(color);
		
		switch ( m_clr ) {
			case 0: color = Rgb(r,g,b); break;
			case 1: color = Rgb(r,b,g); break;
			case 2: color = Rgb(g,r,b); break;
			case 3: color = Rgb(g,b,r); break;
			case 4: color = Rgb(b,r,g); break;
			case 5: color = Rgb(b,g,r); break;
			case 6: color = Rgb(r,g*.6,b*.6); break;
			case 7: color = Rgb(r*.6,g,b*.6); break;
			case 8: color = Rgb(r*.6,g*.6,b); break;
		}
	}
	
	return color;
}
