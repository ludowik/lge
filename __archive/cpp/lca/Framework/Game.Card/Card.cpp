#include "System.h"
#include "Card.h"

int as;
int valet;
int cavalier;
int dame;
int roi;

int Card::as = 1;
int Card::valet = 11;
int Card::cavalier = 12;
int Card::dame = 12;
int Card::roi = 13;

Card::Card() : Object("Card") {
	m_serie = 0;
	m_val = 0;
	
	m_select = false;
	m_reverse = false;
	m_check = false;
	
	m_rect = Rect();
}

Card::Card(int serie, int val) : Object("Card") {
	m_serie = serie;
	m_val = val;
	
	m_select = false;
	m_reverse = false;
	m_check = false;
	
	m_rect = Rect();
}

const char* Card::asString() {
	if ( m_serie != eAtout ) {
		if ( m_val == 1 ) {
			return "A";
		}
		else if ( m_val == valet ) {
			return "J";
		}
		else if ( m_val == dame ) {
			return "Q";
		}
		else if ( m_val == roi ) {
			return "K";
		}
		else if ( m_val == cavalier ) {
			return "C";
		}
		else if ( m_val == eJocker ) {
			return "Jocker";
		}
	}
	else if ( m_val == eExcuse ) {
		return "E";
	}
	
	static char val[3];
	sprintf(val, "%d", m_val);
	
	return val;
}

bool Card::save(File& file) {
	if ( Object::save(file) ) {
		file << m_serie;
		file << m_val;
		file << m_select;
		file << m_reverse;
		file << m_check;
		return true;
	}
	return false;
}

bool Card::load(File& file) {
	if ( Object::load(file) ) {
		file >> m_serie;
		file >> m_val;
		file >> m_select;
		file >> m_reverse;
		file >> m_check;
		return true;
	}
	return false;
}

BitmapRef Card::makeBitmap(GdiRef gdi, int w, int h) {
	BitmapRef bitmap = m_select ? &m_bitmapSelected : &m_bitmap;
	if ( bitmap->m_rect.w != w ) {
		bitmap->release();
	}
	
	if ( bitmap->isValid() == false ) {
		bitmap->create(w, h);

		draw(bitmap, 0, 0, w, h);
	}
	
	return bitmap;
}

void Card::draw(GdiRef gdi, int x, int y, int w, int h) {
	// Mini-carte ou carte standard
	bool mini = System::Media::getMachineType() == iPhone ? true : false;
	
	// Calcul de la taille de la fonte
	int fontSize = (int) ( w * 0.42 );
	
	// La famille
	const char* name = 0;
	switch ( m_serie ) {
		case eCoeur    : name = "coeur.png"; break;
		case eCarreau  : name = "carreau.png"; break;
		case eTrefle   : name = "trefle.png"; break;
		case ePique    : name = "pique.png"; break;
	}
	assert(name);
	
	// Les représentations de la famille (2 tailles)
	int w1 = (int)( w * 0.42 );
	BitmapRef gdi1 = g_resources.makeBitmap(0, name, w1, w1);
	
	int w2 = (int)( w * 0.50 );
	BitmapRef gdi2 = g_resources.makeBitmap(0, name, w2, w2);
	
	// La valeur de la carte
	Color fg = black;
	switch ( m_serie ) {
		case eCoeur: 
		case eCarreau: {
			fg = red;
			break;
		}
		default:
		case eTrefle: 
		case ePique: {
			fg = black;
			break;
		}
	}

	// Dessin du fond de la carte
	int d = 4;
	int radius = max(w,h)/10;
	
	Rect rect(x+1, y+1, w-2, h-2);
	
	Color gradientColor = m_select ? redLight : blueLight;
	gdi->roundgradient(rect.x, rect.y, rect.w, rect.h, radius, eDiagonal, white, gradientColor);
	
	if ( mini ) {
		// Dessin de la famille
		if ( gdi1 ) {
			Rect rc1 = gdi1->m_rect;
			gdi->copy(gdi1, x+w-rc1.w-d/2-1, y+d);
		}
	
		if ( gdi2 ) {
			Rect rc2 = gdi2->m_rect;
			gdi->copy(gdi2, x+(w-rc2.w)/2, y+(int)((h-rc2.h)*0.9));
		}	
    
		// Dessin de la valeur de la carte
		const char* s = asString();
		if ( m_val == 10 ) {
			gdi->text(x+d/2, y+d, s, fg, 0, fontSize);
		}
		else {
			gdi->text(x+d, y+d, s, fg, 0, fontSize);
		}

	}
	else { 
		// Dessin de la famille
		if ( gdi1 ) {
			Rect rc1 = gdi1->m_rect;
			gdi->copy(gdi1, x+w-rc1.w-d-1, y+d);
			gdi->copy(gdi1, x+d, y+h-rc1.h-d-1);
		}
	
		if ( gdi2 ) {
			Rect rc2 = gdi2->m_rect;
			gdi->copy(gdi2, x+(w-rc2.w)/2, y+(h-rc2.h)/2);
		}	
    
		// Dessin de la valeur de la carte
		const char* s = asString();	
		Rect size = gdi->text(x+d, y+d, s, fg, 0, fontSize);
		gdi->text(x+w-d-size.w-1, y+h-d-size.h-1, s, fg, 0, fontSize);
	}
}
