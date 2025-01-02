#include "System.h"
#include "Gdi.Windows.h"

#include "CardGame.Cards.h"

NSString* nst(const char* s);

Rect cgRect2rect(CGRect& cgRect) {
	static Rect rect;
	
	rect.x = cgRect.origin.x;
	rect.y = cgRect.origin.y;
	
	rect.w = cgRect.size.width;
	rect.h = cgRect.size.height;
	
	return rect;
}

inline void rect2cgRect(Rect& rect, CGRect& cgRect) {
	cgRect.origin.x = rect.x;
	cgRect.origin.y = rect.y;
	
	cgRect.size.width  = rect.w;
	cgRect.size.height = rect.h;
}

const char* classGdiWindows = "Gdi.Windows";

GdiWindows::GdiWindows() : Gdi() {
	m_class = classGdiWindows;

	m_ctx = 0;
	m_layer = 0;
	m_image = 0;
	m_data = 0;
}

GdiWindows::~GdiWindows() {
	release();
}

bool GdiWindows::isValid() {
	return m_ctx ? true : false;
}

void GdiWindows::initContext(bool antialias, int interpolation) {
	CGContextSetShouldAntialias(m_ctx, antialias);
	
	CGContextSetShouldSmoothFonts(m_ctx, false);
	
	CGContextSetInterpolationQuality(m_ctx, (CGInterpolationQuality)interpolation);
	
	CGContextSetFlatness(m_ctx, 1);
	
	CGContextSetLineCap(m_ctx, kCGLineCapButt);
	CGContextSetLineJoin(m_ctx, kCGLineJoinMiter);
	
	CGContextSetRenderingIntent(m_ctx, kCGRenderingIntentDefault);
	
	erase(transparentColor);
}

void GdiWindows::initWithCurrentContext() {
	m_rect = System::Media::getWindowsSize();
	
	m_ctx = UIGraphicsGetCurrentContext();
	
	initContext(true, kCGInterpolationNone);
}

void GdiWindows::create(int w, int h) {
	release();
	
	m_rect.w = w;
	m_rect.h = h;
	
	if ( 0 ) { // System::Media::getGdiMode() == gdiModeGdi ) {
		createBitmapDevice(w, h);
	}
	
	if ( m_ctx == 0 ) {
		CGSize size = {w, h};
		
		m_layer =(CGLayerRef)CGLayerCreateWithContext(UIGraphicsGetCurrentContext(), size, 0);
		m_ctx = CGLayerGetContext((CGLayerRef)m_layer);
	}
	
	initContext(true, kCGInterpolationHigh);
}

int kCGImage = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;

void GdiWindows::createBitmapDevice(int w, int h, bool allocData) {
	release();
	
	m_rect.w = w;
	m_rect.h = h;
	
	int bitmapBytesPerRow = 0;
	int bitmapByteCount   = 0;
	
	if ( allocData || System::Media::getVersion() < 4.0 ) {
		bitmapBytesPerRow = (4 * w);
		bitmapByteCount   = (bitmapBytesPerRow * h);
		
		m_data = malloc(bitmapByteCount);
	}
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); {
		m_ctx = CGBitmapContextCreate(m_data, w, h, 8, bitmapBytesPerRow, colorSpace, kCGImage);
	}
	CGColorSpaceRelease(colorSpace);
	
	initContext(true, kCGInterpolationHigh);
}

void GdiWindows::createGrayDevice(int w, int h, bool allocData) {
	release();

	m_rect.w = w;
	m_rect.h = h;
	
	int bitmapBytesPerRow = 0;
	int bitmapByteCount   = 0;
	
	if ( allocData || System::Media::getVersion() < 4.0 ) {
		bitmapBytesPerRow = (1 * w);
		bitmapByteCount   = (bitmapBytesPerRow * h);
		
		m_data = malloc(bitmapByteCount);
	}
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray(); {
		m_ctx = CGBitmapContextCreate(m_data, w, h, 8, bitmapBytesPerRow, colorSpace, kCGImageAlphaNone);
	}
	CGColorSpaceRelease(colorSpace);

	initContext(true, kCGInterpolationHigh);
}

void GdiWindows::release() {
	if ( m_layer ) {
		CGLayerRelease((CGLayerRef)m_layer);
	}
	else if ( View::g_gdi != this && m_ctx ) {
		CGContextRelease(m_ctx);
	}
	
		
	if ( m_data ) {
		free(m_data);
	}
		
	if ( m_image ) {
		CGImageRelease(m_image);
	}

	m_ctx = 0;
	m_layer = 0;
	m_image = 0;
	m_data = 0;
}

