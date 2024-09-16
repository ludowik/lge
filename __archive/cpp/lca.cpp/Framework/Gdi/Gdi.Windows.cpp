#include "System.h"

#include "Brush.h"
#include "Pen.h"

#include "Gdi.Windows.h"

#include "OpenGL.h"

#if defined(_WINDOWS)

#define cgRGB(color) RGB(rValue(color), gValue(color), bValue(color))

Rect cgRect2rect(RECT cgRect) {
	Rect rect;

	rect.x = cgRect.left;
	rect.y = cgRect.top;

	rect.w = cgRect.right-cgRect.left;
	rect.h = cgRect.bottom-cgRect.top;

	return rect;
}

RECT rect2cgRect(Rect rect) {
	RECT cgRect = {0,0,0,0};

	cgRect.left = rect.left();
	cgRect.top = rect.top();

	cgRect.right  = rect.right();
	cgRect.bottom = rect.bottom();

	return cgRect;
}

const char* classGdiWindows = "Gdi.Windows";

GdiWindows::GdiWindows() : Gdi() {
	m_class = classGdiWindows;

	m_ctx = 0;
	
	m_bitmap = 0;
	m_bitmapOld = 0;

	m_data = 0;
}

GdiWindows::~GdiWindows() {
	release();
}

bool GdiWindows::isValid() {
	return m_ctx ? true : false;
}

void GdiWindows::initWithCurrentContext() {
}

void GdiWindows::create(int w, int h) {
	release();

	m_rect.w = w;
	m_rect.h = h;

	HWND wnd = (HWND)System::Media::getActiveWindow();
	HDC dc = GetDC(wnd); {
		m_ctx = CreateCompatibleDC(dc);
		m_bitmap = CreateCompatibleBitmap(dc, w, h);

		m_bitmapOld = (HBITMAP)SelectObject(m_ctx, m_bitmap);
	}
	ReleaseDC(wnd, dc);

	setPen(white);
	setBrush(transparentColor);

	BitBlt(dc, 0, 0, w, h, 0, 0, 0,	BLACKNESS);
}

void GdiWindows::release() {
	if ( m_ctx ) {
		SelectObject(m_ctx, m_bitmapOld);

		DeleteObject(m_bitmap);
		DeleteDC(m_ctx);

		m_ctx = 0;
		m_bitmap = 0;
	}

	if ( m_data ) {
		free(m_data);
		m_data = 0;
	}
}

#define DIRECT_DRAW 1

#if DIRECT_DRAW
PAINTSTRUCT ps;
#endif

void GdiWindows::begin() {
	Gdi::begin();

#if DIRECT_DRAW
	HWND wnd = (HWND)System::Media::getActiveWindow();
	m_ctx = BeginPaint(wnd, &ps);

#endif
}

void GdiWindows::end() {
#if DIRECT_DRAW
	HWND wnd = (HWND)System::Media::getActiveWindow();
	EndPaint(wnd, &ps);

#else
	PAINTSTRUCT ps;
	HWND wnd = (HWND)System::Media::getActiveWindow();
	HDC hdc = BeginPaint(wnd, &ps); {
		BitBlt(hdc, 0, 0, m_rect.w, m_rect.h, m_ctx, 0, 0, SRCCOPY);
	}
	EndPaint(wnd, &ps);

#endif
}

void GdiWindows::erase(Color color) {
	Gdi::erase(color);
}

void GdiWindows::loadRes(const char* id, int w, int h) {
	release();
	
	HINSTANCE hInst = (HINSTANCE)System::Media::getActiveInstance();
	
	HRSRC hResource = FindResourceA(hInst, id, "PNG");
	assert(hResource);
	
	DWORD imageSize = SizeofResource(hInst, hResource);
	assert(imageSize);

	HGLOBAL m_hBuffer = GlobalAlloc(GMEM_MOVEABLE, imageSize);
	assert(m_hBuffer);

	void* pBuffer = GlobalLock(m_hBuffer);
	if ( pBuffer ) {
		HGLOBAL hglobalResource = LoadResource(hInst, hResource);
		const void* pResourceData = LockResource(hglobalResource);
		assert(pResourceData);

		CopyMemory(pBuffer, pResourceData, imageSize);

		IStream* pStream = NULL;
		if ( CreateStreamOnHGlobal(m_hBuffer, TRUE, &pStream) == S_OK ) {
			Gdiplus::Bitmap rBitmap(pStream);
			pStream->Release();

			if ( rBitmap.GetLastStatus() == Gdiplus::Ok ) {
				w = m_rect.w = w ? w : rBitmap.GetWidth ();
				h = m_rect.h = h ? h : rBitmap.GetHeight();

				HWND wnd = (HWND)System::Media::getActiveWindow();
				HDC dc = GetDC(wnd); {
					m_ctx = CreateCompatibleDC(dc);
					m_bitmap = CreateCompatibleBitmap(dc, w, h);

					m_bitmapOld = (HBITMAP)SelectObject(m_ctx, m_bitmap);

					setPen(white);
					setBrush(transparentColor);

					BitBlt(m_ctx, 0, 0, w, h, 0, 0, 0, BLACKNESS);

					Gdiplus::Color colorBackground;
					rBitmap.GetPixel(0, 0, &colorBackground);

					HBITMAP hb = 0;
					HBITMAP hbOld = 0;
					if ( rBitmap.GetHBITMAP(colorBackground, &hb) == Gdiplus::Ok ) {
						HDC dc2 = CreateCompatibleDC(dc);
						hbOld = (HBITMAP)SelectObject(dc2, hb);

						if ( 1 ) {
							TransparentBlt(m_ctx, 0, 0, m_rect.w, m_rect.h, dc2, 0, 0, rBitmap.GetWidth(), rBitmap.GetHeight(), colorBackground.ToCOLORREF());
						} else {
							StretchBlt(m_ctx, 0, 0, m_rect.w, m_rect.h, dc2, 0, 0, rBitmap.GetWidth(), rBitmap.GetHeight(), SRCCOPY);
						}

						SelectObject(dc2, hbOld);
						DeleteDC(dc2);
					}
				}
				ReleaseDC(wnd, dc);
			}
		}
		UnlockResource(hglobalResource);
		
		GlobalUnlock(m_hBuffer);
	}
	GlobalFree(m_hBuffer);
}

