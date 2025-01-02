#include "System.h"
#include "TransformImage.h"
#include "Binarisation.h"

Binarisation::Binarisation(GdiRef source, int plage) : TraitementImage(source) {
	m_txt = "Binar.";
	m_plage = plage;
}

Binarisation::~Binarisation() {
}

Color Binarisation::traitementPixel(int x, int y) {
	color = getPixel(m_source, x, y);
	
	r = rValue(color);
	g = gValue(color);
	b = bValue(color);
	
	r = m_plage * ( 1 + r / m_plage ) - 1;
	g = m_plage * ( 1 + g / m_plage ) - 1;
	b = m_plage * ( 1 + b / m_plage ) - 1;
	
	r = minmax(r, 0, 255);
	g = minmax(g, 0, 255);
	b = minmax(b, 0, 255);
	
	color = Rgb(
				(byte)r,
				(byte)g,
				(byte)b);
	
	return color;
}