void GdiWindows::begin() {
	Gdi::begin();
}

void GdiWindows::end() {
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	if ( m_ctx && m_ctx != ctx ) {
		static CGPoint at = {0,0};
		CGContextDrawLayerAtPoint(ctx, at, (CGLayerRef)m_layer);
	}
}

void GdiWindows::erase(Color color) {
	CGRect cgRect;
	rect2cgRect(m_rect, cgRect);
	
	if ( color == transparentColor ) {
		CGContextClearRect(m_ctx, cgRect);
	}
	else {
		setBrush(color);
		CGContextFillRect(m_ctx, cgRect);
	}
}

void GdiWindows::loadRes(const char* id, int w, int h) {
	NSString* s = nst(id);
		
	UIImage* image = [UIImage imageNamed:s];
	if ( image ) {
		CGSize size = [image size];

		if ( w )
			size.width = w;
		if ( h )
			size.height = h;
		
		createBitmapDevice(size.width, size.height);
		
		CGRect rect = {0, 0, size.width, size.height};
		
		UIGraphicsPushContext(m_ctx); {
			[image drawInRect:rect];
		}
		UIGraphicsPopContext();
		
		[image release];
	}
}

void GdiWindows::setPen(Color color) {
	if ( color == nullColor || color == defaultColor ) {
		color = white;
	}
	
	CGContextSetRGBStrokeColor(m_ctx,
							   rIntensity(color),
							   gIntensity(color),
							   bIntensity(color),
							   aIntensity(color));
	
	CGContextSetLineWidth(m_ctx, m_penSize);
}

void GdiWindows::setBrush(Color color, int mode) {
	if ( color == nullColor || color == defaultColor ) {
		color = transparentColor;
	}
	
	CGContextSetRGBFillColor(m_ctx,
							 rIntensity(color),
							 gIntensity(color),
							 bIntensity(color),
							 aIntensity(color));
}

// Returns an appropriate starting point for the linear gradient
CGPoint demoLGStart(CGRect bounds) {
	return CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height * 0.25);
}

// Returns an appropriate ending point for the linear gradient
CGPoint demoLGEnd(CGRect bounds) {
	return CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height * 0.75);
}

// Returns the center point for a radial gradient
CGPoint demoRGCenter(CGRect bounds) {
	return CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
}

// Returns an appropriate inner radius for the radial gradient
CGFloat demoRGInnerRadius(CGRect bounds) {
	CGFloat r = bounds.size.width < bounds.size.height ? bounds.size.width : bounds.size.height;
	return r * 0.05;
}

// Returns an appropriate outer radius for the radial gradient
CGFloat demoRGOuterRadius(CGRect bounds) {
	CGFloat r = bounds.size.width < bounds.size.height ? bounds.size.width : bounds.size.height;
	return r * 0.65;
}

void GdiWindows::ball(int x, int y, int r, Color strokeColor, Color fillColor) {
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGFloat colors[] = {
		rIntensity(fillColor  ), gIntensity(fillColor  ), bIntensity(fillColor  ), 1.00,
		rIntensity(strokeColor), gIntensity(strokeColor), bIntensity(strokeColor), 1.00
	};
	
	CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
	CGColorSpaceRelease(rgb);
	
	CGRect rect = CGRectMake(x-r, y-r, r*2, r*2);
	
	CGContextSaveGState(m_ctx);
	
	Bitmap mask;
	mask.create(m_rect.w, m_rect.h);
	mask.circle(x, y, r, black, black);
	
	CGRect cgRect;
	rect2cgRect(m_rect, cgRect);
	
	CGImageRef image = CGBitmapContextCreateImage(mask.m_ctx);
	CGContextClipToMask(m_ctx, cgRect, image);
	
	CGPoint start = demoRGCenter(rect);
	start.x -= 1;
	start.y -= 1;
	CGPoint end = demoRGCenter(rect);
	CGFloat startRadius = demoRGInnerRadius(rect);
	CGFloat endRadius = demoRGOuterRadius(rect);
	CGContextDrawRadialGradient(m_ctx, gradient, start, startRadius, end, endRadius, kCGGradientDrawsBeforeStartLocation);
	
	circle(x, y, r, strokeColor, fillColor);
	
	CGContextRestoreGState(m_ctx);
	CGContextFlush(m_ctx);
	
    CGGradientRelease(gradient);	
}

