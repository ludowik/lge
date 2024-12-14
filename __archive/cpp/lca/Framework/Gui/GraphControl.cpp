#include "System.h"
#include "GraphControl.h"

GraphSerie::GraphSerie() {
}

GraphSerie::~GraphSerie() {
}

GraphSeries::GraphSeries() {
}

GraphSeries::~GraphSeries() {
}

ImplementClass(Colors) : public List {
public:
	Colors () {
	};
	virtual ~Colors() {
	};

public:
	ColorObjectRef get(int i) {
		return (ColorObjectRef)List::get(i);
	}
	
};

Colors m_colors;

ImplementClass(Data) {
public:
	int nbs;
	int nbx;
	int nby;
	
	double x;
	double y;
	
	int w;
	int h;
	
	double dx;
	double dy;
	
	int i;
	int j;
	int k;
	
	double v;
	
	double v1;
	double v2;
	
	double t;
	
	double vmin;
	double vmax;
	
	double vmax1;
	double vmax2;
	double tmaxx;
	double tmaxs;
	
	GraphSerie* m_serie;
	
	Color c;
	
	double emax;
	
	Data() {
		Reset();
	}

	void Reset() {
		nbs = 0;
		nbx = 0;
		nby = 0;
		
		x = 0;
		y = 0;
		
		w = 0;
		h = 0;
		
		dx = 0;
		dy = 0;
		
		i = 0;
		j = 0;
		k = 0;
		
		v = 0;
		
		v1 = 0;
		v2 = 0;
		
		t = 0;
		
		vmin = INT_MAX;
		vmax = INT_MIN;
		
		vmax1 = 0;
		vmax2 = 0;

		tmaxx = INT_MIN;
		tmaxs = INT_MIN;
		
		m_serie = 0;
		
		c = transparentColor;
		
		emax = INT_MIN;
	}
	
};

#define nbs (data->nbs)
#define nbx (data->nbx)
#define nby (data->nby)

#define x (data->x)
#define y (data->y)

#define dw (data->w)
#define dh (data->h)

#define dx (data->dx)
#define dy (data->dy)

#define di (data->i)
#define dj (data->j)
#define dk (data->k)

#define v (data->v)

#define v1 (data->v1)
#define v2 (data->v2)

#define t (data->t)

#define vmin (data->vmin)
#define vmax (data->vmax)

#define vmax1 (data->vmax1)
#define vmax2 (data->vmax2)

#define tmaxx (data->tmaxx)
#define tmaxs (data->tmaxs)

#define m_serie (data->m_serie)

#define c (data->c)

#define emax (data->emax)

GraphControl::GraphControl(GraphSeries* series, int mode) : Control() {
	m_class = "GraphControl";
	data = new Data();
	
	m_mode = mode;
	
	m_mx = 5;
	m_my = 5;
	
	m_x_marque1 = true;
	m_x_marque2 = true;
	
	m_y_marque1 = true;
	m_y_marque2 = true;
	
	m_color_axe = white;
	m_color_marque = red;
	
	m_series = series;
	
	if ( m_colors.getCount() == 0 ) {
		m_colors.add(new ColorObject(red  ));
		m_colors.add(new ColorObject(green));
		m_colors.add(new ColorObject(blue ));
		
		Color color;

		for ( int index = 0 ; index < 20 ; ++index ) {
			do {
				color = randomColor();
			}
			while ( color == black );

			m_colors.add(new ColorObject(color));
		}
	}
    
	set_wh(System::Media::getMachineType()==iPad?300:150,
		   System::Media::getMachineType()==iPad?200: 80);    

    m_layout |= posRightExtend;
}

GraphControl::~GraphControl() {
	delete data;
}

void GraphControl::computeSize(GdiRef gdi) {
    Control::computeSize(gdi);
}

void GraphControl::drawBackground(GdiRef gdi) {
	gdi->rect(&m_rect, black, white);
}

void GraphControl::DECL(GdiRef gdi) {
	data->Reset();
	
	m_x = m_rect.left();
	m_y = m_rect.top();
	
	nbs = m_series->getCount();
	if ( nbs ) {
		nbx = (m_series->get(0))->getCount();
		nby = (m_series->get(0))->getCount();
		
		dw = m_rect.w;
		dh = m_rect.h;
		
		dx = divby( dw - 2 * m_mx , nbx);
		dy = divby( dh - 2 * m_my , nby);
		
		fromto(, dj, 0, nbx) {
			t = 0;
			fromto(, di, 0, nbs) {
				m_serie = m_series->get(di);
				v = m_serie->get(dj)->m_val;
				vmax = max(vmax, v);
				vmin = min(vmin, v);
				t += abs(v);
			}
			tmaxx = max(tmaxx, t);
		}
		fromto(, di, 0, nbs) {
			t = 0;
			m_serie = m_series->get(di);
			fromto(, dj, 0, nbx) {
				v = m_serie->get(dj)->m_val;
				t += abs(v);
			}
			tmaxs = max(tmaxs, t);
		}
		emax = vmax/*-vmin*/;
	}
}

