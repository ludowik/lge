#include "System.h"
#include "TransformImage.h"

Singleton<GdiWindows> global(true);

TraitementImage::TraitementImage(GdiRef source) {
	m_trace = false;
	m_replace = true;
	
	m_n = 1;
	
	m_source = source;

	Rect rect = m_source->m_rect;
	w = rect.w;
	h = rect.h;
	
	m_cible = 0;
	
	GdiWindows& gdi = global.getInstance();
	if ( !gdi.isValid() ) {
//		gdi.m_gdi = new GdiWindows();
		gdi.create(2000, 2000);
	}
}

TraitementImage::~TraitementImage() {
}

Color TraitementImage::getPixel(GdiRef source, int x, int y) {
	return source->getPixel(x, y);
}

void TraitementImage::getParam() {
}

void TraitementImage::execute() {
	getParam();	
	traitement();
}

GdiRef TraitementImage::traitement() {
	m_cible = &global.getInstance();
	
	preTraitement();
	
	if ( m_n == 1 ) {
		traitementInterne();
	}
	else {
		BitmapRef tmp = new Bitmap();
		tmp->create(w, h);
		
		tmp1 = tmp;
		tmp2 = m_cible;
		
		tmp1->copy(m_source);
		
		for ( m = 0 ; m < m_n ; ++m ) {
			traitementInterne();
			
			m_cible = tmp1;
			tmp1 = tmp2;
			tmp2 = m_cible;
		}
		
		delete tmp;
	}
	
	postTraitement();
	
	if ( m_replace ) {
		m_source->copy(m_cible);
		return m_source;
	}
	
	return m_cible;
}

void TraitementImage::preTraitement() {
}

void TraitementImage::traitementInterne() {
	waitStart(h, m_trace);
	
	Rect rect = m_source->m_rect;
	fromto(int, y, rect.y, h) {
		fromto(int, x, rect.x, w) {
			Color clr = traitementPixel(x, y);
			if ( clr != nullColor ) {
				m_cible->pixel(x, y, clr);
			}
		}
		waitSetVal(y, m_trace);
	}
	
	waitEnd(m_trace);
}

void TraitementImage::postTraitement() {
}
