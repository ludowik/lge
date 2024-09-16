#include "System.h"
#include "Puissance4View.h"

ApplicationObject<Puissance4View, Puissance4Model> appPuissance4("Puissance4", "Puissance4", "4balls.png", 0, pageBoardGame);

Puissance4View::Puissance4View() : BoardView() {
}

void Puissance4View::loadResource() {
	int d = m_wcell;
	int c = m_wcell/2;
	
	int radius = m_wcell/3;
	
	BitmapRef rBitmap = new Bitmap();
	rBitmap->create(d, d);
	rBitmap->ball(c, c, radius, blueDark, blue);
	m_resources.add(rBitmap);
	
	BitmapRef bBitmap = new Bitmap();
	bBitmap->create(d, d);
	bBitmap->ball(c, c, radius, redDark, red);
	m_resources.add(bBitmap);
}