void GraphControl::Quadrillage(GdiRef gdi) {
	// L'axe X  
	gdi->line(m_x+m_mx, m_y+dh-m_my, m_x+dw-m_mx, m_y+dh-m_my, m_color_axe);
	
	// Le quadrillage principal de l'axe X
	if ( m_x_marque1 ) {
		Quadrillage(gdi, m_x+m_mx, m_y+dh-m_my, 0, 10, (int)dx, 0, m_color_marque, false);
	}
	
	// Le quadrillage secondaire de l'axe X
	if ( m_x_marque2 ) {
		Quadrillage(gdi, m_x+m_mx, m_y+dh-m_my, 0, 10, (int)dx, 0, m_color_marque, true);
	}
	
	// L'axe Y
	gdi->line(m_x+m_mx, m_y+dh-m_my, m_x+m_mx, m_y+m_my, m_color_axe);
	
	// Le quadrillage principal de l'axe y
	if ( m_y_marque1 ) {
		Quadrillage(gdi, m_x+m_mx, m_y+dh-m_my, 10, 0, 0, (int)dy, m_color_marque, false);
	}
	
	// Le quadrillage secondaire de l'axe y
	if ( m_y_marque2 ) {
		Quadrillage(gdi, m_x+m_mx, m_y+dh-m_my, 10, 0, 0, (int)dy, m_color_marque, true);
	}
}

void GraphControl::Quadrillage(GdiRef gdi,
							   int _x,
							   int _y,
							   int lenx,
							   int leny,
							   int _dx,
							   int _dy,
							   Color color,
							   bool inter) {	
	if ( inter ) {
		color = luminosity(color, .3);
		
		x = _x + _dx / 2;
		y = _y - _dy / 2;
		
		v = vmin + divby( emax , nby ) / 2 ;
	}
	else {
		x = _x + _dx;
		y = _y - _dy;
		
		v = vmin + divby( emax , nby ) ;
	}
	
	fromto(, di, 0, nby) {
		gdi->line((int)(x),
				  (int)(y),
				  (int)(x+lenx),
				  (int)(y-leny), color);
		
		if ( dy && !inter ) {
			String text(v);
			Rect size = gdi->getTextSize(text);
			
//			gdi->text((int)(x-size.left()), (int)(y-size.top()), text);
		}
		
		v += divby( emax , nby );
		
		x += _dx;
		y -= _dy;
	}
}

/* Histogramme groupe
 Compare les valeurs y prisent a differentes abscisses x
 */
void GraphControl::HistogrammeGroupe(GdiRef gdi) {
	DECL(gdi);
	
	Quadrillage(gdi);
	
	y = m_y+dh-m_my;
	if ( vmin < 0 ) {
		y += divby( vmin * ( dh - 2 * m_my ), emax);
	}
	
	fromto(, di, 0, nbs) {
		x = m_x + m_mx + ( dx / 4 ) + ( di * divby(dx/2,nbs) );
		
		c = m_colors.get(di)->m_val;
		m_serie = m_series->get(di);
		
		fromto(, dj, 0, nbx) {
			v = muldiv( abs(m_serie->get(dj)->m_val), dh - 2 * m_my, emax);
			
			gdi->rect((int)(x),
					  (int)(y-v),
					  (int)max(divby(dx/2,nbs+1), 2),
					  (int)max(v+1,2),
					  c, c);
			
			x += dx;
		}
	}
}

/* Histogramme empile
 Compare la contribution de chaque valeur y par rapport au total a differentes abscisses x
 */
void GraphControl::HistogrammeEmpile(GdiRef gdi) {
	DECL(gdi);
	
	Quadrillage(gdi);
	
	fromto(, dj, 0, nbx) {
		x = m_x+m_mx+dx/4+dj*dx;
		y = m_y+dh-m_my;
		
		fromto(, di, 0, nbs) {
			c = m_colors.get(di)->m_val;
			m_serie = m_series->get(di);
			
			v = muldiv( abs(m_serie->get(dj)->m_val), dh - 2 * m_my, tmaxx);
			
			gdi->rect((int)(x),
					  (int)(y-v),
					  (int)(dx/2+1),
					  (int)(v+1), c, c);
			
			y -= v;
		}
	}
} 

/* Histogramme empile a 100%
 Compare la contribution en pourcentage de chaque valeur y par rapport au total a differentes abscisses x
 */
