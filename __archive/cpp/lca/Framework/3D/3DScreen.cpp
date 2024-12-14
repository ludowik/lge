#include "System.h"

#include "Gdi.Proc.h"

#include "3DScreen.h"
#include "3DVector.h"

bool bCombined = true;

Screen::Screen() {
	m_focale = 8;
	m_screenSize = 4;
	
	m_xEye = 0;
	m_yEye = 0;
	m_zEye = 0;
	
	m_fillMode = fillWireFrame; 
	m_projMode = projOrthogonal;
	
	buf.create(MAX_BUFFER_X, MAX_BUFFER_Y);
	
	/*
	 m_zBuffer = (DrawPixel**)System::Memory::alloc(MAX_BUFFER_X*sizeof(DrawPixel*));
	 for ( int i=0 ; i<MAX_BUFFER_X ; ++i ) {
	 m_zBuffer[i] = (DrawPixel*)System::Memory::alloc(MAX_BUFFER_Y*sizeof(DrawPixel));
	 memset(m_zBuffer[i], 0xFF, MAX_BUFFER_Y*sizeof(DrawPixel));
	 }
	 
	 m_xBuffer = (FillPixel*)System::Memory::alloc(MAX_BUFFER_Y*sizeof(FillPixel));
	 memset(m_xBuffer, 0xFF, MAX_BUFFER_Y*sizeof(FillPixel));
	 */
	
	light = C3DPoint(50,50,50);
}

Screen::~Screen() {
	/*
	 if (m_zBuffer) {
	 for ( int i=0 ; i<MAX_BUFFER_X ; ++i ) {
	 System::Memory::free(m_zBuffer[i]);
	 }
	 System::Memory::free(m_zBuffer);
	 }
	 if (m_xBuffer) {
	 System::Memory::free(m_xBuffer);
	 }
	 */
}

void Screen::OnCalc() {
	set_wh(250,250);
}

void Screen::OnDraw(GdiRef gdi) {
	Control::draw(gdi);
	
	DrawObject(gdi, m_refObject);
}

void Screen::DrawPoint(int x, int y, coord z, Color rgb) {
	if (   x < 0 || x >= m_rect.w
		|| y < 0 || y >= m_rect.h ) 	{
		return;
	}
	
	switch ( m_fillMode )
	{
			/*case fillTable:
			 {
			 if ( y >= 0
			 && y <= MAX_BUFFER_Y )
			 {
			 m_yMin = min(y, m_yMin);
			 m_yMax = max(y, m_yMax);
			 
			 if ( m_xBuffer[y].m_xMin==0xFFFFFFFF )
			 {
			 m_xBuffer[y].m_xMin = x;
			 m_xBuffer[y].m_xMax = x;
			 }
			 else
			 {
			 m_xBuffer[y].m_xMin = min(m_xBuffer[y].m_xMin, x);
			 m_xBuffer[y].m_xMax = max(m_xBuffer[y].m_xMax, x);
			 }
			 }
			 break;
			 }
			 */
			/*case fillGDI:
			 {
			 m_pDC->m_pixel(x, y, rgb);
			 break;
			 }
			 */
		case fillPoint:
		case fillWireFrame:
		case fillSolid:
		default:
		{
			/*if ( m_zBuffer[x][y].m_depth < z )
			 */
			{
				buf.pixel(x, y, rgb);
				
				/*m_zBuffer[x][y].m_colPixel = rgb;
				 m_zBuffer[x][y].m_depth = z;
				 */
			}
			break;
		}
	}
}

void Screen::DrawLine(int x1, int y1, coord z1,
					  int x2, int y2, coord z2, Color rgb) {
	switch ( m_fillMode )
	{
			/*case fillGDI:
			 {
			 m_pDC->MoveTo(x1, y1, rgb);
			 m_pDC->LineTo(x2, y2, rgb);
			 break;
			 }*/
		case fillPoint:
		{
			DrawPoint(x1, y1, z1, rgb);
			DrawPoint(x2, y2, z2, rgb);
			break;
		}
		case fillTable:
		case fillWireFrame:
		case fillSolid:
		default:
		{
			ForEachInLine(x1, y1, x2, y2, x, y)
			DrawPoint(x, y, 0, rgb);
			End();      
			break;
		}
	}
}

