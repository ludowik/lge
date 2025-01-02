#include "System.h"
#include "Layout.h"

Layout::Layout() {
}

Layout::~Layout() {
}

void Layout::computeDisposition(GdiRef gdi, ControlRef view) {
	computeLayoutView(gdi, view);
}

void Layout::computeLayoutView(GdiRef gdi, ControlRef view) {	
	ControlRef previous = 0;
	
	Iterator iter = view->getIterator();
	while ( iter.hasNext() ) {
		ControlRef ctrl = (ControlRef)iter.next();
		
		computeSize(gdi, ctrl, view);
		
		computePosition1(ctrl, previous, view);
		computePosition2(ctrl, view);
		
		previous = ctrl;
	}
}

void Layout::computeSize(GdiRef gdi, ControlRef ctrl, ControlRef parent) {
	if ( ctrl->getCount() ) {
		// un panel
		ControlRef panel = ctrl;
		ctrl->computeSize(gdi);

		if ( panel->m_wpercent ) {
			panel->m_rect.w = (int)(panel->m_wpercent * parent->m_rect.w / 100 - parent->m_marginEx.w());
		}
		else {
			panel->m_rect.w = 0;
		}
		
		if ( panel->m_hpercent ) {
			panel->m_rect.h = (int)(panel->m_hpercent * parent->m_rect.h / 100 - parent->m_marginEx.h());
		}
		else {
			panel->m_rect.h = 0;
		}
		
		int xmax = 0;
		int ymax = 0 ;
		
		ControlRef previous = 0;
		
		Iterator iter = panel->getIterator();
		while ( iter.hasNext() ) {
			ControlRef ctrl = (ControlRef)iter.next();
			
			computeSize(gdi, ctrl, panel);
			computePosition1(ctrl, previous, panel);
			
			xmax = max(xmax, ctrl->m_rect.right ());
			ymax = max(ymax, ctrl->m_rect.bottom());
			
			previous = ctrl;
		}
		
		if ( panel->m_rect.w == 0 ) {
			panel->m_rect.w = xmax - panel->m_rect.x + panel->m_marginEx.right;
		}
		
		if ( panel->m_rect.h == 0 ) {
			panel->m_rect.h = ymax - panel->m_rect.y + panel->m_marginEx.bottom;
		}
		
		iter.begin();
		while ( iter.hasNext() ) {
			ControlRef ctrl = (ControlRef)iter.next();
			computePosition2(ctrl, panel);
		}
	}
	else {
		// un contrôle
		if ( ( ctrl->m_layout & posDefaultSize ) == 0 ) {
			ctrl->computeSize(gdi);
			
			if ( ctrl->m_wpercent > 0 && ctrl->m_wpercent < 100 ) {
				ctrl->m_rect.w = (int)(ctrl->m_wpercent * parent->m_rect.w / 100 - parent->m_marginEx.w());
			}
			if ( ctrl->m_hpercent > 0 && ctrl->m_hpercent < 100 ) {
				ctrl->m_rect.h = (int)(ctrl->m_hpercent * parent->m_rect.h / 100 - parent->m_marginEx.h());
			}			
		}
	}
}

/* layout de position
 */
