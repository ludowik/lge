#include "System.h"
#include "Gdi.h"
#include "Gdi.OpenGL.h"

#if (_WINDOWS)
	HDC GdiOpenGL::g_openglCtx = 0;

#elif (_MAC)
	#import <UIKit/UIKit.h>

	#import <OpenGLES/EAGL.h>
	#import <OpenGLES/EAGLDrawable.h>

	#import <QuartzCore/CAEAGLLayer.h>

	EAGLContext* GdiOpenGL::g_openglCtx = 0;

#endif

unsigned int GdiOpenGL::framebuffer  = 0;
unsigned int GdiOpenGL::renderbuffer = 0;

const char* classGdiOpenGL = "Gdi.OpenGL";

GdiOpenGL::GdiOpenGL() : Gdi() {
	m_class = classGdiOpenGL;	
	m_ctx = 0;
}

GdiOpenGL::~GdiOpenGL() {
}

void GdiOpenGL::releaseOpenGL() {
	if ( g_openglCtx ) {
#if (_WINDOWS)

		HGLRC hrc = ::wglGetCurrentContext();
		::wglMakeCurrent(NULL,  NULL);
		if ( hrc )	{
			::wglDeleteContext(hrc);
		}

		HWND wnd = (HWND)System::Media::getActiveWindow();
		ReleaseDC(wnd, g_openglCtx);

#elif (_MAC)

		if ( framebuffer ) {
			OpenGL::glDeleteFramebuffersOES(1, &framebuffer);
			framebuffer = 0;
		}

		if ( renderbuffer ) {
			OpenGL::glDeleteRenderbuffersOES(1, &renderbuffer);
			renderbuffer = 0;
		}

		// Tear down context
		if ( [EAGLContext currentContext] == g_openglCtx ) {
			[EAGLContext setCurrentContext:nil];
		}

		[(EAGLContext*)g_openglCtx release];

#endif

		g_openglCtx = 0;
	}
}

bool GdiOpenGL::isValid() {
	return m_ctx ? true : false;
}

void GdiOpenGL::create(int w, int h) {
	if ( g_openglCtx == 0 ) {
#if (_WINDOWS)
	
		HWND wnd = (HWND)System::Media::getActiveWindow();
		g_openglCtx = GetDC(wnd);

		PIXELFORMATDESCRIPTOR pfd = { 
			sizeof(PIXELFORMATDESCRIPTOR), // size of this pfd  
			1,                     // version number  
			PFD_DRAW_TO_WINDOW |   // support Window
			PFD_SUPPORT_OPENGL |   // support OpenGL
			PFD_DOUBLEBUFFER,      // double buffered
			PFD_TYPE_RGBA,         // RGBA type
			32,                    // 24-bit color depth
			0, 0, 0, 0, 0, 0,      // color bits ignored
			0,                     // no alpha buffer
			0,                     // shift bit ignored
			0,                     // no accumulation buffer
			0, 0, 0, 0,            // accum bits ignored
			32,                    // 32-bit z-buffer
			0,                     // no stencil buffer
			0,                     // no auxiliary buffer
			PFD_MAIN_PLANE,        // main layer
			0,                     // reserved
			0, 0, 0                // layer masks ignored
		}; 

		// get the best available match of pixel format for the device context   
		int iPixelFormat = ChoosePixelFormat(g_openglCtx, &pfd); 

		// make that the pixel format of the device context  
		SetPixelFormat(g_openglCtx, iPixelFormat, &pfd);

		HGLRC hrc = wglCreateContext(g_openglCtx);
		wglMakeCurrent(g_openglCtx, hrc);

#elif (_MAC)
	
		g_openglCtx = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
		
		if ( g_openglCtx && [EAGLContext setCurrentContext:(EAGLContext*)g_openglCtx] ) {
			OpenGL::glGenRenderbuffersOES(1, &renderbuffer);
			OpenGL::glBindRenderbufferOES(GL_RENDERBUFFER_OES, renderbuffer);
			
			CAEAGLLayer* eaglLayer = (CAEAGLLayer*)System::Media::getActiveDC();
			
			if ( ![(EAGLContext*)g_openglCtx renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(id<EAGLDrawable>)eaglLayer] ) {
				OpenGL::glDeleteRenderbuffersOES(1, &renderbuffer);
				return;
			}
			
			OpenGL::glGenFramebuffersOES(1, &framebuffer);
			OpenGL::glBindFramebufferOES(GL_FRAMEBUFFER_OES, framebuffer);
			
			OpenGL::glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, renderbuffer);
		}
#endif
	}
					
	OpenGL::glEnable(GL_DEPTH_TEST);

	m_ctx = g_openglCtx;	
}