void GraphControl::HistogrammeEmpile100(GdiRef gdi) {
	DECL(gdi);
	
	Quadrillage(gdi);
	
	fromto(, dj, 0, nbx) {
		x = m_x+m_mx+dx/4+dj*dx;
		y = m_y+dh-m_my;
		
		vmax = 0;
		fromto(, dk, 0, nbs) {
			vmax += abs((m_series->get(dk))->get(dj)->m_val);
		}
		
		fromto(, di, 0, nbs) {
			c = m_colors.get(di)->m_val;
			m_serie = m_series->get(di);
			
			v = muldiv( abs(m_serie->get(dj)->m_val) , dh - 2 * m_my , vmax);
			
			gdi->rect((int)(x),
					  (int)(y-v),
					  (int)(dx/2+1),
					  (int)(v+1), c, c);
			
			y -= v;
		}
	}
}

/* Courbe
 Affiche une tendance dans le temps ou sur differentes abscisses x
 */
void GraphControl::Courbe(GdiRef gdi) {
	DECL(gdi);
	
	Quadrillage(gdi);
	
	y = m_y+dh-m_my;
	if ( vmin < 0 ) {
		y += muldiv ( vmin , dh - 2 * m_my , emax);
	}
	
	fromto(, di, 0, nbs) {
		x = m_x+m_mx+dx/2;
		
		c = m_colors.get(di)->m_val;
		m_serie = m_series->get(di);
		
		fromto(, dj, 1, nbx) {
			v1 = muldiv( m_serie->get(dj-1)->m_val , dh - 2 * m_my , emax);
			v2 = muldiv( m_serie->get(dj  )->m_val , dh - 2 * m_my , emax);
			
			gdi->rect((int)(x-2),
					  (int)(y-v1-2),
					  5,
					  5, c, c);
			
			gdi->line((int)(x),
					  (int)(y-v1),
					  (int)(x+dx),
					  (int)(y-v2), c);
			
			x += dx;
		}
		gdi->rect((int)(x-2),
				  (int)(y-v2-2),
				  5,
				  5, c, c);
	}
}

/* CourbeEmpile
 Affiche la tendance de la contribution de chaque valeur y dans le temps ou a differetnes abscisses x
 */
void GraphControl::CourbeEmpile(GdiRef gdi) {
	DECL(gdi);
	
	Quadrillage(gdi);
	
	y = m_y+dh-m_my;
	
	fromto(, di, 0, nbs) {
		x = m_x+m_mx+dx/2;
		
		c = m_colors.get(di)->m_val;
		m_serie = m_series->get(di);
		
		fromto(, dj, 1, nbx) {
			v1 = muldiv( abs(m_serie->get(dj-1)->m_val) , dh - 2 * m_my , tmaxx);
			v2 = muldiv( abs(m_serie->get(dj  )->m_val) , dh - 2 * m_my , tmaxx);
			
			if ( di > 0 ) {
				fromto(, dk, 0, di) {
					v1 += muldiv( abs(m_series->get(dk)->get(dj-1)->m_val) , dh - 2 * m_my , tmaxx);
					v2 += muldiv( abs(m_series->get(dk)->get(dj  )->m_val) , dh - 2 * m_my , tmaxx);
				}
			}
			
			gdi->rect((int)(x-2),
					  (int)(y-v1-2),
					  5,
					  5, c, c);
			
			gdi->line((int)(x),
					  (int)(y-v1),
					  (int)(x+dx),
					  (int)(y-v2), c);
			
			x += dx;
		}
		
		gdi->rect((int)(x-2),
				  (int)(y-v2-2),
				  5,
				  5, c, c);
	}
}

/* CourbeEmpile100
 Affiche la tendance de la contribution en pourcentage de chaque valeur y dans le temps ou a differentes abscisses x
 */
void GraphControl::CourbeEmpile100(GdiRef gdi) {
	DECL(gdi);
	
	Quadrillage(gdi);
	
	y = m_y+dh-m_my;
	fromto(, di, 0, nbs) {
		x = m_x+m_mx+dx/2;
		
		c = m_colors.get(di)->m_val;
		m_serie = m_series->get(di);
		
		fromto(, dj, 1, nbx) {
			vmax1 = 0;
			vmax2 = 0;
			fromto(, dk, 0, nbs) {
				vmax1 += abs(m_series->get(dk)->get(dj-1)->m_val);
				vmax2 += abs(m_series->get(dk)->get(dj  )->m_val);
			}
			
			v1 = muldiv( abs(m_serie->get(dj-1)->m_val) , dh - 2 * m_my , vmax1);
			v2 = muldiv( abs(m_serie->get(dj  )->m_val) , dh - 2 * m_my , vmax2);
			
			if ( di > 0 ) {
				fromto(, dk, 0, di) {
					v1 += muldiv( abs(m_series->get(dk)->get(dj-1)->m_val) , dh - 2 * m_my , vmax1);
					v2 += muldiv( abs(m_series->get(dk)->get(dj  )->m_val) , dh - 2 * m_my , vmax2);
				}
			}
			
			gdi->rect((int)(x-2),
					  (int)(y-v1-2),
					  5,
					  5, c, c);
			
			gdi->line((int)(x),
					  (int)(y-v1),
					  (int)(x+dx),
					  (int)(y-v2), c);
			
			x += dx;
		}
		gdi->rect((int)(x-2),
				  (int)(y-v2-2),
				  5,
				  5, c, c);
	}
}

