#pragma once

#if (_MAC)
	#import <OpenGLES/EAGL.h>
	#import <OpenGLES/EAGLDrawable.h>

	#import <QuartzCore/CAEAGLLayer.h>

#endif

#include "OpenGL.h"

void initCharTextures();
void freeCharTextures();

ImplementClass(GdiOpenGL) : public Gdi {
public:
	static unsigned int framebuffer;
	static unsigned int renderbuffer;
	
#if (_WINDOWS)
	static HDC g_openglCtx;
	HDC m_ctx;

#elif ( _MAC)
	static EAGLContext* g_openglCtx;
	EAGLContext* m_ctx;

#endif
	
public:
	GdiOpenGL();
	virtual ~GdiOpenGL();
	
public:
	static void releaseOpenGL();

public:
	virtual bool isValid();
	
	virtual void create(int w, int h);
	virtual void release();
	
	virtual void begin();
	virtual void draw();
	virtual void end();
	
public:
	virtual void loadRes(const char* id, int w=0, int h=0);
	
public:
	virtual void setPen  (Color color);
	virtual void setBrush(Color color, int mode=-1);
	
public:
	virtual void erase(Color color=white);
	
public:
	virtual void pixel(int x, int y, Color color=defaultColor);
	virtual Color getPixel(int x, int y);
	
public:
	virtual void line(int x, int y, int x2, int y2, Color color=defaultColor);
	virtual void lines(int npoints, PointRef ppoints, Color fg, int x=0, int y=0, bool close=true);
	virtual void lines(CollectionRef collection, Color fg, int x=0, int y=0, double rw=1, double rh=1, bool close=true);
	
public:
	virtual void rect(Rect* rect, Color strokeColor=defaultColor, Color fillColor=nullColor);
	virtual void roundrect(Rect* rect, int radius=0, Color strokeColor=defaultColor, Color fillColor=nullColor, int strokeSize=1);
	
public:
	virtual void ball(int x, int y, int radius, Color strokeColor=defaultColor, Color fillColor=nullColor);
	
public:
	virtual void textInRectInit(Color fontColor, const char* fontName, int fontSize);
	virtual Size textInRectGetLen(const char* txt, int len, int fontSize, const char* fontName);
	virtual void drawText(int x, int y, const char* txt, int len, Color fontColor, const char* fontName, int fontSize, int fontAngle);
	virtual void textInRectFree();

public:
	virtual void ellipse(int x, int y, int w, int h, Color strokeColor, Color fillColor=nullColor);
	virtual void pie    (int x, int y, int radius, double startAngle, double sweepAngle, Color strokeColor, Color fillColor=nullColor);
	
public:
	virtual void gradient(int x, int y, int w, int h,
						  int mode,
						  Color rgbFrom,
						  Color rgbTo,
						  GdiRef mask=0);
	
public:
	virtual void copy(GdiRef gdi, Color color=nullColor);
	virtual void copy(GdiRef gdi, int xd, int yd, Color color=nullColor);
	virtual void copy(GdiRef gdi, int xd, int yd, int wd, int hd, Color color=nullColor);
	virtual void copy(GdiRef gdi, int xd, int yd, int wd, int hd, int xs, int ys, int ws, int hs, Color color=nullColor);
	
};

void genTexture(GdiOpenGLRef gl, BitmapRef bitmap);
