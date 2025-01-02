#include "System.h"
#include "Menu.h"

Menu::Menu() {
	m_area->m_layout = posHCenter|posWCenter;
	m_area->m_opaque = true;
	
	m_area->m_marginIn.setMargin(6);
}

Menu::~Menu() {
}

bool Menu::touchBegin(int x, int y) {
	View::touchBegin(x, y);
	
	m_close = true;
	return true;
}

void Menu::createView() {
	m_area = startPanel(0, m_area); {
		createUI();
	}
	endPanel();
	
	computeSize(g_gdi);
}