void GdiOpenGL::release() {
}

void GdiOpenGL::begin() {
	Gdi::begin();
	
	m_rect = System::Media::getWindowsSize();
	
	GLfloat w = m_rect.w;
	GLfloat h = m_rect.h;

#if (_WINDOWS)
	
#elif (_MAC)

	[EAGLContext setCurrentContext:(EAGLContext*)m_ctx];

	CAEAGLLayer* eaglLayer = (CAEAGLLayer*)System::Media::getActiveDC();
	
	if ( ![(EAGLContext*)m_ctx renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(id<EAGLDrawable>)eaglLayer] ) {
		OpenGL::glDeleteRenderbuffersOES(1, &renderbuffer);
		return;
	}

	OpenGL::glBindFramebufferOES(GL_FRAMEBUFFER_OES, framebuffer);

#endif
	
	int depth = 2;
	
	if ( System::Media::getOrientation() == orientationLandscape ) {
		OpenGL::glViewport(0, 0, h, w);
		
		OpenGL::glMatrixMode(GL_PROJECTION);
		OpenGL::glLoadIdentity();
		
		OpenGL::glOrtho(0, h-1, w, 0, 0, depth);
		
		OpenGL::glMatrixMode(GL_MODELVIEW);
		OpenGL::glLoadIdentity();
		
		OpenGL::glRotatef(90, 0, 0, 1);
		OpenGL::glTranslatef(0, -h, 0);
	}
	else if ( System::Media::getOrientation() == orientationPortrait ) {
		OpenGL::glViewport(0, 0, w, h);
		
		OpenGL::glMatrixMode(GL_PROJECTION);
		OpenGL::glLoadIdentity();
		
		OpenGL::glOrtho(0, w, h-1, 0, 0, depth);

		OpenGL::glMatrixMode(GL_MODELVIEW);
		OpenGL::glLoadIdentity();
	}
	else {
		OpenGL::glViewport(0, 0, w, h);
		
		OpenGL::glEnable(GL_DEPTH_TEST);
		
		const GLfloat zNear = GLfloat(0.01), zFar = GLfloat(300.0), fieldOfView = GLfloat(45.0);
		const GLfloat size = GLfloat(zNear * tan(degree2radian(fieldOfView) / 1.0));
		
		OpenGL::glMatrixMode(GL_PROJECTION); 
		OpenGL::glLoadIdentity();
		OpenGL::glFrustum(0, size*2, size*2 / (w / h), 0, zNear, zFar); 		
		OpenGL::glMatrixMode(GL_MODELVIEW);
		OpenGL::glLoadIdentity();
	}
}

