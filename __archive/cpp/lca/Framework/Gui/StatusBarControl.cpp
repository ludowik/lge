#include "System.h"
#include "StatusBarControl.h"

StatusBarControl::StatusBarControl() : Control() {
	m_class = "StatusBarControl";
	
	m_wpercent = 100;
	m_hpercent = 0;
	
	m_marginEx.setMargin(4);
	m_marginIn.setMargin(3);
	
	m_layout = posLeftAlign | posTopAlign;

	String title;
	ViewRef view = get_view();
	if ( view->m_text.getLen() > 10 ) {
		title = view->m_text.left(8);
		title += "..";
	}
	else {
		title = view->m_text;
	}
	
	ControlRef ctrl = add(new StaticControl(title.getBuf()), posLeft);
	add(new TimeControl(), posWCenter);	
	add(new BatteryControl(), posRightAlign);
	
	if ( view != get_launcher() ) {
		ctrl->setListener(view, (FunctionRef)&View::onClose);
	}
	
	m_border = false;
}

StatusBarControl::~StatusBarControl() {
}

ControlRef StatusBarControl::add(ControlRef ctrl, LayoutType layout) {
	if ( ctrl ) {
		ctrl->m_border = false;
	}
	return Control::add(ctrl, layout);
}

void StatusBarControl::draw(GdiRef gdi) {
	// Background
	gdi->gradient(m_rect.x, m_rect.y, m_rect.w, m_rect.h, eVertical, grayLight2, grayDark2);
	Control::draw(gdi);
}