void GdiWindows::pixel(int x, int y, Color color) {
	static CGRect cgRect = {{0,0},{1,1}};
	cgRect.origin = CGPointMake(x, y); 
	
	setBrush(color);
	CGContextFillRect(m_ctx, cgRect);
}

Color GdiWindows::getPixel(int x, int y) {
	// TODO
	return 0;
}

void GdiWindows::line(int x, int y, int x2, int y2, Color color) {
	setPen(color);
	
	CGContextBeginPath(m_ctx); {
		CGContextMoveToPoint(m_ctx, x, y);
		CGContextAddLineToPoint(m_ctx, x2, y2);
	}
	CGContextStrokePath(m_ctx);
}

void GdiWindows::lines(int npoints, PointRef ppoints, Color fg, int x, int y, bool close) {	
	setPen(fg);
	
	CGContextBeginPath(m_ctx); {
		CGContextMoveToPoint(m_ctx, x+ppoints[0].x, y+ppoints[0].y);
		
		int i;
		for ( i = 1 ; i < npoints ; ++i ) {
			CGContextAddLineToPoint(m_ctx, x+ppoints[i].x, y+ppoints[i].y);
		}
		
		if ( close ) {
			CGContextAddLineToPoint(m_ctx, ppoints[0].x, ppoints[0].y);
		}
	}
	CGContextStrokePath(m_ctx);
}

void GdiWindows::lines(CollectionRef collection, Color fg, int x, int y, double rw, double rh, bool close) {	
	if ( collection->getCount() > 0 ) {
		setPen(fg);
		
		CGContextBeginPath(m_ctx); {
			Iterator iter = collection->getIterator();
			
			PointRef first = (PointRef)iter.next();
			CGContextMoveToPoint(m_ctx, x+((double)first->x*rw), y+((double)first->y*rh));
			
			while ( iter.hasNext() ) {
				PointRef point = (PointRef)iter.next();
				CGContextAddLineToPoint(m_ctx, x+((double)point->x*rw), y+((double)point->y*rh));
			}
			
			if ( close ) {
				CGContextMoveToPoint(m_ctx, x+((double)first->x*rw), y+((double)first->y*rh));
			}
		}
		CGContextStrokePath(m_ctx);
	}
}

void GdiWindows::rect(Rect* rect, Color strokeColor, Color fillColor) {
	CGRect cgRect;
	rect2cgRect(*rect, cgRect);
	
	setPen(strokeColor);

	if ( fillColor != nullColor ) {
		setBrush(fillColor);
		CGContextFillRect(m_ctx, cgRect);
	}
	else {
        CGContextStrokeRect(m_ctx, cgRect);
    }
}

void GdiWindows::ellipse(int x, int y, int w, int h, Color strokeColor, Color fillColor) {
	setPen(strokeColor);
	setBrush(fillColor);
	
	CGRect cgRect = {x, y, w, h};
	
	if ( fillColor != nullColor ) {
		CGContextFillEllipseInRect(m_ctx, cgRect);
	}

	CGContextStrokeEllipseInRect(m_ctx, cgRect);
}

void GdiWindows::pie(int x, int y, int r, double ad, double aa, Color strokeColor, Color fillColor) {
}

void GdiWindows::roundrect(Rect* rect, int radius, Color strokeColor, Color fillColor, int strokeSize) {
	CGContextSetLineWidth(m_ctx, strokeSize);
	
	// NOTE: At this point you may want to verify that your radius is no more than half
	// the width and height of your rectangle, as this technique degenerates for those cases.
	
	// In order to draw a rounded rectangle, we will take advantage of the fact that
	// CGContextAddArcToPoint will draw straight lines past the start and end of the arc
	// in order to create the path from the current position and the destination position.
	
	// In order to create the 4 arcs correctly, we need to know the min, mid and max positions
	// on the x and y lengths of the given rectangle.
	CGFloat minx = rect->x;
	CGFloat midx = rect->x+rect->w/2;
	CGFloat maxx = rect->x+rect->w;
	
	CGFloat miny = rect->y;
	CGFloat midy = rect->y+rect->h/2;
	CGFloat maxy = rect->y+rect->h;
	
	// Next, we will go around the rectangle in the order given by the figure below.
	//       minx    midx    maxx
	// miny    2       3       4
	// midy   1 9              5
	// maxy    8       7       6
	// Which gives us a coincident start and end point, which is incidental to this technique, but still doesn't
	// form a closed path, so we still need to close the path to connect the ends correctly.
	// Thus we start by moving to point 1, then adding arcs through each pair of points that follows.
	// You could use a similar tecgnique to create any shape with rounded corners.
	
	// Start at 1
	CGContextMoveToPoint(m_ctx, minx, midy);
	// add an arc through 2 to 3
	CGContextAddArcToPoint(m_ctx, minx, miny, midx, miny, radius);
	// add an arc through 4 to 5
	CGContextAddArcToPoint(m_ctx, maxx, miny, maxx, midy, radius);
	// add an arc through 6 to 7
	CGContextAddArcToPoint(m_ctx, maxx, maxy, midx, maxy, radius);
	// add an arc through 8 to 9
	CGContextAddArcToPoint(m_ctx, minx, maxy, minx, midy, radius);
	// Close the path
	CGContextClosePath(m_ctx);
	
	// Fill & stroke the path
	if ( fillColor == nullColor ) {
		setPen(strokeColor);
		CGContextDrawPath(m_ctx, kCGPathStroke);
	}
	else {
		setBrush(fillColor);
		CGContextDrawPath(m_ctx, kCGPathFillStroke);
	}
}

