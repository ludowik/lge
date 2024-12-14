#include "System.h"
#include "ScreenSaver.h"

ApplicationObject<ScreenSaver, Model> appScreenSaver("ScreenSaver", "ScreenSaver", "screensaver.png");

enum {
	actionInit=0,
	actionStart,
	actionExplode,
	actionEnd,
};

// L'objet de base
ImplementClass(AleaPoint) : public Object {
public:
	// La couleur du point
	Color m_rgbTest;
	Color m_rgbColor;
	
	// Position
	double m_x;
	double m_y;
	
	// Vecteur deplacement
	double m_dx;
	double m_dy;
	
	// Ancienne position pour le dessin
	double m_xOld;
	double m_yOld;
	
	double m_xOldBis;
	double m_yOldBis;
	
	// Paramètres aléatoires des mouvements
	int m_iMode;
	int m_iModeVal;
	
	// Proprietes
	bool m_bChoc;
	bool m_bSolidLine;
	bool m_bTrace;
	
	// Circonscription du point
	Rect m_rectClip;
	
	// Action pour la fin de vie
	int m_action;
	
public:  
	AleaPoint();
	AleaPoint(Rect& rectClip);
	virtual ~AleaPoint();
	
public:
	void init();
	
public:  
	virtual bool OnDraw(GdiRef gdi);
	
	virtual bool OnDrawAleaPoint(GdiRef gdi, Color rgb);
	virtual bool OnTestAleaPoint(GdiRef gdi, Color rgb);
	
public:
	virtual void Move()=0;
	virtual void Check();
	
	virtual int Action();	
	
};

// Constructeur
AleaPoint::AleaPoint() {
	init();
}

AleaPoint::AleaPoint(Rect& rectClip) {
	init();
	m_rectClip = rectClip;
}

void AleaPoint::init() {
	Rect windowRect = System::Media::getWindowsSize();
	
	if ( !m_rectClip.w ) {
		m_rectClip.w = windowRect.w;
	}
	
	if ( !m_rectClip.h ) {
		m_rectClip.h = windowRect.h;
	}
	
	m_x = System::Math::random(m_rectClip.w) + m_rectClip.x;
	m_y = System::Math::random(m_rectClip.h) + m_rectClip.y;
	
	m_xOld = m_xOldBis = m_x;
	m_yOld = m_yOldBis = m_y;
	
	m_iMode = System::Math::random(10) + 1;
	
	m_iModeVal = mulby2(m_iMode) + 1;
	
	m_rgbColor = randomColor();
	
	m_dx = System::Math::random(m_iModeVal) - m_iMode;
	m_dy = System::Math::random(m_iModeVal) - m_iMode;
	
	m_bChoc      = System::Math::random(2) ? true : false;
	m_bSolidLine = System::Math::random(2) ? true : false;
	m_bTrace     = System::Math::random(2) ? true : false;
	
	m_action = actionInit;
	
	Check();
}

AleaPoint::~AleaPoint() {
}

// Test des contraintes et dessin du point
bool AleaPoint::OnDraw(GdiRef gdi) {
	if ( m_xOld != m_x || m_yOld != m_y ) {
		if ( m_bChoc && OnTestAleaPoint(gdi, white) ) {
			m_x = m_xOld;
			m_y = m_yOld;
			
			Check();
		}
		OnDrawAleaPoint(gdi, m_rgbColor);
	}
	return false;
}

// Primitive de dessin du point
bool AleaPoint::OnDrawAleaPoint(GdiRef gdi, Color rgb) {
	Color rgbDark = luminosity(rgb, 0.5);

	gdi->setPenSize(2);

	if ( m_bSolidLine ) {
		if ( m_bTrace ) {
			if ( m_xOldBis!=-1 && m_yOldBis!=-1 ) {
				gdi->line((int)m_xOldBis, (int)m_yOldBis,
						  (int)m_xOld   , (int)m_yOld   , rgbDark);
			}
		}
		
		if ( m_xOld != -1 && m_yOld != -1 ) {
			gdi->line((int)m_xOld, (int)m_yOld,
					  (int)m_x   , (int)m_y   , rgb);
		}
		else {
			gdi->pixel((int)m_x, (int)m_y, rgb);
		}
	}
	else {
		if ( m_bTrace ) {
			gdi->pixel((int)m_xOld, (int)m_yOld, rgbDark);
		}
		
		gdi->pixel((int)m_x, (int)m_y, rgb);
	}

	m_xOldBis = m_xOld;
	m_yOldBis = m_yOld;

	m_xOld = m_x;
	m_yOld = m_y;
	
	return true;
}