void Screen::InitPipeline() {
	// 1: World matrix Mworld transforms vertices from the model space to the world space
	mworld.initMatrix(1, 0, 0, 0,
					  0, 1, 0, 0,
					  0, 0, 1, 0,
					  0, 0, 0, 1);
	
	// 2: View matrix Mview transforms vertices from the world space to the camera space
	C3DPoint from(m_xEye, m_yEye, m_zEye);
	C3DPoint at  (m_xLookAt, m_yLookAt, m_zLookAt);
	
	C3DPoint up(0,1,0);
	
	Vector::MatrixLookAtLH(&mview, &from, &at, &up);
	
	// 3: Projection matrix Mproj transforms vertices from the camera space to the projection space
	double wh = min(m_rect.w, m_rect.h);
	
	// If a view volume is defined as:
	
	// screen window width  in camera space in near clipping plane
	double Sw = m_screenSize;
	
	// screen window height in camera space in near clipping plane
	double Sh = m_screenSize;
	
	// distance to the near clipping plane along Z axes in camera space
	double Zn =  m_focale;
	
	// distance to the far clipping plane along Z axes in camera space
	double Zf = Zn+40; 
	
	// then a perspective projection matrix could be written as follows
	mprojpers.initMatrix(2*Zn/Sw, 0,       0,              0,
						 0,       2*Zn/Sh, 0,              0,
						 0,       0,       Zf/(Zf-Zn),     1,
						 0,       0,       -Zf*Zn/(Zf-Zn), 0);
	
	// For the orthogonal projection we have
	mprojortho.initMatrix(2/Sw, 0,    0,           0,
						  0,    2/Sh, 0,           0,
						  0,    0,    1/(Zf-Zn),   1,
						  0,    0,    -Zn/(Zf-Zn), 0);
	
	// Clipping volume for all points P = (Xp, Yp, Zp, Wp) in the projection space is defined as:
	//   -Wp < Xp <= Wp
	//   -Wp < Yp <= Wp
	//     0 < Zp <= Wp
	// All points that do not satisfy these equations will be clipped
	
	// 4: Direct3D allows the user to change the clip volume
	// This transformation can provide increased precision and is equivalent to scaling and shifting the clipping volume. 
	// The corresponding Mclip matrix is:
	
	// If you do not want to scale the clip volume, you can set viewport parameters
	// to default values
	double cw   =  2; //  2
	double ch   =  2; //  2
	double cx   = -1; // -1
	double cy   =  1; //  1
	double zmin =  0; //  0
	double zmax =  1; //  1
	
	mclip.initMatrix(2/cw,       0,         0,                 0,
					 0,          2/ch,      0,                 0,
					 0,          0,         1/(zmax-zmin),     0,
					 -1-2*cx/cw, 1-2*cy/ch, -zmin/(zmax-zmin), 1);
	
	// 5: The clipping stage is optional
	// In this case, all matrices (including Mvs) can be combined
	
	// 6. The viewport scale matrix Mvs scales coordinates to be within the viewport window
	// and flips the Y axis from up to down:
	
	double dwx =  m_rect.w/2;
	double dwy = -m_rect.h/2;
	
	double dww = wh;
	double dwh = wh;
	
	mvs.initMatrix(dww, 0,       0, 0,
				   0,   -dwh,    0, 0,
				   0,   0,       1, 0,
				   dwx, dwh+dwy, 0, 1);
	
	// No clipping stage then all matrices (including Mvs) can be combined
	if ( bCombined ) {
		mtransform  = mworld;
		mtransform *= mview;
		switch ( m_projMode ) {
			case projOrthogonal: {
				mtransform *= mprojortho;
				break;
			}
			case projPerspective: {
				mtransform *= mprojpers;
				break;
			}
		}
		mtransform *= mclip;
		mtransform *= mvs;
	}
}