void GdiWindows::textInRectInit(Color fontColor, const char* fontName, int fontSize) {
	CGContextSaveGState(m_ctx);
	
	CGContextSelectFont(m_ctx, fontName, fontSize, kCGEncodingMacRoman);
	
	setBrush(fontColor);
	
	CGAffineTransform matrix = CGAffineTransformScale(CGAffineTransformIdentity, 1.f, -1.f);
	//	matrix = CGAffineTransformRotate(matrix, degree2radian(fontAngle));
	matrix = CGAffineTransformRotate(matrix, degree2radian(0));
	
    CGContextSetTextMatrix(m_ctx, matrix);
}

Size GdiWindows::textInRectGetLen(const char* txt, int len, int fontSize, const char* fontName) {
	Size size;
	
	CGContextSetTextDrawingMode(m_ctx, kCGTextInvisible);
	CGContextShowTextAtPoint(m_ctx, 0, 0, txt, len);
		
	CGPoint textPosition = CGContextGetTextPosition(m_ctx);
	size.w = textPosition.x;
	size.h = textPosition.y;

	return size;
}

void GdiWindows::drawText(int x, int y, const char* txt, int len, Color fontColor, const char* fontName, int fontSize, int fontAngle) {
	y += fontSize - 3;

	CGContextSetTextDrawingMode(m_ctx, kCGTextFill);
	CGContextShowTextAtPoint(m_ctx, x, y, txt, len);
}

void GdiWindows::textInRectFree() {
	CGContextRestoreGState(m_ctx);
}

void GdiWindows::copy(GdiRef _gdi, Color color) {
	GdiWindowsRef gdi = (GdiWindowsRef)_gdi;
	
	if ( gdi->m_layer ) {
		CGPoint at = {0,0};
		CGContextDrawLayerAtPoint(m_ctx, at, gdi->m_layer);
	}
	else {
		CGRect at = {0,0,gdi->m_rect.w,gdi->m_rect.h};
		CGImageRef img = CGBitmapContextCreateImage(gdi->m_ctx);
		CGContextDrawImage(m_ctx, at, img);
		CGImageRelease(img);
	}
}

void GdiWindows::copy(GdiRef _gdi, int x, int y, Color color) {
	GdiWindowsRef gdi = (GdiWindowsRef)_gdi;
	
	if ( gdi->m_layer ) {
		CGPoint at = {x,y};
		CGContextDrawLayerAtPoint(m_ctx, at, gdi->m_layer);
	}
	else {
		CGRect at = {x,y,gdi->m_rect.w,gdi->m_rect.h};
		if ( gdi->m_image == 0 ) {
			gdi->m_image = CGBitmapContextCreateImage(gdi->m_ctx);
		}
		
		if ( gdi->m_image ) {
			CGContextDrawImage(m_ctx, at, gdi->m_image);
		}
		else {
			CGImageRef img = CGBitmapContextCreateImage(gdi->m_ctx);
			CGContextDrawImage(m_ctx, at, img);
			CGImageRelease(img);
		}
	}
}

void GdiWindows::copy(GdiRef _gdi, int x, int y, int w, int h, Color color) {
	GdiWindowsRef gdi = (GdiWindowsRef)_gdi;
	
	CGRect at = {x,y,w,h};

	if ( gdi->m_layer ) {
		CGContextDrawLayerInRect(m_ctx, at, (CGLayerRef)((GdiWindowsRef)gdi)->m_layer);
	}
	else {
		CGImageRef img = CGBitmapContextCreateImage(gdi->m_ctx);
		CGContextDrawImage(m_ctx, at, img);
		CGImageRelease(img);
	}
}

