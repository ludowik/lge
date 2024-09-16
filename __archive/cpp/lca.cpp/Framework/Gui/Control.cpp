#include "System.h"
#include "Control.h"

Control::Control(int id) : Collection(), Font() {
	if ( id !=-1 ) {
		m_id = id;
	}
	
	m_class = "Control";
	
	m_collection = new List();
	
	m_text = "";
	m_ref = "";
	
	m_selectColor = red;
	m_fgColor = blue;
	m_bgColor = black;
	m_textColor = white;
	
	m_visible = true;
	m_selected = false;
	m_checked = false;
	m_readOnly = true;
	m_opaque = false;
	m_border = false;
	
	m_notifyTo = 0;
	m_notifyFunction = 0;
	
	m_marginEx.setMargin(2);
	m_marginIn.setMargin(3);
	
	m_wpercent = 100;
	m_hpercent = 0;

	m_xOrigin = 0;
	m_yOrigin = 0;
	
	m_wText = 0;
	m_hText = 0;
	
	m_layout = posRight;
	m_layoutText = posLeftAlign|posHCenter;
	
	m_parent = 0;
	m_view = 0;

	m_containers.m_collection->m_delete = false;
}

Control::~Control() {
}

void Control::computeSize(GdiRef gdi) {
}

void Control::computeSize(GdiRef gdi, const char* text) {
	computeSizeText(gdi, text);
	
	m_rect.w = m_wText + m_marginEx.w();
	m_rect.h = m_hText + m_marginEx.h();
}

void Control::computeSizeText(GdiRef gdi, const char* text) {
	Rect textSize = gdi->getTextSize(text, m_fontName, m_fontSize, m_fontAngle);
	
	m_wText = textSize.w;
	m_hText = textSize.h;
}

void Control::erase(GdiRef gdi) {
	if ( m_opaque ) {
		gdi->erase(m_bgColor);
	}
}

void Control::draw(GdiRef gdi) {
	foreach ( ControlRef , ctrl , *this ) {
		if ( ctrl->m_visible ) {
			gdi->setFont(ctrl->m_fontName, ctrl->m_fontSize, ctrl->m_fontAngle);
			draw(gdi, ctrl);
		}
	}
}

void Control::draw(GdiRef gdi, ControlRef ctrl) {
	if ( ctrl->m_opaque ) {
		gdi->rect(&ctrl->m_rect, m_bgColor, m_bgColor);
	}
	ctrl->draw(gdi);
	if ( ctrl->m_border ) {
		gdi->rect(&ctrl->m_rect, m_bgColor);
	}
}

int Control::xLayout(LayoutType layout, int w) {
	int x = 0;
	
	if ( layout & posRightAlign ) {
		x = m_rect.w - w;
	}
	else if ( layout & posWCenter ) {
		x = divby2( m_rect.w - w );
	}
	
	return x+m_rect.x;
}

int Control::xLayoutText() {
	return xLayout(m_layoutText, m_wText);
}

int Control::yLayout(LayoutType layout, int h) { 
	int y = 0;
	
	if ( layout & posBottomAlign ) {
		y = m_rect.h - h;
	}
	else if ( layout & posHCenter ) {
		y = divby2( m_rect.h - h );
	}
	
	return y+m_rect.y;
}

int Control::yLayoutText() {
	return yLayout(m_layoutText, m_hText);
}

void Control::unselect() {
	foreach ( ControlRef , obj , *this ) {
		obj->m_selected = false;
	}
}

ControlRef Control::add(ControlRef ctrl, LayoutType layout) {
	ControlRef parent = m_containers.getCount() ? (ControlRef)m_containers.getLast() : this;
	if ( layout ) {
		ctrl->m_layout = layout;
		if ( layout & posWCenter ) {
			ctrl->m_wpercent = 0;
		}
	}
	
	ctrl->m_parent = parent;
	ctrl->m_view = parent;
	while ( ctrl->m_view->m_parent ) {
		ctrl->m_view = ctrl->m_view->m_parent;
	}

	return (ControlRef)parent->m_collection->add(ctrl);
}