void Screen::Transform(C3DPoint* point3D, C3DPoint* point2D) {
	// Model space
	Matrix pm(point3D->x, point3D->y, point3D->z, 1);
	
	if ( !bCombined ) 	{
		pm *= mworld;
		pm *= mview;
		switch ( m_projMode )
		{
			case projOrthogonal:
			{
				pm *= mprojortho;
				break;
			}
			case projPerspective:
			{
				pm *= mprojpers;
				break;
			}
		}
		pm *= mclip;
		pm *= mvs;
	}
	else {
		pm *= mtransform;
	}
	
	/*
	 // 1: World matrix Mworld transforms vertices from the model space to the world space
	 pm = pm*mworld;
	 
	 // 2: View matrix Mview transforms vertices from the world space to the camera space
	 pm = pm*mview;
	 
	 // 3: Projection matrix Mproj transforms vertices from the camera space to the projection space
	 pm = pm*mprojpers;
	 
	 // Clipping volume for all points P = (Xp, Yp, Zp, Wp) in the projection space is defined as:
	 //   -Wp < Xp <= Wp
	 //   -Wp < Yp <= Wp
	 //     0 < Zp <= Wp
	 // All points that do not satisfy these equations will be clipped
	 
	 // 4: Direct3D allows the user to change the clip volume
	 // This transformation can provide increased precision and is equivalent to scaling and shifting the clipping volume. 
	 // The corresponding Mclip matrix is:
	 pm = pm*mclip;
	 
	 // 5: The clipping stage is optional
	 // In this case, all matrices (including Mvs) can be combined
	 
	 // 6. The viewport scale matrix Mvs scales coordinates to be within the viewport window
	 // and flips the Y axis from up to down:
	 pm = pm*mvs;
	 */
	
	// 7. Finally, screen coordinates are computed and passed to the rasterizer
	double w = pm.get(3,0);
	
	if ( !w ) {
		w = 1;
	}
	
	double xs = pm.get(0,0)/w;
	double ys = pm.get(1,0)/w;
	double zs = pm.get(2,0)/w;
	double ws = 1/w;
	
	point2D->x = (int)xs;
	point2D->y = (int)ys;
	point2D->z = (int)zs;
	point2D->w = (int)ws;
}

void Screen::DrawPoint(C3DPoint* point, Color rgb) {
	C3DPoint point2D;
	Transform(point, &point2D);
	
	DrawPoint((int)point2D.x, (int)point2D.y, (int)point2D.z, rgb);
}

void Screen::DrawLine(C3DPoint* point1, C3DPoint* point2, Color rgb) {
	C3DPoint point2D1;
	C3DPoint point2D2;
	
	Transform(point1, &point2D1);
	Transform(point2, &point2D2);
	
	DrawLine((int)point2D1.x, (int)point2D1.y, (int)point2D1.z,
			 (int)point2D2.x, (int)point2D2.y, (int)point2D2.z, rgb);
}

void Screen::DrawFace(C3DPoly* poly, Color rgb) {
	if ( IsVisible(poly) ) {
		DrawFace((*poly)[0], (*poly)[1], (*poly)[2], poly->m_rgb);
	}
}