void GdiWindows::copy(GdiRef _gdi, int xd, int yd, int wd, int hd, int xs, int ys, int ws, int hs, Color color) {
	GdiWindowsRef gdi = (GdiWindowsRef)_gdi;
	
	CGRect at = {xd,yd,wd,hd};
	CGRect from = {xs,ys,ws,hs};

	if ( gdi->m_layer ) {
		CGLayerRef layer = gdi->m_layer;
		
		// Create the bitmap context
		CGContextRef bitmapContext = NULL;
		
		// Get layer size
		CGSize size = CGLayerGetSize(layer);
		
		// Allocate memory for image data. This is the destination in memory
		// where any drawing to the bitmap context will be rendered
		void* bitmapData = 0;
		
		// Declare the number of bytes per row
		// Each pixel in the bitmap in this example is represented by 4 bytes; 8 bits each of red, green, blue, and alpha
		int bitmapBytesPerRow = 0;
		int bitmapByteCount   = 0;
		
		if ( System::Media::getVersion() < 4.0 ) {
			// Allocate memory for image data
			bitmapBytesPerRow = (4 * size.width);
			bitmapByteCount   = (bitmapBytesPerRow * size.height);
			
			bitmapData = malloc(bitmapByteCount);
		}
				
		// Create the bitmap context. We want pre-multiplied ARGB, 8-bits
		// per component. Regardless of what the source image format is (CMYK, Grayscale, and so on)
		// it will be converted over to the format specified here by CGBitmapContextCreate.
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); {
			bitmapContext = CGBitmapContextCreate(bitmapData, size.width, size.height, 8, bitmapBytesPerRow, colorSpace, kCGImage);
		}
		CGColorSpaceRelease(colorSpace);
		
		if ( bitmapContext == NULL ) {
			return;
		}
		
//		CGContextScaleCTM(bitmapContext, 1, -1);
//		CGContextTranslateCTM(bitmapContext, 0, -size.height);
		
		// Draw the image to the bitmap context. Once we draw, the memory
		// allocated for the context for rendering will then contain the raw image data in the specified color space.
		CGContextDrawLayerAtPoint(bitmapContext, CGPointZero, layer);
		
		CGImageRef img = CGBitmapContextCreateImage(bitmapContext);
		CGImageRef part = CGImageCreateWithImageInRect(img, from);
		
		CGContextDrawImage(m_ctx, at, part);
		
		CGImageRelease(img);
		CGImageRelease(part);
		
		CGContextRelease(bitmapContext);
		
		free(bitmapData);
	}
	else {
		CGImageRef img = CGBitmapContextCreateImage(gdi->m_ctx);
		CGImageRef part = CGImageCreateWithImageInRect(img, from);
		CGContextDrawImage(m_ctx, at, part);
		CGImageRelease(img);
		CGImageRelease(part);
	}
}

void GdiWindows::gradient(int x, int y, int w, int h, int mode, Color rgbFrom, Color rgbTo, GdiRef mask) {
	CGContextSaveGState(m_ctx);
	
	CGRect rect = {x,y,w,h};
	if ( mask ) {
		CGImageRef image = CGBitmapContextCreateImage(((GdiWindowsRef)mask)->m_ctx);
		CGContextClipToMask(m_ctx, rect, (CGImageRef)image);
		CGImageRelease(image);
	}
	else {
		CGContextClipToRect(m_ctx, rect);
	}
	
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGFloat colors[] = {
		rIntensity(rgbFrom), gIntensity(rgbFrom), bIntensity(rgbFrom), 1.00,
		rIntensity(rgbTo  ), gIntensity(rgbTo  ), bIntensity(rgbTo  ), 1.00
	};
	
	CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, 0, sizeof(colors)/(sizeof(colors[0])*4));
	CGColorSpaceRelease(rgb);

	CGPoint start = {x, y};
	
	CGPoint end;
	switch ( mode ) {
		case eDiagonal:
			end = CGPointMake(x+w, y+h);
			break;
		case eHorizontal:
			end = CGPointMake(x+w, y);
			break;
		case eVertical:
			end = CGPointMake(x, y+h);
			break;
		default:
			assert(0);
			break;
	}

	CGContextDrawLinearGradient(m_ctx, gradient, start, end, kCGGradientDrawsBeforeStartLocation);
	CGGradientRelease(gradient);
	
	CGContextRestoreGState(m_ctx);
}
