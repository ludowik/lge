#include "System.h"
#include "Math.h"
#include "Gdi.Proc.h"

#define GDI_FACTOR 10000

Points::~Points()
{
	delete[] pts;
}

global::global()
{
	m_i = 0;
}

PointRef global::createPoints(int n)
{
	Points* points;
	if ( m_i >= m_lst.getCount() )
	{
		points = new Points;
		
		points->npts = 2048;
		points->pts = new Point[points->npts];
		
		m_lst.add(points);
	}
	else
	{
		points = (Points*)m_lst.getLast();
	}
	
	if ( n > points->npts )
	{
		points->npts = n;
		delete[] points->pts;
		points->pts = new Point[points->npts];
	}
	
	m_i++;
	
	return points->pts;
}

void global::freePoints(PointRef pts, int n)
{
	m_i--;
	Points* points = (Points*)m_lst.getLast();
	assert(n<=points->npts);
}

PointRef getPie(PointRef rPts,
              int& nPts,
              int x,
              int y,
              int r,
              double ad,
              double aa)
{
	if ( rPts == NULL )
	{
		int iPts = mulby2( 4*r ) + 100;
		rPts = global::getInstance().createPoints(iPts);
		nPts = 0;
	}
	
	if ( rPts && r ) {
		int lPrevXoffset = 10000;
		int lPrevYoffset = 10000;
		
		int lXoffset = 0;
		int lYoffset = 0;
		
		int da = Math::Round ( ( aa - ad ) / r );
		da = max (da, 1);
		
		for ( double a = ad ; a <= aa ; a += da ) {
			double dx = cos(a);
			double dy = sin(a);
			
			lXoffset = Math::Round( dx * (double)r );
			lYoffset = Math::Round( dy * (double)r );
			
			if ( lXoffset != lPrevXoffset ||
 				 lYoffset != lPrevYoffset ) {
				rPts[nPts].x = x + lXoffset;
				rPts[nPts].y = y + lYoffset;
				
				nPts++;
			}
			
			lPrevXoffset = lXoffset;
			lPrevYoffset = lYoffset;
		}
	}
	
	return rPts;
}

PointRef getRect(PointRef rPts,
               int& nPts,
               int x,
               int y,
               int w,
               int h,
               Point rRound)
{
	int at = rRound.x;
	int ab = rRound.y;
	
	int l = x;
	int r = x+w;
	
	int t = y;
	int b = t+h;
	
	if ( rPts == NULL )
	{
		int iPts = mulby2( w + h ) + 100;
		rPts = global::getInstance().createPoints(iPts);
		nPts = 0;
	}
	
	if ( rPts )
	{  
		rPts[nPts].x = r-at;
		rPts[nPts].y = t;
		
		nPts++;
		
		getPie(rPts, nPts, r-at, t+at, at, 270, 360);
		
		rPts[nPts].x = r;
		rPts[nPts].y = t+at;
		
		nPts++;
		
		rPts[nPts].x = r;
		rPts[nPts].y = b-ab;
		
		nPts++;
		
		getPie(rPts, nPts, r-ab, b-ab, ab, 0, 90);
		
		rPts[nPts].x = r-ab;
		rPts[nPts].y = b;
		
		nPts++;
		
		rPts[nPts].x = l+ab;
		rPts[nPts].y = b;
		
		nPts++;
		
		getPie(rPts, nPts, l+ab, b-ab, ab, 90, 180);
		
		rPts[nPts].x = l;
		rPts[nPts].y = b-ab;
		
		nPts++;
		
		rPts[nPts].x = l;
		rPts[nPts].y = t+at;
		
		nPts++;
		
		getPie(rPts, nPts, l+at, t+at, at, 180, 270);
		
		rPts[nPts].x = l+at;
		rPts[nPts].y = t;
		
		nPts++;
		
		rPts[nPts].x = r-at;
		rPts[nPts].y = t;
		
		nPts++;
	}
	
	return rPts;
}

#define m_pixel(_x,_y) \
rPts[nPts].x = x+r+_x;\
rPts[nPts].y = y+r+_y;\
nPts++;

