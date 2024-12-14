#include "System.h"
#include "ListControl.h"

ListControl::ListControl() {
	m_class = "ListControl";
	m_selectedItem = 0;
	m_values.add(new String("none"));
}

ListControl::~ListControl() {
}

void ListControl::computeSize(GdiRef gdi) {
	int maxLen = 0;
	foreach ( ObjectRef , obj , m_values ) {
		maxLen = max(maxLen, strlen(obj->asString()));
	}

	String str('W', maxLen);
	Control::computeSize(gdi, str);
}

void ListControl::draw(GdiRef gdi) {
	if ( m_selectedItem >0 && m_selectedItem < m_values.getCount() ) {
		m_text = m_values.get(m_selectedItem)->asString();
	}
	else {
		m_text = "none";
	}
	
	gdi->text(xLayoutText(), yLayoutText(), m_text, m_textColor);
	gdi->rect(m_rect.x, m_rect.y, m_rect.w, m_rect.h, m_fgColor);
}

bool ListControl::touchBegin(int x, int y) {
	Menu menu;
	
	int i = 0;
	foreach ( ObjectRef , obj , m_values ) {
		menu.m_area->add(new ButtonControl(obj->asString(), i++), posNextLine|posWCenter);
	}
	
	int choice = menu.run();
	
	m_selectedItem = choice;
	
	if ( m_selectedItem < 0 || m_selectedItem >= m_values.getCount() ) {
		m_selectedItem = 0;
	}

	return true;
}

bool ListControl::touchMove(int x, int y) {
	return true;
}

bool ListControl::touchEnd(int x, int y) {
	return true;
}