// Test de la couleur du point
bool AleaPoint::OnTestAleaPoint(GdiRef gdi, Color rgb) {
	m_rgbTest = gdi->getPixel((int)m_x, (int)m_y);
	
	if ( m_rgbTest == rgb ) {
		return true;
	}
	
	return false;
}
// On reste dans la zone prevue
void AleaPoint::Check() {
	m_x = minmax(m_x, (double)m_rectClip.x, (double)m_rectClip.right ());
	m_y = minmax(m_y, (double)m_rectClip.y, (double)m_rectClip.bottom());
	
	if ( m_x <= m_rectClip.x || m_x >= m_rectClip.right() ) {
		m_dx = -m_dx;
	}
	if ( m_y <= m_rectClip.y || m_y >= m_rectClip.bottom() ) {
		m_dy = -m_dy;
	}
	if ( m_dx == 0 ) {
		m_dx = System::Math::random(m_iModeVal) - m_iMode;
	}
	if ( m_dy == 0 ) {
		m_dy = System::Math::random(m_iModeVal) - m_iMode;
	}
}

// Quelles actions => message traite par la vue
int AleaPoint::Action() {
	return m_action;
}

// Premiere derivation
ImplementClass(AleaPoint1) : public AleaPoint {
public:  
	AleaPoint1(Rect& rectClip) : AleaPoint(rectClip) {}
	virtual ~AleaPoint1() {}
	
public:
	virtual void Move();
	
};

// Deplacement spécifique
void AleaPoint1::Move() {
	m_x += System::Math::random(m_iModeVal) - m_iMode;
	m_y += System::Math::random(m_iModeVal) - m_iMode;
	
	Check();
}

// Deuxieme derivation
ImplementClass(AleaPoint2) : public AleaPoint {
public:  
	AleaPoint2(Rect& rectClip) : AleaPoint(rectClip) {}
	virtual ~AleaPoint2() {}
	
public:
	virtual bool OnDraw(GdiRef gdi);
	
public:
	virtual void Move();
	
};

bool AleaPoint2::OnDraw(GdiRef gdi) {
	if ( m_xOld != m_x || m_yOld != m_y ) {
		if ( m_bChoc && OnTestAleaPoint(gdi, white) ) { 
			m_dx = System::Math::random(m_iModeVal) - m_iMode;
			m_dy = System::Math::random(m_iModeVal) - m_iMode;
			
			Move();
		}
		OnDrawAleaPoint(gdi, m_rgbColor);
	}
	return false;
}

// Deplacement spécifique
void AleaPoint2::Move() {
	m_x += m_dx;
	m_y += m_dy;
	
	Check();
}

// La version feu d'artifice
ImplementClass(FeuArtifice) : public AleaPoint {
public:
	double m_life;
	
public:
	FeuArtifice(int x=0, int y=0);
	
public:
	virtual void Move();
	virtual void Check();
	
	virtual int Action();
		
};

FeuArtifice::FeuArtifice(int x, int y) : AleaPoint() {
	m_rectClip = System::Media::getWindowsSize();
	
	m_x = x > 0 ? x : m_rectClip.w / 2;
	m_y = y > 0 ? y : m_rectClip.h - 1;
	
	m_xOld = m_xOldBis = m_x;
	m_yOld = m_yOldBis = m_y;
	
	m_dx = System::Math::random(-10., +10.)*System::Media::getCoefInterface();
	m_dy = System::Math::random(+40., +80.)*System::Media::getCoefInterface();
	
	m_action = actionStart;
	
	m_bChoc      = false;
	m_bSolidLine = false;
	m_bTrace     = true;

	m_life = System::Math::random(2., 5.);
}

void FeuArtifice::Move() {
	double facteur = ((double)ScreenSaver::g_delay) / ( 1000. * .5 );
	
	m_x -= m_dx * facteur;
	m_y -= m_dy * facteur;
	
	m_dy -= 9.8 * facteur;
	
	m_life -= facteur;
	
	Check();
}

// Le feu s'éteint s'il sort de la zone prevue
void FeuArtifice::Check() {
	if ( m_x <= m_rectClip.x || m_x >= m_rectClip.right() ) {
		m_life = 0;
		m_action = actionEnd;
	}
	if ( m_y <= m_rectClip.y || m_y >= m_rectClip.bottom() ) {
		m_life = 0;
		m_action = actionEnd;
	}
}

// Quelle action après la fin de vie 
int FeuArtifice::Action() {
	if ( m_life <= 0 ) {
		return m_action;
	}
	return 0;
}

Timer ScreenSaver::g_timer;

long ScreenSaver::g_delay = 0;

ScreenSaver::ScreenSaver() : View() {	
}