PointRef getCircle(PointRef rPts,
                 int& nPts,
                 int x,
                 int y,
                 int w,
                 int h,
                 Point rRound)
{
	if ( rPts == NULL )
	{
		int iPts = mulby2( w + h ) + 100;
		rPts = global::getInstance().createPoints(iPts);
		nPts = 0;
	}
	
	if ( rPts )
	{  
		// Algo Bresenham
		int r = divby2(w) - 1;
		
		int xc = 0;
		int yc = r;
		
		int d = 1 - r;
		
		m_pixel( xc, yc);
		m_pixel(-xc, yc);
		m_pixel( xc,-yc);
		m_pixel(-xc,-yc);
		m_pixel( yc, xc);
		m_pixel(-yc, xc);
		m_pixel( yc,-xc);
		m_pixel(-yc,-xc);
		
		while ( yc > xc )
		{
			if ( d < 0 )
				d += 2 * xc + 3;
			else
			{
				d += 2 * (xc - yc) + 5;
				yc--;
			}
			
			xc++;
			
			m_pixel( yc, xc);
			m_pixel(-yc, xc);
			m_pixel( yc,-xc);
			m_pixel(-yc,-xc);
			m_pixel( xc, yc);
			m_pixel( xc,-yc);
			m_pixel(-xc, yc);
			m_pixel(-xc,-yc);
		}
	}
	
	return rPts;
}

void getLine0(PointRef rPts,
              int& nPts,
              int x1,
              int y1,
              int x2,
              int y2,
              int nPrecision)
{
	int dx = x1 - x2;
	int dy = y1 - y2;
	
	int adx = abs(dx);
	int ady = abs(dy);
	
	int ix = ( dx < 0 ) ? 1 : -1;
	int iy = ( dy < 0 ) ? 1 : -1;
	
	int iPrecision = nPrecision;
	
	if ( adx > ady && dx != 0 )
	{
		int py = GDI_FACTOR * ady / adx;
		int y = 0;
		
		for ( ; adx > 0 ; x1 += ix , y += py, adx -= 1 )
		{
			if ( y > GDI_FACTOR )
			{
				y -= GDI_FACTOR;
				y1 += iy;
			}
			iPrecision--;
			if ( !iPrecision )
			{
				rPts[nPts].x = x1;
				rPts[nPts].y = y1;
				
				nPts++;
				
				iPrecision = nPrecision;
			}
		}
	}
	else if ( dy != 0 )
	{
		int px = GDI_FACTOR * adx / ady;
		int x = 0;
		
		for ( ; ady > 0 ; y1 += iy , x += px , ady -= 1 )
		{
			if ( x > GDI_FACTOR )
			{
				x -= GDI_FACTOR;
				x1 += ix;
			}
			iPrecision--;
			if ( !iPrecision )
			{
				rPts[nPts].x = x1;
				rPts[nPts].y = y1;
				
				nPts++;
				
				iPrecision = nPrecision;
			}
		}
	}
	
	rPts[nPts].x = x2;
	rPts[nPts].y = y2;
	
	nPts++;
}

void getLine1(PointRef rPts,
              int& nPts,
              int x1,
              int y1,
              int x2,
              int y2,
              int nPrecision)
{
	int dx = x1 - x2;
	int dy = y1 - y2;
	
	int adx = abs(dx);
	int ady = abs(dy);
	
	int ix = ( dx < 0 ) ? 1 : -1;
	int iy = ( dy < 0 ) ? 1 : -1;
	
	int iPrecision = nPrecision;
	
	if ( adx > ady && dx != 0 )
	{
		register double y = y1;        
		register double py = ( (double)ady / (double)adx ) * iy;
		
		for ( int i = x1 ; adx > 0 ; i += ix , y += py , adx -= 1 )
		{
			iPrecision--;
			if ( !iPrecision )
			{
				rPts[nPts++].x = (int)i;
				rPts[nPts++].y = (int)y;
				
				nPts++;
				
				iPrecision = nPrecision;
			}
		}
	}
	else if ( dy != 0 )
	{
		register double x = x1;        
		register double px = ( (double)adx / (double)ady ) * ix;
		
		for ( int i = y1 ; ady > 0 ; i += iy , x += px , ady -= 1 )
		{
			iPrecision--;
			if ( !iPrecision )
			{
				rPts[nPts++].x = (int)x;
				rPts[nPts++].y = (int)i;
				
				nPts++;
				
				iPrecision = nPrecision;
			}
		}
	}
	
	rPts[nPts].x = x2;
	rPts[nPts].y = y2;
	
	nPts++;
}

