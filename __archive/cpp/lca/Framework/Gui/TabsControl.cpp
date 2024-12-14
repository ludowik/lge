#include "System.h"
#include "TabsControl.h"

TabsPanel::TabsPanel(const char* text) : Control() {
	m_class = "TabsPanel";
	m_text = text;
	
	m_layout = posOver;
	
	m_visible = false;

	m_marginEx.setMargin(5);
	m_marginIn.setMargin(3);
}

TabsPanel::~TabsPanel() {
}

TabsControl::TabsControl(int id) : Control(id) {
	m_class = "TabsControl";
	m_itab = 0;
}

TabsControl::~TabsControl() {
}

void TabsControl::computeSize(GdiRef gdi) {
	foreach ( TabsPanelRef , panel , *this ) {
		Control::computeSize(gdi, panel->m_text);
		break;
	}
	m_marginEx.top = m_hText+m_marginIn.h();
}

void TabsControl::draw(GdiRef gdi) {
	int npoint = 0;
	PointRef ppoints = new Point[10];
	
	int x = m_rect.x;
	int y = m_rect.y;
	
	npoint = 0;
	
	ppoints[npoint++] = Point( x + m_marginIn.left / 2           , y + m_marginIn.top / 2 );
	ppoints[npoint++] = Point( x + m_marginIn.left / 2           , y - m_marginIn.top / 2 + m_rect.h );
	ppoints[npoint++] = Point( x - m_marginIn.left / 2 + m_rect.w, y - m_marginIn.top / 2 + m_rect.h );
	ppoints[npoint++] = Point( x - m_marginIn.left / 2 + m_rect.w, y + m_marginEx.top );
	ppoints[npoint++] = Point( x + m_marginIn.left / 2           , y + m_marginEx.top );
	
	gdi->lines(npoint, ppoints, m_fgColor, 0, 0, false);
	
	foreach ( TabsPanelRef , panel , *this ) {
		if ( panel == get(m_itab) ) {
			panel->m_visible = true;
			gdi->text(x + m_marginIn.left, y + m_marginIn.top, panel->m_text, red);
		}
		else {
			panel->m_visible = false;
			gdi->text(x + m_marginIn.left, y + m_marginIn.top, panel->m_text, m_textColor);
		}
		
		Rect size = gdi->getTextSize(panel->m_text, m_fontName, m_fontSize);
		
		int w = size.w + m_marginIn.w();
		int h = size.h + m_marginIn.h();
		
		panel->m_rectText.set_xy(x, y);
		panel->m_rectText.set_wh(w, h);
		
		npoint = 0;    
		ppoints[npoint++] = Point(x+m_marginIn.left/2, y+m_marginIn.top/2+h);
		if ( panel == get(m_itab) ) {
			ppoints[npoint++] = Point(x+m_marginIn.left/2  , y+m_marginIn.top/2);
			ppoints[npoint++] = Point(x-m_marginIn.left/2+w, y+m_marginIn.top/2);
		}
		else {
			ppoints[npoint++] = Point(x+m_marginIn.left/2  , y+m_marginIn.top);
			ppoints[npoint++] = Point(x-m_marginIn.left/2+w, y+m_marginIn.top);
		}
		ppoints[npoint++] = Point(x-m_marginIn.left/2+w, y-m_marginIn.top/2+h);
		
		gdi->lines(npoint, ppoints, m_fgColor, 0, 0, false);
		
		x += panel->m_rectText.w+2*m_marginIn.left;
	}
	
	Control::draw(gdi);
	
	delete []ppoints;
}

bool TabsControl::touchBegin(int x, int y) {
	int itab = 0;
	
	foreach ( TabsPanelRef , panel , *this ) {
		if ( panel->m_rectText.contains(x, y) ) {
			m_itab = itab;
			break;
		}
		itab++;
	}
	
	return Control::touchBegin(x, y);
}