void GraphControl::Secteur(GdiRef gdi) {
	DECL(gdi);
	
	m_serie = m_series->get(0);
	
	x = (int)( m_x + dw/2. );
	y = (int)( m_y + dh/2. );
	
	int r = min((dw-2*m_mx),(dh-2*m_my))/2;
	
	double ad = 0;
	double aa = 0;
	
	fromto(, dj, 0, nbx) {
		c = m_colors.get(dj)->m_val;
		
		aa = muldiv(abs(m_serie->get(dj)->m_val), 360 , tmaxs);
		
		gdi->pie((int)x,
				 (int)y,
				 r,
				 ad,
				 aa,
				 c, c);
		
		ad += aa;
	}
}

/* Area
 */
void GraphControl::Area(GdiRef gdi) {
	DECL(gdi);
	
	m_x_marque1 = false;
	m_x_marque2 = false;
	
	m_y_marque1 = false;
	m_y_marque2 = false;
	
	Quadrillage(gdi);
	
	y = m_y+dh-m_my;
	if ( vmin < 0 ) {
		y += muldiv ( vmin , dh - 2 * m_my , emax);
	}
	
	x = m_x+m_mx+dx/2;
	
	c = m_colors.get(0)->m_val;
	m_serie = m_series->get(0);
	
	fromto(, dj, 1, nbx) {
		v1 = muldiv( abs(m_serie->get(dj-1)->m_val) , dh - 2 * m_my , emax);
		v2 = muldiv( abs(m_serie->get(dj  )->m_val) , dh - 2 * m_my , emax);
		
		gdi->line((int)(x)   , (int)(y-v1),
		          (int)(x+dx), (int)(y-v2), c);
		
		x += dx;
	}
}

/* AreaEmpile
 */
void GraphControl::AreaEmpile(GdiRef gdi) {
	DECL(gdi);
	
	m_x_marque1 = false;
	m_x_marque2 = false;
	
	m_y_marque1 = false;
	m_y_marque2 = false;
	
	Quadrillage(gdi);
	
	y = m_y+dh-m_my;

	fromto(, di, 0, nbs) {
		x = m_x+m_mx+dx/2;
		
		c = m_colors.get(di)->m_val;
		m_serie = m_series->get(di);
		
		gdi->moveto((int)(x+dx), (int)(y));
		
		fromto(, dj, 1, nbx) {
			v1 = muldiv( abs(m_serie->get(dj-1)->m_val) , dh - 2 * m_my , tmaxx);
			v2 = muldiv( abs(m_serie->get(dj  )->m_val) , dh - 2 * m_my , tmaxx);
			
			if ( di > 0 ) {
				fromto(, dk, 0, di) {
					v1 += muldiv( abs(m_series->get(dk)->get(dj-1)->m_val) , dh - 2 * m_my , tmaxx);
					v2 += muldiv( abs(m_series->get(dk)->get(dj  )->m_val) , dh - 2 * m_my , tmaxx);
				}
			}
			
			gdi->line((int)(x),
					  (int)(y-v1),
					  (int)(x+dx),
					  (int)(y-v2), c);
			
			x += dx;
		}
	}
}

void GraphControl::draw(GdiRef gdi) {
	switch ( m_mode ) {
		case graphHistogrammeGroupe: {
			HistogrammeGroupe(gdi);
			break;
		}
		case graphHistogrammeEmpile: {
			HistogrammeEmpile(gdi);
			break;
		}
		case graphHistogrammeEmpile100: {
			HistogrammeEmpile100(gdi);
			break;
		}
		case graphCourbe: {
			Courbe(gdi);
			break;
		}
		case graphCourbeEmpile: {
			CourbeEmpile(gdi);
			break;
		}
		case graphCourbeEmpile100: {
			CourbeEmpile100(gdi);
			break;
		}
		case graphSecteur: {
			Secteur(gdi);
			break;
		}
		case graphArea: {
			Area(gdi);
			break;
		}
		case graphAreaEmpile: {
			AreaEmpile(gdi);
			break;
		}
	}
}