void GdiOpenGL::erase(Color color) {
	OpenGL::glClearColor(rIntensity(color), gIntensity(color), bIntensity(color), 1); // aIntensity(color));
    OpenGL::glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

void GdiOpenGL::draw() {
}

void GdiOpenGL::end() {
#if (_WINDOWS)
	
	SwapBuffers(wglGetCurrentDC());
	
#elif (_MAC)
	
	// This application only creates a single color renderbuffer which is already bound at this point.
	// This call is redundant, but needed if dealing with multiple renderbuffers.
	OpenGL::glBindRenderbufferOES(GL_RENDERBUFFER_OES, renderbuffer);
	[(EAGLContext*)m_ctx presentRenderbuffer:GL_RENDERBUFFER_OES];
	
#endif
}

void GdiOpenGL::loadRes(const char* id, int w, int h) {
	assert(0);
}

void GdiOpenGL::setPen(Color color) {
}

void GdiOpenGL::setBrush(Color color, int mode) {
}

void GdiOpenGL::ball(int x, int y, int r, Color strokeColor, Color fillColor) {
	pie(x, y, r, 0, 360, strokeColor, fillColor);
}

void GdiOpenGL::pixel(int x, int y, Color color) {
	glBegin(GL_POINTS); {
		glColor(color);
		glLineWidth(m_penSize);
		glVertex(x, y);
	}
	glEnd();
}

Color GdiOpenGL::getPixel(int x, int y) {
	return black;
}

void GdiOpenGL::line(int x1, int y1, int x2, int y2, Color color) {
	glBegin(GL_LINE_STRIP); {
		glColor(color);
		glLineWidth(m_penSize);
		glVertex(x1, y1);
		glVertex(x2, y2);
	}
	glEnd();
}

void GdiOpenGL::lines(int npoints, PointRef ppoints, Color fg, int x, int y, bool close) {
	glBegin(close?GL_LINE_LOOP:GL_LINE_STRIP); {
		glColor(fg);
		glLineWidth(m_penSize);
		for ( int i = 0 ; i < npoints ; ++i ) {
			glVertex(ppoints[i].x, ppoints[i].y);
		}
	}
	glEnd();
}

void GdiOpenGL::lines(CollectionRef collection, Color color, int x, int y, double rw, double rh, bool close) {	
	if ( collection->getCount() > 0 ) {
		glBegin(close?GL_LINE_LOOP:GL_LINE_STRIP); {
			glColor(color);
			glLineWidth(m_penSize);
			
			Iterator iter = collection->getIterator();
			while ( iter.hasNext() ) {
				PointRef point = (PointRef)iter.next();
				glVertex(x+point->x*rw, y+point->y*rh);
			}
		}
		glEnd();
	}
}

void GdiOpenGL::rect(Rect* rect, Color strokeColor, Color fillColor) {
	if ( fillColor != nullColor ) {
		glBegin(GL_TRIANGLE_FAN); {
			glColor(fillColor);

			glVertex(rect->left (), rect->top());
			glVertex(rect->right(), rect->top());
			glVertex(rect->right(), rect->bottom());
			glVertex(rect->left (), rect->bottom());
		}
		glEnd();
	}

	glBegin(GL_LINE_LOOP); {
		glColor(strokeColor);
		glLineWidth(m_penSize);
		
		glVertex(rect->left (), rect->top());
		glVertex(rect->right(), rect->top());
		glVertex(rect->right(), rect->bottom());
		glVertex(rect->left (), rect->bottom());
	}
	glEnd();
}

void GdiOpenGL::ellipse(int x, int y, int w, int h, Color strokeColor, Color fillColor) {
	pie(x, y, w, 0, 360, strokeColor, fillColor);
}

void GdiOpenGL::pie(int x, int y, int r, double startAngle, double sweepAngle, Color strokeColor, Color fillColor) {
	bool fill = fillColor == nullColor ? false : true;
	
	glBegin(!fill?GL_LINE_STRIP:GL_TRIANGLE_FAN); {
		glColor(!fill?strokeColor:fillColor);
		glLineWidth(m_penSize);
		
		double dXStart, dYStart, dXCenter, dYCenter;
		
		double dResolution = degree2radian(5);
		
		double dRadius = r;
		
		double dStartAngle = degree2radian(startAngle);
		double dSweepAngle = degree2radian(sweepAngle);
		
		dXCenter = x;
		dYCenter = y;
		
		dXStart = dXCenter + dRadius * cos(dStartAngle);
		dYStart = dYCenter - dRadius * sin(dStartAngle);
		
		bool bIncreasing = dSweepAngle > 0;
		
		if ( !bIncreasing ) 	{
			dResolution = -dResolution;
		}
		
		double dAngle = 0;
		
		double dXBegin = dXStart;
		double dYBegin = dYStart;
		
		if ( fill ) {
			glVertex(x, y);
		}
		
		glVertex(dXStart, dYStart);
		
		double dXEnd = 0;
		double dYEnd = 0;
		
		while ( (bIncreasing && dAngle < dSweepAngle) || (!bIncreasing && dAngle > dSweepAngle) ) 	{
			dXEnd = dXCenter + dRadius * cos(dAngle+dStartAngle);
			dYEnd = dYCenter - dRadius * sin(dAngle+dStartAngle);
			
			glVertex(dXEnd, dYEnd);
			
			dAngle += dResolution;
			
			dXBegin = dXEnd;
			dYBegin = dYEnd;
		}
		
		dXEnd = dXCenter + dRadius * cos(dSweepAngle+dStartAngle);
		dYEnd = dYCenter - dRadius * sin(dSweepAngle+dStartAngle);
		
		glVertex(dXEnd, dYEnd);
		
		if ( fill ) {
			glVertex(x, y);
		}
	}
	glEnd();
}

void GdiOpenGL::roundrect(Rect* rect, int radius, Color strokeColor, Color fillColor, int strokeSize) {
	if ( fillColor != nullColor ) {
		glBegin(GL_TRIANGLE_FAN); {
			glColor(fillColor);
		
			glVertex(rect->left (), rect->top());
			glVertex(rect->right(), rect->top());
			glVertex(rect->right(), rect->bottom());
			glVertex(rect->left (), rect->bottom());
		}	
		glEnd();
	}

	glBegin(GL_LINE_LOOP); {
		glColor(strokeColor);
		glLineWidth(m_penSize);
		
		glVertex(rect->left (), rect->top());
		glVertex(rect->right(), rect->top());
		glVertex(rect->right(), rect->bottom());
		glVertex(rect->left (), rect->bottom());
	}	
	glEnd();
}

#define MAX_FONTSIZE  50
#define MAX_TEXTURES 256

bool g_initListCharTexture = false;
BitmapRef g_listCharTexture[MAX_FONTSIZE][MAX_TEXTURES];

void initCharTextures() {
	if ( !g_initListCharTexture ) {
		g_initListCharTexture = true;
		fromto(int, f, 0, MAX_FONTSIZE) {
			fromto(int, i, 0, MAX_TEXTURES) {
				g_listCharTexture[f][i] = 0;
			}
		}
	}
}

void freeCharTextures() {
	fromto(int, f, 0, MAX_FONTSIZE) {
		fromto(int, i, 0, MAX_TEXTURES) {
			if ( g_listCharTexture[f][i] ) {
				delete g_listCharTexture[f][i];
				g_listCharTexture[f][i] = 0;
			}
		}
	}
}

BitmapRef getCharTexture(char c, int fontSize, const char* fontName) {
	int i = (unsigned char)c;
	
	initCharTextures();
	
	BitmapRef bitmap = g_listCharTexture[fontSize][i];
	if ( bitmap == 0 ) {
		String s(c);
		
		bitmap = g_listCharTexture[fontSize][i] = new Bitmap();
		bitmap->create(fontSize, fontSize);
		bitmap->setFont(fontName, fontSize);
		
		Rect rect = bitmap->getTextSize(s.getBuf(), fontName, fontSize);
		
		bitmap->m_rect.w = rect.w;
		bitmap->m_rect.h = rect.h;
		
		bitmap->createBitmapDevice(rect.w, rect.h);

		bitmap->text(0, 0, s.getBuf(), white, fontName, fontSize);
	}
	
	return bitmap;
}

void GdiOpenGL::textInRectInit(Color fontColor, const char* fontName, int fontSize) {
}

Size GdiOpenGL::textInRectGetLen(const char* txt, int len, int fontSize, const char* fontName) {
	Size size;
	fromto(int, i, 0, len) {
		BitmapRef bitmap = getCharTexture(txt[i], fontSize, fontName);
		if ( bitmap ) {			
			size.w += bitmap->m_rect.w;
			size.h = max(size.h, bitmap->m_rect.h);
		}
	}
	return size;
}

void GdiOpenGL::drawText(int x, int y, const char* txt, int len, Color fontColor, const char* fontName, int fontSize, int fontAngle) {
	fromto(int, i, 0, len) {
		BitmapRef bitmap = getCharTexture(txt[i], fontSize, fontName);
		if ( bitmap ) {
			copy(bitmap, x, y, fontColor);			
			x += bitmap->m_rect.w;
		}
	}
}

void GdiOpenGL::textInRectFree() {
}

void GdiOpenGL::copy(GdiRef gdi, Color color) {
	copy(gdi, 0, 0, gdi->m_rect.w, gdi->m_rect.h, color);
}

void GdiOpenGL::copy(GdiRef gdi, int xd, int yd, Color color) {
	copy(gdi, xd, yd, gdi->m_rect.w, gdi->m_rect.h, color);
}

void GdiOpenGL::copy(GdiRef gdi, int xd, int yd, int wd, int hd, Color color) {	
	copy(gdi, xd, yd, wd, hd, 0, 0, 0, 0, color);
}

void GdiOpenGL::copy(GdiRef gdi, int xd, int yd, int wd, int hd, int xs, int ys, int ws, int hs, Color color) {
#if (_WINDOWS)
	OpenGL::glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
#elif (_MAC)
	OpenGL::glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
#endif
		
	BitmapRef bitmap = (BitmapRef)gdi;
	genTexture(this, bitmap);
	
	float _maxS = (float)wd / (float)bitmap->m_textureSize.w;
	float _maxT = (float)hd / (float)bitmap->m_textureSize.h;
	
	GLfloat coordinates[] = {
		0, 1,
		_maxS, 1,
		0, 1-_maxT,
		_maxS, 1-_maxT,
	};
	
	GLfloat vertices[] = {
		GLfloat(xd     ), GLfloat(yd     ),
		GLfloat(xd + wd), GLfloat(yd     ),
		GLfloat(xd     ), GLfloat(yd + hd),
		GLfloat(xd + wd), GLfloat(yd + hd),
	};
	
	OpenGL::glEnable(GL_TEXTURE_2D);
	OpenGL::glEnable(GL_BLEND);
	OpenGL::glEnable(GL_LINEAR_MIPMAP_LINEAR);
	
	OpenGL::glBindTexture(GL_TEXTURE_2D, bitmap->m_texture);
	
	OpenGL::glVertexPointer(2, GL_FLOAT, 0, vertices);
	OpenGL::glEnableClientState(GL_VERTEX_ARRAY);
	
	OpenGL::glTexCoordPointer(2, GL_FLOAT, 0, coordinates);
	OpenGL::glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	if ( color != nullColor ) {
		GLfloat rIntensity = rIntensity(color);
		GLfloat gIntensity = gIntensity(color);
		GLfloat bIntensity = bIntensity(color);
		
		GLfloat colors[] = {
			rIntensity, gIntensity, bIntensity, 1,
			rIntensity, gIntensity, bIntensity, 1,
			rIntensity, gIntensity, bIntensity, 1,
			rIntensity, gIntensity, bIntensity, 1
		};
		
		OpenGL::glColorPointer(4, GL_FLOAT, 0, colors);
		OpenGL::glEnableClientState(GL_COLOR_ARRAY);
	}
	else {
		OpenGL::glColor4f(1.0, 1.0, 1.0, 1.0);
		OpenGL::glDisableClientState(GL_COLOR_ARRAY);
	}
	
	OpenGL::glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	OpenGL::glDisable(GL_LINEAR_MIPMAP_LINEAR);
	OpenGL::glDisable(GL_TEXTURE_2D);
	OpenGL::glDisable(GL_BLEND);
	
	OpenGL::glDisableClientState(GL_TEXTURE_COORD_ARRAY);               
	OpenGL::glDisableClientState(GL_COLOR_ARRAY);
}

void GdiOpenGL::gradient(int x, int y, int w, int h, int mode, Color rgbFrom, Color rgbTo, GdiRef mask) {
	glBegin(GL_TRIANGLE_FAN); {
		Rect rct(x, y, w, h);
		RectRef rect(&rct); 
		
		glLineWidth(m_penSize);

		switch ( mode ) {
			case eHorizontal:
			{
				glColor(rgbFrom);
				glVertex(rect->right(), rect->top());
				glVertex(rect->right(), rect->bottom());
				
				glColor(rgbTo);
				glVertex(rect->left (), rect->bottom());				
				glVertex(rect->left (), rect->top());
				break;
			}
			default:
			case eDiagonal:
			case eVertical:
			{
				glColor(rgbFrom);
				glVertex(rect->left (), rect->top());
				glVertex(rect->right(), rect->top());
				
				glColor(rgbTo);
				glVertex(rect->right(), rect->bottom());
				glVertex(rect->left (), rect->bottom());				
				break;
			}
		}
	}
	glEnd();
}

void genTexture(GdiOpenGLRef gl, BitmapRef bitmap) {
	if ( bitmap->m_texture == 0 ) {
		int w = bitmap->m_textureSize.w = adjustSize(bitmap->m_rect.w);
		int h = bitmap->m_textureSize.h = adjustSize(bitmap->m_rect.h);

		GdiWindows bitmapData;
		bitmapData.createBitmapDevice(w, h, true);
		
		bitmapData.copy(bitmap, 0, 0, bitmap->m_rect.w, bitmap->m_rect.h);				

#if (_WINDOWS)
#define GL_BGRA 0x80E1
#define GL_FORMAT GL_BGRA
		bitmapData.m_data = (byte*)malloc(w*h*4);

		BITMAPINFO bmi;
		ZeroMemory(&bmi, sizeof(bmi));
		bmi.bmiHeader.biSize        = sizeof(BITMAPINFOHEADER);
		bmi.bmiHeader.biWidth       = w;
		bmi.bmiHeader.biHeight      = h;
		bmi.bmiHeader.biBitCount    = 32;
		bmi.bmiHeader.biPlanes      = 1;
		bmi.bmiHeader.biCompression = BI_RGB;
		bmi.bmiHeader.biSizeImage   = w*h*4;
		
		GetDIBits(bitmapData.m_ctx,
				  bitmapData.m_bitmap,
				  0,
				  bmi.bmiHeader.biHeight,
				  bitmapData.m_data, &bmi,
				  DIB_RGB_COLORS);

		byte* data = (byte*)bitmapData.m_data;

		int i = 0;
		for ( int y = h-1 ; y > 0 ; --y ) {
			for ( int x = 0 ; x < w ; ++x ) {
				byte* pixel = (byte*)(&data[i]);

				if ( x < bitmap->m_rect.w && y < bitmap->m_rect.h  ) {
					if ( pixel[0] || pixel[1] || pixel[2] ) {
						pixel[3] = 255; // (byte)max(((int)pixel[0]+(int)pixel[1]+(int)pixel[2])/3, 255);
					} else {
						pixel[3] = 0;
					}
				}
				else {
					pixel[0] = 0;
					pixel[1] = 0;
					pixel[2] = 0;
					pixel[3] = 0;
				}

				i += 4;
			}
		}

#elif (_MAC)
#define GL_FORMAT GL_RGBA
		byte* data = (byte*)CGBitmapContextGetData(bitmapData.m_ctx);
		
#endif
#define GL_UNSIGNED_INT_8_8_8_8_REV 0x8367

		if ( data ) {
			OpenGL::glGenTextures(1, &bitmap->m_texture);
			OpenGL::glBindTexture(GL_TEXTURE_2D, bitmap->m_texture);
			
			OpenGL::glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
			
			OpenGL::glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, w, h, 0, GL_FORMAT, GL_UNSIGNED_INT_8_8_8_8_REV, data);
		}
	}
}
