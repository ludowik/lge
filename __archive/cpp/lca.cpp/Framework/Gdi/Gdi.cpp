#include "System.h"
#include "CardGame.Cards.h"
#include "Gdi.h"
#include "Gdi.OpenGL.h"

//NSString* nst(const char* s);

GdiRef createGdi() {
	GdiRef gdi;
	if ( System::Media::getGdiMode() == gdiModeGdi ) {
		gdi = new GdiWindows();
	}
	else {
		gdi = new GdiOpenGL();
	}

	return gdi;
}

Gdi::Gdi() : Object("Gdi") {	
	m_penSize = 1;

	m_fontName = defaultFontName;
	m_fontSize = fontStandard;
}

Gdi::~Gdi() {
	release();
}

void Gdi::initWithCurrentContext() {
}

void Gdi::create() {
	m_rect = System::Media::getWindowsSize();
	create(m_rect.w, m_rect.h);	
}

void Gdi::createBitmapDevice(int w, int h, bool allocData) {
	create(w, h);
}

void Gdi::createGrayDevice(int w, int h, bool allocData) {
	create(w, h);
}

void Gdi::begin() {
	if ( !isValid() ) {
		create();
	}
	
	setPen(white);
	setBrush(transparentColor);
}

void Gdi::draw() {
	erase();
}

void Gdi::release() {
}

bool Gdi::save(File& file) {
	return true;
}

bool Gdi::load(File& file) {
	return true;
}

void Gdi::setPenSize(int size) {
	m_penSize = max(1, size);
}

void Gdi::setFont(const char* fontName, int fontSize, int fontAngle) {
	m_fontName = fontName ? fontName : defaultFontName;
	m_fontSize = fontSize ? fontSize : fontStandard;

	m_fontAngle = fontAngle;
}

void Gdi::moveto(int x, int y) {
	m_previous = Point(x, y);
}

void Gdi::lineto(int x, int y, Color color) {
	line(m_previous.x, m_previous.y, x, y, color);
}

void Gdi::drawBitmap(const char* name, int x, int y, int w, int h) {
	if ( 0 ) {
		g_resources.draw(this, name, x, y, w, h);
	}
	else {
		BitmapRef bitmap = g_resources.makeBitmap(this, name, w, h);
		copy(bitmap, x, y);
	}
}

void Gdi::drawBitmap(CardRef card, int x, int y, int w, int h, int wv, int hv) {
	if ( 0 ) {
		card->draw(this, x, y, w, h);
	}
	else {
		BitmapRef bitmap = card->makeBitmap(this, w, h);
		copy(bitmap, x, y);
	}
}

void Gdi::draw(int x, int y, int w, int h, CardRef card, CardsRef cards, int wv, int hv) {
	if ( card ) {
		if ( card->m_reverse ) {
			drawBitmap("reverse", x, y, w, h);
		}
		else {
			drawBitmap(card, x, y, w, h, wv, hv);

			if ( card->m_select ) {
				// Carte selectionnee
				drawBitmap("select", x, y, w, h);
			}

		}
	}
	else {
		if ( cards ) {
			if ( cards->m_type == eEcart ) {
				// Les ecarts
				drawBitmap("ecart", x, y, w, h);
			}
			else if ( cards->m_type == eTalon ) {
				// Le talon
				drawBitmap("talon", x, y, w, h);
			}
			else {
				// Un tas vide
				drawBitmap("tas", x, y, w, h);
			}
		}
	}

	if ( cards && cards->m_type == eTalon ) {
		Talon* talon = (Talon*)cards;

		int n = talon->getCount();

		if ( n == 0 || talon->getLast()->m_reverse ) {
			String s;
			if ( n ) {
				// On affiche le nombre de carte du talon
				s = n;
			}
			else if ( talon->m_tourDeTalon == 0 ) {
				// Le talon ne peut plus tre retournee
				s = "X";
			}
			else {
				// Nombre de tour de talon restant
				s = talon->m_tourDeTalon;
			}

			int fontSize = w * 3 / 8;

			Rect size = getTextSize(s.getBuf(), 0, fontSize);
			text(x+(w-size.w)/2, y+(h-size.h)/2, s.getBuf(), black, 0, fontSize);
		}
	}
}

void Gdi::button(int x, int y, int w, int h, bool select, Color strokeColor, Color fillColor) {
	int radius = System::Media::getRadius();

	roundgradient(x, y, w, h, radius, eVertical, strokeColor, fillColor);
	roundrect(x, y, w, h, radius, white);
}