void Screen::DrawFace(C3DPoint* point1, C3DPoint* point2, C3DPoint* point3, Color rgb) {
	switch ( m_fillMode )
	{
		default:
		{
			DrawLine(point1, point2, rgb);
			DrawLine(point2, point3, rgb);
			DrawLine(point3, point1, rgb);
			break;
		}
		case fillSolid:
		{
			/*
			 // La lumiere ambiante
			 double ia = 0.5; // Intensite de la source lumineuse
			 double ra = 1; // Coefficient de reflexion
			 
			 double ir = ia*ra; // Intensite de la lumiere resultant de la reflexion sur la surface
			 
			 // La lumiere ambiante diffuse
			 double id = 1; // Intensite de la source lumineuse
			 double rd = 1; // Coefficient de reflexion
			 double td = AngleLumiere(point1, point2, point3); // Angle forme par le rayon de lumiere et
			 // la normale au plan
			 
			 ir += id*rd*td;
			 
			 // La reflexion speculaire
			 double is = 1; // Intensite de la lumiere speculaire
			 double rs = 1; // Coefficient de reflexion speculaire
			 double tr = AngleReflechi(point1, point2, point3); // Angle forme par le rayon reflechi de lumiere et
			 // la normale au plan
			 double n=2; // Coefficient
			 
			 ir += is*rs*pow(tr,n);
			 
			 // Attenuation de la lumiere
			 double c1=.1;
			 double c2=.0001;
			 double c3=.000001;
			 double fd=0;
			 double dist=0;
			 
			 C3DPoint vect;
			 C3DPoint center;
			 C3DPoint camera(m_xEye, m_yEye, m_zEye);
			 
			 center.x = ( point1->x + point2->x + point3->x ) / 3;
			 center.y = ( point1->y + point2->y + point3->y ) / 3;
			 center.z = ( point1->z + point2->z + point3->z ) / 3;
			 
			 Vector::Subtract(&vect, &center, &camera);
			 dist = Vector::GetNorm(&vect);
			 
			 fd = min(1/(c1+c2*dist+c3*pow(dist,2)), 1);
			 
			 ir *= fd;
			 
			 // Utilisation de l'intensite sur la couleur
			 double r = GetRValue(rgb);
			 double g = GetGValue(rgb);
			 double b = GetBValue(rgb);
			 
			 r *= ir;
			 g *= ir;
			 b *= ir;
			 
			 r = minmax(r, 0, 255);
			 g = minmax(g, 0, 255);
			 b = minmax(b, 0, 255);
			 
			 COLORREF light = RGB(r,g,b);
			 
			 // Remplissage
			 fillMode fillMode = m_fillMode;
			 m_fillMode = fillTable;
			 
			 {
			 m_yMin = LONG_MAX;
			 m_yMax = LONG_MIN;
			 
			 memset(m_xBuffer, 0xFF, MAX_BUFFER_Y*sizeof(FillPixel));
			 
			 DrawLine(point1, point2, rgb);
			 DrawLine(point2, point3, rgb);
			 DrawLine(point3, point1, rgb);
			 
			 {
			 m_fillMode = fillWireFrame;
			 
			 C3DPoint point2D1;
			 C3DPoint point2D2;
			 
			 for ( int y=m_yMin ; y<=m_yMax ; ++y )
			 {
			 if ( m_xBuffer[y].m_xMax!=0xFFFFFFFF )
			 {
			 point2D1.x = (int)m_xBuffer[y].m_xMin;
			 point2D1.y = (int)y;
			 
			 point2D2.x = (int)m_xBuffer[y].m_xMax;
			 point2D2.y = (int)y;
			 
			 DrawLine((int)point2D1.x, (int)point2D1.y, (int)point2D1.z,
			 (int)point2D2.x, (int)point2D2.y, (int)point2D2.z, light);
			 }
			 }
			 }
			 }
			 
			 m_fillMode = fillMode;      
			 */
			break;
		}
	}
}

void Screen::DrawPoly(C3DPoly* poly, Color rgb)
{
	if ( IsVisible(poly) )
	{
		switch ( m_fillMode )
		{
			case fillTable:
				/*case fillGDI:
				 */
			case fillPoint:
			case fillWireFrame:
			{
				Iterator iter = poly->m_array.getIterator();
				C3DPoint* point1 = (C3DPoint*)iter.next();
				
				while ( iter.hasNext() ) {
					C3DPoint* point2 = (C3DPoint*)iter.next();
					DrawLine(point1, point2, rgb);
					point1 = point2;
				}
				break;
			}
			case fillSolid:
			{
				C3DPoint* point1 = (*poly)[0];
				
				int size = poly->getCount();
				for ( int pos=2 ; pos<size ; ++pos )
				{
					C3DPoint* point2 = (*poly)[pos-1];
					C3DPoint* point3 = (*poly)[pos  ];
					
					DrawFace(point1, point2, point3, rgb);
				}
				break;
			}
		}
	}
}

void Screen::DrawObject(GdiRef gdi, C3DObject* obj)
{
	InitPipeline();
	
	buf.erase(white);
	/*
	 for ( int i = 0 ; i < m_w ; ++i ) {
	 memset(m_zBuffer[i], 0xFF, m_h*sizeof(DrawPixel));
	 }
	 */
	
	foreach(C3DPoly*, poly, obj->m_array ) {
		switch ( poly->getCount() )
		{
			case 0:
			{
				break;
			}
			case 1:
			{
				DrawPoint((*poly)[0], poly->m_rgb);
				break;
			}
			case 2:
			{
				DrawLine((*poly)[0], (*poly)[1], poly->m_rgb);
				break;
			}
			case 3:
			{
				DrawFace(poly, poly->m_rgb);
				break;
			}
			default:
			{
				DrawPoly(poly, poly->m_rgb);
				break;
			}
		}
	}
	
	gdi->copy(&buf);
	/*
	 for ( int x = 0 ; x < m_w ; ++x )
	 {
	 for ( int y = 0 ; y < m_h ; ++y )
	 {
	 if ( m_zBuffer[x][y].m_colPixel != 0xFFFFFFFF )
	 {
	 gdi->m_pixel(x, y, m_zBuffer[x][y].m_colPixel);
	 }
	 }
	 }
	 */
}