void Layout::computePosition1(ControlRef ctrl, ControlRef previous, ControlRef parent) {
	LayoutType layout = ctrl->m_layout;
	
	int x = ctrl->m_rect.x;
	int y = ctrl->m_rect.y;
	
	Margin m_marginEx = parent->m_marginEx;
	Margin m_marginIn = parent->m_marginIn;
	
	// A droite ou à gauche
	if ( layout & posRight ) {
		x = previous ? previous->m_rect.right() + m_marginIn.left : parent->m_rect.left() + m_marginEx.left;
	}
	else if ( layout & posLeft ) {
		x = previous ? previous->m_rect.left() - m_marginIn.left - ctrl->m_rect.w : parent->m_rect.left() + m_marginEx.left;
	}
	else if ( layout ) {
		x = previous ? previous->m_rect.x : parent->m_rect.left() + m_marginEx.left;
	}
		
	// Au dessus ou en dessous
	if ( layout & posBelow ) {
		y = previous ? previous->m_rect.bottom() + m_marginIn.top : parent->m_rect.top() + m_marginEx.top;
	}
	else if ( layout & posAbove ) {
		y = previous ? previous->m_rect.top() - m_marginIn.top - ctrl->m_rect.h : parent->m_rect.top() + m_marginEx.top;
	}
	else if ( layout & posOver ) {
		y = previous ? previous->m_rect.y : parent->m_rect.top() + m_marginEx.top;
	}
	else if ( layout & posNextLine || ( layout && parent->m_wpercent !=0 && x + ctrl->m_rect.w + m_marginEx.right > parent->m_rect.right() ) ) {
		x = parent->m_rect.left() + m_marginEx.left;
		y = previous ? previous->m_rect.bottom() + m_marginIn.top : parent->m_rect.top() + m_marginEx.top;
	}
	else if ( layout & posNextCol ) {
		x = previous ? previous->m_rect.right() + m_marginIn.left : parent->m_rect.left() + m_marginEx.left;
		y = parent->m_rect.top() + m_marginEx.top;
	}
	else if ( layout ) {
		y = previous ? previous->m_rect.y : parent->m_rect.top() + m_marginEx.top;
	}
	
	adjustPosition(ctrl, x, y);
}

/* layout de taille
 */
void Layout::computePosition2(ControlRef ctrl, ControlRef parent) {
	LayoutType layout = ctrl->m_layout;
	
	int x = ctrl->m_rect.x;
	int y = ctrl->m_rect.y;
	
	Margin m_marginEx = parent->m_marginEx;
	
	// Alignement en largeur
	if ( layout & posWCenter ) {
		if ( layout & posLeftAlign ) {
			x = parent->m_rect.x + parent->m_rect.w / 2 - ctrl->m_rect.w;
		}
		else if ( layout & posRightAlign ) {
			x = parent->m_rect.x + parent->m_rect.w / 2;
		}
		else {
			x = parent->m_rect.x + ( parent->m_rect.w - ctrl->m_rect.w ) / 2;
		}
	}
	else if ( layout & posLeftAlign ) {
		x = parent->m_rect.left() + m_marginEx.left;
	}
	else if ( layout & posRightAlign ) {
		x = parent->m_rect.right() - m_marginEx.right - ctrl->m_rect.w;
	}
	
	// Alignement en hauteur
	if ( layout & posHCenter ) {
		if ( layout & posTopAlign ) {
			y = parent->m_rect.y + parent->m_rect.h / 2 - ctrl->m_rect.h;
		}
		else if ( layout & posBottomAlign ) {
			y = parent->m_rect.y + parent->m_rect.h / 2;
		}
		else {
			y = parent->m_rect.y + ( parent->m_rect.h - ctrl->m_rect.h ) / 2;
		}
	}
	else if ( layout & posTopAlign ) {
		y = parent->m_rect.top() + m_marginEx.top;
	}
	else if ( layout & posBottomAlign ) {
		y = parent->m_rect.bottom() - m_marginEx.bottom - ctrl->m_rect.h;
	}

	// Extension en largeur
	if ( ctrl->m_layout & posRightExtend ) {
		ctrl->m_rect.w = parent->m_rect.x + parent->m_rect.w - ctrl->m_rect.x - m_marginEx.right;
	}
	
	// Extension en hauteur
	if ( ctrl->m_layout & posBottomExtend ) {
		ctrl->m_rect.h = parent->m_rect.bottom() - ctrl->m_rect.y - m_marginEx.bottom;
		if ( ctrl->m_rect.h == 0 && parent->m_parent ) {
			ctrl->m_rect.h = parent->m_parent->m_rect.bottom() - ctrl->m_rect.y - m_marginEx.bottom;
		}
	}

	adjustPosition(ctrl, x, y);
}

void Layout::adjustPosition(ControlRef panel, int x, int y) {
	Iterator iter = panel->getIterator();
	while ( iter.hasNext() ) {
		ControlRef ctrl = (ControlRef)iter.next();
		adjustPosition(ctrl, ctrl->m_rect.x + x - panel->m_rect.x, ctrl->m_rect.y + y - panel->m_rect.y);
	}
	
	panel->m_rect.x = x;
	panel->m_rect.y = y;
}