COLORREF g_pen;
COLORREF g_brush;

void GdiWindows::setPen(Color color) {
	if ( color != defaultColor  ) {
		g_pen = cgRGB(color);
		SetTextColor(m_ctx, g_pen);
		SetBkColor(m_ctx, g_pen);
		SetBkMode(m_ctx, TRANSPARENT);
	}
}

void GdiWindows::setBrush(Color color, int mode) {
	if ( color != defaultColor  ) {
		g_brush = cgRGB(color);
	}
}

void GdiWindows::ball(int x, int y, int r, Color strokeColor, Color fillColor) {
	circle(x, y, r, strokeColor, fillColor);
}

void GdiWindows::pixel(int x, int y, Color color) {
	if ( m_penSize == 1 ) {
		SetPixel(m_ctx, x, y, cgRGB(color));
	}
	else {
		int penSize = m_penSize/2;
		Rect rct(x-penSize, y-penSize, m_penSize, m_penSize);
		rect(&rct, color, color);
	}
}

Color GdiWindows::getPixel(int x, int y) {
	return GetPixel(m_ctx, x, y);
}

void GdiWindows::line(int x, int y, int x2, int y2, Color color) {
	Pen pen(this, color, m_penSize);

	MoveToEx(m_ctx, x, y, 0);
	LineTo(m_ctx, x2, y2);
}

void GdiWindows::lines(int npoints, PointRef ppoints, Color color, int x, int y, bool close) {	
	Pen pen(this, color, m_penSize);

	MoveToEx(m_ctx, x+ppoints[0].x, y+ppoints[0].y, 0);
	for ( int i = 1 ; i < npoints ; ++i ) {
		LineTo(m_ctx, x+ppoints[i].x, y+ppoints[i].y);
	}

	if ( close ) {
		LineTo(m_ctx, ppoints[0].x, ppoints[0].y);
	}
}

void GdiWindows::lines(CollectionRef collection, Color color, int x, int y, double rw, double rh, bool close) {	
	if ( collection->getCount() > 0 ) {
		Pen pen(this, color, m_penSize);

		Iterator iter = collection->getIterator();

		PointRef first = (PointRef)iter.next();

		MoveToEx(m_ctx, (int)(x+((double)first->x*rw)), (int)(y+((double)first->y*rh)), 0);
		while ( iter.hasNext() ) {
			PointRef point = (PointRef)iter.next();
			LineTo(m_ctx, (int)(x+((double)point->x*rw)), (int)(y+((double)point->y*rh)));
		}

		if ( close ) {
			LineTo(m_ctx, (int)(x+((double)first->x*rw)), (int)(y+((double)first->y*rh)));
		}
	}
}

void GdiWindows::rect(Rect* rect, Color strokeColor, Color fillColor) {
	Brush brush(this, fillColor);
	Pen pen(this, strokeColor, m_penSize);

	RECT cgRect = rect2cgRect(*rect);	

	Rectangle(m_ctx, cgRect.left, cgRect.top, cgRect.right, cgRect.bottom); 	
}

void GdiWindows::ellipse(int x, int y, int w, int h, Color strokeColor, Color fillColor) {
	Brush brush(this, fillColor);
	Pen pen(this, strokeColor, m_penSize);

	Ellipse(m_ctx, x, y, x+w, y+h);
}