void getLine2(PointRef rPts,
              int& nPts,
              int x1,
              int y1,
              int x2,
              int y2,
              int nPrecision)
{
	int dx = x1 - x2;
	int dy = y1 - y2;
	
	int adx = abs(dx);
	int ady = abs(dy);
	
	Point rPoint[3];
	
	rPoint[0].x = x1;
	rPoint[0].y = y1;
	
	rPoint[1].x = x2,
	rPoint[1].y = y2;
	
	rPoint[2].x = x2 - dx;
	rPoint[2].y = y2 - dy;
	
	int oldX = 0;
	int oldY = 0;
	
	int nb = 3;
	
	for ( int i = 0 ; i < nb ; i += nb )
	{
		int max = adx + ady;
		
		for ( double j = 0 ; j <= max ; ++j )
		{
			double u = j / max;
			
			double x = 0;
			double y = 0;
			
			for ( int k = 0 ; k <= nb ; ++k )
			{
				double b = Math::Blend(k, nb, u);
				
				PointRef pPoint = &rPoint[(k+i+nb)%nb];
				
				x += pPoint->x * b;
				y += pPoint->y * b;
			}
			
			int newX = (int)x;
			int newY = (int)y;
			
			if ( newX!=oldX || newY!=oldY )
			{
				rPts[nPts].x = newX;
				rPts[nPts].y = newY;
				
				nPts++;
			}
			
			oldX = newX;
			oldY = newY;
		}
	}
}

void getLine3(PointRef rPts,
              int& nPts,
              int x1,
              int y1,
              int x2,
              int y2,
              int nPrecision)
{
	int dx = x1 - x2;
	int dy = y1 - y2;
	
	int adx = abs(dx);
	int ady = abs(dy);
	
	if ( adx <= nPrecision && ady <= nPrecision )
	{
		return;
	}
	
	int x3 = divby2( x2 + x1 );
	int y3 = divby2( y2 + y1 );
	
	rPts[nPts].x = x3;
	rPts[nPts].y = y3;
	
	nPts++;
	
	getLine3(rPts, nPts, x1, y1, x3, y3, nPrecision);
	getLine3(rPts, nPts, x3, y3, x2, y2, nPrecision);
}

void interpolation(PointRef rPts,
                   int& nPts,
                   int x1,
                   int y1,
                   int x2,
                   int y2,
                   int nPrecision) {
	int dx = x1 - x2;
	int dy = y1 - y2;
	
	int nb = (int)sqrt(dx*dx + dy*dy);
	
	rPts[nPts].x = x1;
	rPts[nPts].y = y1;
	
	nPts++;
	
	double pas = 1. / nb;
	
	for ( double k = 0 ; k <= 1. ; k += pas ) {
		rPts[nPts].x = Math::Round( ( 1. - k ) * x1 + k * x2 );
		rPts[nPts].y = Math::Round( ( 1. - k ) * y1 + k * y2 );
		
		nPts++;
	}
	
	rPts[nPts].x = x2;
	rPts[nPts].y = y2;
	
	nPts++;
}

PointRef getLine(PointRef rPts,
               int& nPts,
               int x1,
               int y1,
               int x2,
               int y2,
               int nPrecision,
               int iMethod)
{
	int dx = x1 - x2;
	int dy = y1 - y2;
	
	int adx = abs(dx);
	int ady = abs(dy);
	
	if ( adx + ady == 0 )
	{
		return NULL;
	}
	
	if ( rPts == NULL )
	{
		int iPts = (int) ( sqrt( adx*adx + ady*ady ) ) + 100;
		rPts = global::getInstance().createPoints(iPts);
		nPts = 0;
	}
	
	switch ( iMethod )
	{
		case 1:
		{
			getLine1(rPts, nPts, x1, y1, x2, y2, nPrecision);
			break;
		}
		case 2:
		{
			getLine2(rPts, nPts, x1, y1, x2, y2, nPrecision);
			break;
		}
		case 3:
		{      
			getLine3(rPts, nPts, x1, y1, x2, y2, nPrecision);
			break;
		}
		case 4:
		{      
			interpolation(rPts, nPts, x1, y1, x2, y2, nPrecision);
			break;
		}
		default:
		{
			getLine0(rPts, nPts, x1, y1, x2, y2, nPrecision);
			break;
		}
	}
	
	return rPts;
}
