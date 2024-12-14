#pragma once

ImplementClass(TraitementImage) : public Object {
public:
	String m_txt;
	
	bool m_trace;
	bool m_replace;
	
	GdiRef m_source;
	GdiRef m_cible;
	
	int m_n;
	
protected:
	GdiRef tmp1;
	GdiRef tmp2;
	
	int w;
	int h;
	
	int r;
	int g;
	int b;
	
	int m;
	
	Color color;
	
	Color getPixel(GdiRef source, int x, int y);
	
public:
	TraitementImage(GdiRef source);
	virtual ~TraitementImage();
	
public:
	virtual void execute();
	
	GdiRef traitement();
	void traitementInterne();
	
	virtual void getParam();
	
	virtual void preTraitement();
	virtual void postTraitement();
	
	virtual Color traitementPixel(int x, int y) = 0;
	
};

#include "binarisation.h"
#include "blur.h"
#include "colorisation.h"
#include "dilatation.h"
#include "grayscale.h"
#include "luminosite.h"
#include "pixelisation.h"
#include "squelettisation.h"