bool ScreenSaver::move() {
	if ( g_delay == 0 ) {
		g_timer.timerInit();
		g_delay = 1;
		return true;
	}
	
	g_delay = g_timer.timerDelay();
	g_timer.timerUpdate();
	
	for ( int i = 0 ; i < m_refListAleaPoint.getCount() ; ++i ) {
		AleaPointRef pAleaPoint = (AleaPointRef)m_refListAleaPoint.get(i);
		pAleaPoint->Move();
		switch ( pAleaPoint->Action() )
		{
			case actionStart:
			case actionExplode:
			{
				m_refListAleaPoint.remove(i);
				
				AleaPoint* child = NULL;
				
				int n = System::Math::random(10, 20);
				
				double angle = 0;
//				double delta = muldiv(2., PI, n);
				
				double vitesse = pAleaPoint->m_y * System::Math::random(.1, .3);
				double v10 = vitesse * .1;
				
				Color color = randomColor();
				fromto (int, j, 0, n) {
					angle += 360. / n;
					
					child = (AleaPoint*)m_refListAleaPoint.add((AleaPoint*)new FeuArtifice());
					child->m_rgbColor = color;
					
					child->m_x = pAleaPoint->m_x;
					child->m_y = pAleaPoint->m_y;
					
					double v = vitesse + System::Math::random(-v10, +v10);
					
					double radian = degree2radian(angle);
					child->m_dx = cos(radian) * v;
					child->m_dy = sin(radian) * v;
					
					child->m_xOld = child->m_xOldBis = child->m_x;
					child->m_yOld = child->m_yOldBis = child->m_y;
					
					if ( pAleaPoint->Action() == actionStart )
						child->m_action = actionExplode;
					else
						child->m_action = actionEnd;
				}
				
				if ( child != NULL )
					child->m_action = actionEnd;
				
				delete pAleaPoint;
				break;
			}
			case actionEnd:
			{
				m_refListAleaPoint.remove(i);
				delete pAleaPoint;
				break;
			}
		}
	}
	
	return true;
}

void ScreenSaver::draw(GdiRef gdi) {
	gdi->setPenSize(2);

	move();
	
	for ( int i = 0 ; i < m_refListAleaPoint.getCount() ; ++i ) {
		AleaPoint* pAleaPoint = (AleaPoint*)m_refListAleaPoint.get(i);
		if ( pAleaPoint ) {
			switch ( pAleaPoint->Action() ) {
				default:
				{
					pAleaPoint->OnDraw(gdi);
					pAleaPoint->OnDrawAleaPoint(gdi, pAleaPoint->m_rgbColor);
					break;
				}
				case 1:
				case 2:
				case 3:
				{
					pAleaPoint->OnDrawAleaPoint(gdi, pAleaPoint->m_rgbColor);
					break;
				}
			}
		}
	}
	gdi->setPenSize(1);
}

bool ScreenSaver::touchBegin(int x, int y) {
	if ( View::touchBegin(x, y) == false ) {
		FeuArtificeRef point = new FeuArtifice(x, y);
		m_refListAleaPoint.add(point);
		
		point->m_life = 0;
	}
	
	return true;
}

void ScreenSaver::createUI() {
	m_refListAleaPoint.add((AleaPoint*)new FeuArtifice());
	return;
	
	AleaPointRef pAleaPoint;
	
	int n;
	int i;
	int j;
	int k;
	
	n = System::Math::random(20) + 1;
	
	i = 0;
	
	Rect rect;
	
	int nbPoint = 1000;
	
	int margin = 0;
	
	Rect windowRect = System::Media::getWindowsSize();
	
	int g_wscreen = windowRect.w;
	int g_hscreen = windowRect.h;
	
	int xe, ye;
	
	for ( j = 0 ; j < n ; ++j ) {
		// Definition d'une zone par point : un point sur deux
		if ( System::Math::random(2) == 0 ) {
			rect.x = System::Math::random( g_wscreen - 2 * margin );
			rect.y = System::Math::random( g_hscreen - 2 * margin );
			
			xe = g_wscreen - 2 * margin - rect.x;
			ye = g_hscreen - 2 * margin - rect.y;
			
			rect.w = 10 + System::Math::random(xe);
			rect.h = 10 + System::Math::random(ye);
		} else {
			rect = windowRect;
		}
		
		rect.x = max(margin, rect.x);
		rect.y = max(margin, rect.y);
		
		rect.w = min(windowRect .w - 2 * margin, rect.w);
		rect.h = min(windowRect .h - 2 * margin, rect.h);
		
		for ( k = 0 ; k < nbPoint / n && i < nbPoint ; ++k , ++i ) {
			pAleaPoint = System::Math::random(2) ? (AleaPoint*)new AleaPoint1(rect): (AleaPoint*)new AleaPoint2(rect);
			m_refListAleaPoint.add(pAleaPoint);
		}
	}
	
	for ( ; i < nbPoint ; ++i ) {
		pAleaPoint = System::Math::random(2) ? (AleaPoint*)new AleaPoint1(rect): (AleaPoint*)new AleaPoint2(rect);
		m_refListAleaPoint.add(pAleaPoint);
	}
}
