#pragma once

#include "3DObject.h"
#include "3DPoint.h"
#include "3DPoly.h"
#include "Matrix.h"

#define MAX_BUFFER_X 1024
#define MAX_BUFFER_Y 1024

struct DrawPixel {
	Color m_colPixel;
	coord m_depth;
};

struct FillPixel {
	coord m_xMin;
	coord m_xMax;
};

typedef enum _projMode {
	projOrthogonal,
	projPerspective
} projMode;

typedef enum fillMode {
	fillTable,
	fillGDI,
	fillPoint,
	fillWireFrame,
	fillSolid
} fillMode;

ImplementClass(Screen) : public Control {
	coord m_xEye;
	coord m_yEye;
	coord m_zEye;
	
	coord m_xLookAt;
	coord m_yLookAt;
	coord m_zLookAt;
	
	coord m_focale;
	coord m_screenSize;
	
	fillMode m_fillMode;
	projMode m_projMode;
	
	C3DObject* m_refObject;
	
private:
	GdiWindows buf;

	/*DrawPixel** m_zBuffer;
	 FillPixel*  m_xBuffer;
	 */
	
	int m_yMin;
	int m_yMax;
	
	Matrix mworld;
	Matrix mview;
	Matrix mrotatex;
	Matrix mrotatey;
	Matrix mrotatez;
	Matrix mprojpers;
	Matrix mprojortho;
	Matrix mclip;
	Matrix mvs;
	
	Matrix mtransform;
	
	C3DPoint light;
	
	void DrawPoint(int x, int y, coord z, Color rgb);
	
	void DrawLine (int x1, int y1, coord z1,
				   int x2, int y2, coord z2, Color rgb);
	
	bool IsVisible(C3DPoly* poly);
	
	double AngleLumiere (C3DPoint* point1, C3DPoint* point2, C3DPoint* point3);
	double AngleReflechi(C3DPoint* point1, C3DPoint* point2, C3DPoint* point3);
	
	void InitPipeline();
	
	void Transform(C3DPoint* point3D, C3DPoint* point2D);
	
public:
	Screen();
	virtual ~Screen();
	
	virtual void OnCalc();
	virtual void OnDraw(GdiRef gdi);
	
	virtual bool OnPenMove(int x, int y);
	
	void DrawPoint (C3DPoint* point, Color rgb);
	
	void DrawLine  (C3DPoint* point1, C3DPoint* point2, Color rgb);
	
	void DrawFace  (C3DPoint* point1, C3DPoint* point2, C3DPoint* point3, Color rgb);
	
	void DrawFace  (C3DPoly* poly, Color rgb);
	void DrawPoly  (C3DPoly* poly, Color rgb);
	
	void DrawObject(GdiRef gdi, C3DObject* obj);
	
};
