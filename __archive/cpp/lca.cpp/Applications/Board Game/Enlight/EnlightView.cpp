#include "System.h"
#include "EnlightView.h"
#include "EnlightModel.h"

ApplicationObject<EnlightView, EnlightModel> appEnlight("Enlight", "Enlight", "enlight.png", 0, pageBoardGame);

EnlightView::EnlightView() : BoardView() {
}

void EnlightView::loadResource() {
	int d = m_wcell;
	int c = m_wcell/2;
	
	int radius = m_wcell/3;

	BitmapRef rBitmap = new Bitmap();
	rBitmap->create(d, d);
	rBitmap->ball(c, c, radius, blueDark, grayScaleColor(blue));
	m_resources.add(rBitmap);
	
	BitmapRef bBitmap = new Bitmap();
	bBitmap->create(d, d);
	bBitmap->ball(c, c, radius, redDark, grayScaleColor(red));
	m_resources.add(bBitmap);
}
