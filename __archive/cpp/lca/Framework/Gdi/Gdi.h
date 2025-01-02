#pragma once

DeclareClass(String);

DeclareClass(Card);
DeclareClass(Cards);

#include "string.h"

#include "point.h"
#include "rect.h"
#include "size.h"
#include "line.h"

enum {
	eHorizontal,
	eVertical,
	eDiagonal
};

ImplementClass(Gdi) : public Object, public Font {
public:
	Rect m_rect;
	Rect m_redrawRect;

	Point m_previous;
	Point m_positionNextText;

public:
	int m_penSize;

public:
	Gdi();
	virtual ~Gdi();
	
public:
	virtual void initWithCurrentContext();
	
	virtual void create();	
	virtual void create(int w, int h)=0;

	virtual void createBitmapDevice(int w, int h, bool allocData=false);
	virtual void createGrayDevice(int w, int h, bool allocData=false);

	virtual void release();
	
public:
	virtual bool isValid()=0;
	
public:
	virtual void begin();
	virtual void draw();
	virtual void end()=0;

public:
	virtual void loadRes(const char* id, int w=0, int h=0)=0;
	
public:
	virtual bool save(File& file);
	virtual bool load(File& file);
	
public:
	virtual void setPen(Color color)=0;
	virtual void setPenSize(int size);

	virtual void setBrush(Color color, int mode=-1)=0;

	virtual void setFont(const char* fontName, int fontSize=0, int fontAngle=0);
	
public:
	virtual void erase(Color color=white);

public:
	virtual void pixel(int x, int y, Color color=defaultColor)=0;
	virtual Color getPixel(int x, int y)=0;
	
public:
	virtual void line(int x, int y, int x2, int y2, Color color=defaultColor)=0;
	virtual void lines(int npoints, PointRef ppoints, Color fg, int x=0, int y=0, bool close=true)=0;
	virtual void lines(CollectionRef collection, Color fg, int x=0, int y=0, double rw=1, double rh=1, bool close=true)=0;
	
public:
	virtual void moveto(int x, int y);
	virtual void lineto(int x, int y, Color color=defaultColor);
	
public:
	virtual void rect(Rect* rect, Color strokeColor=defaultColor, Color fillColor=nullColor)=0;
	virtual void roundrect(Rect* rect, int radius=0, Color strokeColor=defaultColor, Color fillColor=nullColor, int strokeSize=1)=0;
	
	virtual void rect(int x, int y, int w, int h, Color strokeColor=defaultColor, Color fillColor=nullColor);
	virtual void roundrect(int x, int y, int w, int h, int radius=0, Color strokeColor=defaultColor, Color fillColor=nullColor, int strokeSize=1);
	
	virtual void button(int x, int y, int w, int h, bool bselect, Color strokeColor=defaultColor, Color fillColor=nullColor);
	virtual void ball(int x, int y, int radius, Color strokeColor=defaultColor, Color fillColor=nullColor)=0;
	
public:
	virtual Rect text(int x, int y, const char* str, Color fontColor=defaultColor, const char* fontName=0, int fontSize=0, int fontAngle=0);
	virtual Rect textInRect(int x, int y, int r, int b, const char* str, Color fontColor=defaultColor, const char* fontName=0, int fontSize=0, int fontAngle=0);

	virtual Rect getTextSize(const char* str, const char* fontName=0, int fontSize=0, int fontAngle=0);

public:
	virtual void textInRectInit(Color fontColor, const char* fontName, int fontSize)=0;
	virtual Size textInRectGetLen(const char* txt, int len, int fontSize, const char* fontName)=0;
	virtual void drawText(int x, int y, const char* txt, int len, Color fontColor, const char* fontName, int fontSize, int fontAngle)=0;
	virtual void textInRectFree()=0;
	
public:
	virtual void ellipse(int x, int y, int w, int h, Color strokeColor, Color fillColor=nullColor)=0;
	virtual void circle (int x, int y, int radius, Color strokeColor, Color fillColor=nullColor);
	virtual void pie    (int x, int y, int radius, double startAngle, double sweepAngle, Color strokeColor, Color fillColor=nullColor)=0;
	
public:
	virtual void gradient(int x, int y, int w, int h,
						  int mode,
						  Color rgbFrom,
						  Color rgbTo,
						  GdiRef mask=0)=0;
	virtual void roundgradient(int x, int y, int w, int h, int radius,
							   int mode,
							   Color rgbFrom,
							   Color rgbTo);
	
public:
	virtual void copy(GdiRef gdi, Color color=nullColor)=0;
	virtual void copy(GdiRef gdi, int xd, int yd, Color color=nullColor)=0;
	virtual void copy(GdiRef gdi, int xd, int yd, int wd, int hd, Color color=nullColor)=0;
	virtual void copy(GdiRef gdi, int xd, int yd, int wd, int hd, int xs, int ys, int ws, int hs, Color color=nullColor)=0;

public:
	virtual void drawBitmap(const char* name, int x, int y, int w, int h);
	virtual void drawBitmap(CardRef card, int x, int y, int w, int h, int wv=-1, int hv=-1);

public:
	virtual void draw(int x, int y, int w, int h, CardRef card, Cards* cards, int wv=-1, int hv=-1);

};

GdiRef createGdi();