bool Screen::IsVisible(C3DPoly* poly) {
	C3DPoint normal;
	C3DPoint center;
	C3DPoint camera(m_xEye, m_yEye, m_zEye);
	
	Vector::Normal(&normal, (*poly)[0], (*poly)[1], (*poly)[2]);
	
	foreach(C3DPoint*, point, poly->m_array) {
		center.x = center.x + point->x;
		center.y = center.y + point->y;
		center.z = center.z + point->z;
	}
	
	center.x = center.x / poly->getCount();
	center.y = center.y / poly->getCount();
	center.z = center.z / poly->getCount();
	
	Vector::Subtract(&camera, &center, &camera);
	Vector::Normalize(&camera, &camera);
	
	if ( Vector::DotProduct(&camera, &normal) >= 0 )
	{
		return false;
	}
	
	return true;
}

double Screen::AngleLumiere(C3DPoint* point1, C3DPoint* point2, C3DPoint* point3)
{
	C3DPoint normal;
	C3DPoint center;
	C3DPoint nlight;
	
	Vector::Normal(&normal, point1, point2, point3);
	
	center.x = ( point1->x + point2->x + point3->x ) / 3;
	center.y = ( point1->y + point2->y + point3->y ) / 3;
	center.z = ( point1->z + point2->z + point3->z ) / 3;
	
	Vector::Subtract(&nlight, &center, &light);
	Vector::Normalize(&nlight, &nlight);
	
	return Vector::DotProduct(&nlight, &normal);
}

double Screen::AngleReflechi(C3DPoint* point1, C3DPoint* point2, C3DPoint* point3)
{
	C3DPoint normal;
	C3DPoint center;
	C3DPoint nlight;
	C3DPoint camera(m_xEye, m_yEye, m_zEye);
	
	Vector::Normal(&normal, point1, point2, point3);
	
	center.x = ( point1->x + point2->x + point3->x ) / 3;
	center.y = ( point1->y + point2->y + point3->y ) / 3;
	center.z = ( point1->z + point2->z + point3->z ) / 3;
	
	Vector::Subtract(&nlight, &center, &light);
	Vector::Normalize(&nlight, &nlight);
	
	double cost = Vector::DotProduct(&nlight, &normal);
	
	Vector::SetNorm(&normal, &normal, Vector::GetNorm(&nlight)*cost);
	
	C3DPoint a;
	a.x = center.x - nlight.x;
	a.y = center.y - nlight.y;
	a.z = center.z - nlight.z;
	
	C3DPoint b;
	b.x = center.x + normal.x;
	b.y = center.y + normal.y;
	b.z = center.z + normal.z;
	
	C3DPoint c;
	c.x = center.x + ( b.x - a.x );
	c.y = center.y + ( b.y - a.y );
	c.z = center.z + ( b.z - a.z );
	
	C3DPoint rlight;
	rlight.x = c.x - center.x;
	rlight.y = c.y - center.y;
	rlight.z = c.z - center.z;
	
	Vector::Subtract(&camera, &center, &camera);
	Vector::Normalize(&camera, &camera);
	
	return Vector::DotProduct(&camera, &rlight);
}

/* Rotation autour de l'objet
 */
bool Screen::OnPenMove(int x, int y)
{
	static double g_previousX = -1;
	static double g_previousY = -1;
	
	if ( g_previousX != -1 ) {	
		/*Matrix rotationX(1, 0, 0,
		 0, System::Math::cos(a), -System::Math::sin(a),
		 0, System::Math::sin(a),  System::Math::cos(a));
		 */
		
		Matrix eye(m_xEye, m_yEye, m_zEye);
		
		double a = x - g_previousX;
		if ( a ) {
			Matrix rotationY(cos(a), 0, -sin(a),
							 0, 1, 0,
							 sin(a), 0, cos(a));
			eye *= rotationY;
		}
		
		a = y - g_previousY;
		if ( a ) {
			Matrix rotationZ(cos(a), -sin(a), 0,
							 sin(a), cos(a), 0,
							 0, 0, 1);
			eye *= rotationZ;
		}
		
		m_xEye = eye.get(0,0);
		m_yEye = eye.get(1,0);
		m_zEye = eye.get(2,0);	}
	
	g_previousX = x;
	g_previousY = y;
	
	return false;
}