void Gdi::roundgradient(int x, int y, int w, int h, int radius,	int mode, Color rgbFrom, Color rgbTo) {
	if ( isKindOf(classGdiWindows) ) {
		GdiWindows gdi;
		
		gdi.createGrayDevice(w, h);
		
		gdi.roundrect(&gdi.m_rect, radius, white, white);
		
		gradient(x, y, w, h, mode, rgbFrom, rgbTo, &gdi);
	}
	else {
		gradient(x, y, w, h, mode, rgbFrom, rgbTo);
	}
}

void Gdi::erase(Color color) {
	rect(&m_rect, color, color);
}

void Gdi::rect(int x, int y, int w, int h, Color strokeColor, Color fillColor) {
	Rect rct(x, y, w, h);
	rect(&rct, strokeColor, fillColor);
}

void Gdi::circle(int x, int y, int r, Color strokeColor, Color fillColor) {
	int d = 2*r;
	ellipse(x-r, y-r, d, d, strokeColor, fillColor);
}

void Gdi::roundrect(int x, int y, int w, int h, int radius, Color strokeColor, Color fillColor, int strokeSize) {
	Rect rct(x, y, w, h);
	roundrect(&rct, radius, strokeColor, fillColor, strokeSize);
}

Rect Gdi::text(int x, int y, const char* str, Color fontColor, const char* fontName, int fontSize, int fontAngle) {
	Rect rect = textInRect(x, y, m_rect.right(), m_rect.bottom(), str, fontColor, fontName, fontSize, fontAngle);
	return rect;
}
	
Rect Gdi::getTextSize(const char* str, const char* fontName, int fontSize, int fontAngle) {
	Rect rect = text(0, 0, str, nullColor, fontName, fontSize, fontAngle);
	return rect;
}

Rect Gdi::textInRect(int _x, int _y, int _r, int _b, const char* str, Color fontColor, const char* _fontName, int _fontSize, int _fontAngle) {
	Rect rect;
	Rect to;

	bool calcSize = fontColor == nullColor ? true : false;

	const char* fontName = _fontName !=  NULL ? _fontName  : (m_fontName != NULL ? m_fontName : defaultFontName);

	int fontSize  = _fontSize > 0 ? _fontSize  : (m_fontSize > 0 ? m_fontSize : fontStandard);
	int fontAngle = _fontSize > 0 ? _fontAngle : m_fontAngle;

	textInRectInit(fontColor, fontName, fontSize);

	int x = _x;
	int y = _y;

	rect.x = x;
	rect.y = y;

	int nline = 1;

	int marginIn = 2;

	Size sizeSpace = textInRectGetLen(" ", 1, fontSize, fontName);

	bool first = true;
	
	const char* txt = str;
	while ( *txt ) {
		// A partir de ...
		to.x = x;
		to.y = y;

		// Les espaces
		int len = 0;
		if ( txt[len] == ' ' ) {
			len = 1;
			while ( txt[len] == ' ' ) {
				len++;
			}
		}
		txt += len;

		int sizeSpaces = len * sizeSpace.w;
		x += sizeSpaces;

		// Le prochain mot
		len = 0;
		while ( txt[len] && txt[len] != ' ' ) {
			len++;
		}

		// Calcul de la taille
		Size size = textInRectGetLen(txt, len, fontSize, fontName);
		
		to.w = size.w + sizeSpaces;
		to.h = max(to.h, size.h);

		if ( *txt == '\n' ) {
			// Saut à la ligne
			x = _x;
			y += fontSize+marginIn;

			txt++;
			nline++;
		}
		else if ( first == false && to.right() > _r && y + fontSize < _b ) {
			// Saut a la ligne force par l'affichage
			x = _x;
			y += fontSize+marginIn;

			while ( *txt && *txt == ' ' ) {
				txt++;
			}
			nline++;
		}
		else {
			first = false;
			
			// Affichage du mot courant
			if ( !calcSize ) {
				drawText(x, y, txt, len, fontColor, fontName, fontSize, fontAngle);
			}

			x = to.right();
			rect.w = max(rect.w, x-_x);

			txt += len;
		}
	}

	rect.h = nline * ( fontSize + marginIn ) - marginIn;

	m_positionNextText.x = x;
	m_positionNextText.y = y;

	textInRectFree();

	return rect;
}
