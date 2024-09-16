#include "System.h"
#include "TransformImage.h"
#include "Luminosite.h"

Luminosite::Luminosite(GdiRef source, double lum) : TraitementImage(source) {
	m_txt = "Lumiere";
	m_lum = lum;
}

Luminosite::~Luminosite() {
}

void Luminosite::getParam() {
	Menu menu;
	
	menu.add(new ButtonControl("80%", 80));
	menu.add(new ButtonControl("60%", 60));
	menu.add(new ButtonControl("40%", 40));
	menu.add(new ButtonControl("20%", 20));
	
	m_lum = menu.run() / 100.;
}

Color Luminosite::traitementPixel(int x, int y) {
	return luminosity(getPixel(m_source, x, y), m_lum);
}