ControlRef Control::insert(ControlRef ctrl, int pos, LayoutType layout) {
	ControlRef parent = m_containers.getCount() ? (ControlRef)m_containers.getLast() : this;
	if ( layout ) {
		ctrl->m_layout = layout;
		if ( layout & posWCenter ) {
			ctrl->m_wpercent = 0;
		}
	}
	
	ctrl->m_parent = parent;
	ctrl->m_view = parent;
	while ( ctrl->m_view->m_parent ) {
		ctrl->m_view = ctrl->m_view->m_parent;
	}

	return (ControlRef)parent->m_collection->add(pos, ctrl);
}

ControlRef Control::startPanel(LayoutType layout, ControlRef ctrl, int wpercent, int hpercent) {
	ControlRef panel = ctrl ? ctrl : new Control();
	add(panel, layout);
	
	if ( wpercent != -1 ) {
		panel->m_wpercent = wpercent;
	}
	if ( hpercent != -1 ) {
		panel->m_hpercent = hpercent;
	}
	
	m_containers.push(panel);
	
	return (ControlRef)m_containers.getLast();
}

ControlRef Control::currentPanel() {
	return (ControlRef)m_containers.getLast();
}

ControlRef Control::endPanel() {
	m_containers.pop();
    return (ControlRef)currentPanel();
}

void Control::setListener(ObjectRef notifyTo, FunctionRef notifyFunction) {
	m_notifyTo = notifyTo;
	m_notifyFunction = notifyFunction;
}

ControlRef Control::get_control(int x, int y) {
	foreach_order ( ControlRef , ctrl , *this , false ) {
		if ( ctrl->m_visible ) {
			if ( ctrl->getCount() ) {
				ControlRef findCtrl = ctrl->get_control(x, y);
				if ( findCtrl ) {
					return findCtrl;
				}
				else if ( ctrl->m_rect.contains(x, y) ) {
					return ctrl;
				}
			}
			else if ( ctrl->m_rect.contains(x, y) ) {
				return ctrl;
			}
		}
	}
	
	return 0;
}

void Control::set_xy(int _x, int _y) {
	m_rect.x = _x;
	m_rect.y = _y;
}

void Control::set_wh(int _w, int _h) {
	m_rect.w = _w;
	m_rect.h = _h;
}

bool Control::onDrag(int x, int y, bool init) {
	static Point dragFrom;
	
	if ( init ) {
		dragFrom.x = x;
		dragFrom.y = y;
	}

	Event event;
	do {
		getEvent(event, eAllTouchEvent);					
		
		if ( event.m_type == eTouchMove ) {
			m_xOrigin = (int)( event.x - dragFrom.x );
			m_yOrigin = (int)( event.y - dragFrom.y );

			System::Media::redraw();
		}
		else {					
			System::Event::waitEvent();
		}
	}
	while ( event.m_type == eTouchMove || ( event.m_type != eTouchEnd && event.m_type != eTouchBegin ) );

	return onDrop((int)event.x, (int)event.y);
}

bool Control::onDrop(int x, int y) {
	return false;
}

bool Control::touchNotify() {
    bool ret = false;
    
    if ( m_notifyFunction ) {
        if ( m_notifyTo ) {
            ret = (m_notifyTo->*this->m_notifyFunction)(this);
        } else {
            ret = (this->*this->m_notifyFunction)(this);
        }
    }
    
    return ret;
}

bool Control::touchBegin(int x, int y) {
	return onDrag(x, y, true);
}

bool Control::touchMove(int x, int y) {
	return onDrag(x, y, false);
}

bool Control::touchEnd(int x, int y) {
	return onDrop(x, y);
}

bool Control::touchDoubleTap(int x, int y) {
	return false;
}

bool Control::touchTripleTap(int x, int y) {
	return false;
}