void GdiWindows::pie(int x, int y, int r, double startAngle, double sweepAngle, Color strokeColor, Color fillColor) {
	Brush brush(this, fillColor);
	Pen pen(this, strokeColor, m_penSize);

	double xs = x + (double)r * cos(degree2radian(startAngle));
	double ys = y - (double)r * sin(degree2radian(startAngle));
	
	double xe = x + (double)r * cos(degree2radian(startAngle+sweepAngle));
	double ye = y - (double)r * sin(degree2radian(startAngle+sweepAngle));

	Chord(m_ctx, x-r, y-r, x+r, y+r, (int)xs, (int)ys, (int)xe, (int)ye);
	
	if ( fillColor != transparentColor ) {
		MoveToEx(m_ctx, (int)x, (int)y, 0);
		
		LineTo(m_ctx, (int)xs, (int)ys);
		LineTo(m_ctx, (int)xe, (int)ye);
		LineTo(m_ctx, (int)x , (int)y );

		Ensemble ex = ensemble(3, (double)x, (double)xs, (double)xe);
		int xf = (int)moyenne(ex).getVal();

		Ensemble ey = ensemble(3, (double)y, (double)ys, (double)ye);
		int yf = (int)moyenne(ey).getVal();

		ExtFloodFill(m_ctx, xf, yf, cgRGB(strokeColor), FLOODFILLBORDER);
	}
}

void GdiWindows::roundrect(Rect* rect, int radius, Color strokeColor, Color fillColor, int strokeSize) {
	Brush brush(this, fillColor);
	Pen pen(this, strokeColor, m_penSize);

	RECT cgRect = rect2cgRect(*rect);

	RoundRect(m_ctx, cgRect.left, cgRect.top, cgRect.right, cgRect.bottom, radius, radius);
}

HFONT hFontNew = 0;
HFONT hFontOld = 0;
void GdiWindows::textInRectInit(Color fontColor, const char* fontName, int fontSize) {
	LOGFONTA lf;
	memset(&lf, 0, sizeof(LOGFONTA));

	strcmp(lf.lfFaceName, fontName);
	lf.lfHeight = fontSize;

	hFontNew = CreateFontIndirectA(&lf);
	hFontOld = (HFONT)SelectObject(m_ctx, hFontNew);
	
	setPen(fontColor);
}

Size GdiWindows::textInRectGetLen(const char* txt, int len, int fontSize, const char* fontName) {
	Size size;
	
	RECT to = {0,0,0,0};
	DrawTextA(m_ctx, txt, len, &to, DT_CALCRECT);

	size.w = to.right - to.left;
	size.h = to.bottom  - to.top;

	return size;
}

void GdiWindows::drawText(int x, int y, const char* txt, int len, Color fontColor, const char* fontName, int fontSize, int fontAngle) {
	RECT to = {0,0,0,0};
	to.left = x;
	to.top = y;

	DrawTextA(m_ctx, txt, len, &to, DT_SINGLELINE|DT_NOCLIP);
}

void GdiWindows::textInRectFree() {
	SelectObject(m_ctx, hFontOld);
	DeleteObject(hFontNew);
}

void GdiWindows::copy(GdiRef _gdi, Color color) {
	GdiWindowsRef gdi = (GdiWindowsRef)_gdi;
	copy(gdi, 0, 0,
		min(m_rect.w, gdi->m_rect.w),
		min(m_rect.h, gdi->m_rect.h), color);
}

void GdiWindows::copy(GdiRef _gdi, int xd, int yd, Color color) {
	GdiWindowsRef gdi = (GdiWindowsRef)_gdi;
	copy(gdi, xd, yd,
		min(m_rect.w, gdi->m_rect.w),
		min(m_rect.h, gdi->m_rect.h), color);
}

void GdiWindows::copy(GdiRef _gdi, int xd, int yd, int wd, int hd, Color color) {
	GdiWindowsRef gdi = (GdiWindowsRef)_gdi;
	copy(gdi, xd, yd, wd, hd, 0, 0, wd, hd, color);
}

void GdiWindows::copy(GdiRef _gdi, int xd, int yd, int wd, int hd, int xs, int ys, int ws, int hs, Color color) {
	GdiWindowsRef gdi = (GdiWindowsRef)_gdi;
	if ( color == nullColor ) {
		StretchBlt(m_ctx, xd, yd, wd, hd, gdi->m_ctx, xs, ys, ws, hs, SRCCOPY);
	}
	else {
		TransparentBlt(m_ctx, xd, yd, wd, hd, gdi->m_ctx, xs, ys, ws, hs, black/*cgRGB(color)*/);
	}
}

void GdiWindows::gradient(int x, int y, int w, int h, int mode, Color rgbFrom, Color rgbTo, GdiRef mask) {
	TRIVERTEX vertex[] = {
		{x  , y  , COLOR16(rValue(rgbFrom)<<8), COLOR16(gValue(rgbFrom)<<8), COLOR16(bValue(rgbFrom)<<8), 0},
		{x+w, y+h, COLOR16(rValue(rgbTo  )<<8), COLOR16(gValue(rgbTo  )<<8), COLOR16(bValue(rgbTo  )<<8), 0}
	};

	GRADIENT_RECT rect = {0, 1};

	switch ( mode ) {
		case eHorizontal: {
			GradientFill(m_ctx, vertex, 2, &rect, 1, GRADIENT_FILL_RECT_H);
			break;
		};
		default:
		case eDiagonal:
		case eVertical: {
			GradientFill(m_ctx, vertex, 2, &rect, 1, GRADIENT_FILL_RECT_V);
			break;
		};
	}
}

#endif
