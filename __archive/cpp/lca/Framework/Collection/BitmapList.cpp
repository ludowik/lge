#include "System.h"
#include "BitmapList.h"

BitmapList g_resources;

BitmapList::BitmapList() {
	m_collection = new List();
}

BitmapList::~BitmapList() {
}

BitmapRef BitmapList::loadRes(const char* id, int w, int h) {
	BitmapRef bitmap = new Bitmap();
	
	bitmap->loadRes(id, w, h);
	bitmap->m_idBitmap = id;

	return (BitmapRef)Collection::add(bitmap);
}

void BitmapList::loadMultipleRes(const char* id, int nx, int ny, int w, int h) {
	Bitmap image;
	
	image.loadRes(id);
	image.m_idBitmap = id;

	int x = 0;
	int y = 0;
	
	int dx = image.m_rect.w / nx;
	int dy = image.m_rect.h / ny;

	w = w ? w : dx;
	h = h ? h : dy;

	fromto(int, iy, 0, ny) {
		x = 0;
		fromto(int, ix, 0, nx) {
			String idName(id);
			idName += String(w+h);
			
			BitmapRef bitmap = new Bitmap();	
			bitmap->create(w, h);
			
			bitmap->m_idBitmap = idName;
			bitmap->m_idRes = id;
			
			bitmap->copy(&image, 0, 0, w, h, x, y, dx, dy);

			Collection::add(bitmap);

			x += dx;
		}
		y += dy;
	}
}

BitmapRef BitmapList::makeBitmap(GdiRef gdi, const char* id, int w, int h) {
	String idName(id);
	idName += String(w+h);
	
	int n = getCount();
	for ( int i = 0 ; i < n ; ++ i ) {
		BitmapRef bitmap = (BitmapRef)Collection::get(i);
		if ( bitmap->m_idBitmap == idName ) {
			return bitmap;
		}
	}
	
	BitmapRef bitmap = new Bitmap();
	bitmap->create(w, h);
	bitmap->m_idBitmap = idName;

	if ( draw(bitmap, id, 0, 0, w, h) ) {
		return (BitmapRef)Collection::add(bitmap);
	}
	
	delete bitmap;

	bitmap = BitmapList::loadRes(id, w, h);
	bitmap->m_idBitmap = idName;
	
	return bitmap;
}

bool BitmapList::draw(GdiRef gdi, const char* name, int x, int y, int w, int h) {
	int radius = max(w,h)/10;
	
	Rect rect(x+1, y+1, w-2, h-2);	
	
	String sname(name);
	if ( sname.equal("select") ) {
		gdi->roundrect(&rect, radius, red);
	}
	else if ( sname.equal("reverse") ) {
		gdi->roundgradient(rect.x, rect.y, rect.w, rect.h, radius, eDiagonal, blueLight, blue);
		gdi->roundrect(&rect, radius, white);
	}
	else if ( sname.equal("ecart") ) {
		int fontSize = w * 3 / 8;
		gdi->roundrect(&rect, radius, white);
		const char* a = "A";
		Rect textSize = gdi->getTextSize(a, 0, fontSize);
		gdi->text(rect.x+(w-textSize.w)/2-1, rect.y+(h-textSize.h)/2-1, a, white, 0, fontSize);
	}
	else if ( sname.equal("tas") ) {
		int fontSize = w * 3 / 8;
		gdi->roundrect(&rect, radius, white);
		const char* a = "R";
		Rect textSize = gdi->getTextSize(a, 0, fontSize);
		gdi->text(rect.x+(w-textSize.w)/2-1, rect.y+(h-textSize.h)/2-1, a, white, 0, fontSize);
	}
	else if ( sname.equal("talon") ) {
		gdi->roundrect(&rect, radius, white);
	}
	else if ( sname.equal("bgSelect") ) {
		gdi->roundrect(&rect, radius, red, white);
	}
	else if ( sname.equal("bgUnselect") ) {
		gdi->roundrect(&rect, radius, black, white);
	}
	else {
		return false;
	}

	return true;
}
