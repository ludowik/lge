#include "System.h"
#include "DameView.h"

ApplicationObject<DameView, DameModel> appDame("Dame", "Dame", "checkers.png", 0, pageBoardGame);

DameView::DameView() : BoardView() {
	m_annoted = true;
}

void DameView::loadResource() {
	int d = m_wcell;
	int c = m_wcell/2;
	
	int radius = m_wcell/3;

	BitmapRef rBitmap = new Bitmap();
	rBitmap->create(d, d);
	rBitmap->ball(c, c, radius, white, gray);
	m_resources.add(rBitmap);
	
	BitmapRef bBitmap = new Bitmap();
	bBitmap->create(d, d);
	bBitmap->ball(c, c, radius, gray, black);
	m_resources.add(bBitmap);
}
