#include "System.h"
#include "DrawView.h"
#include "ModeControl.h"

ModeControl::ModeControl(int mode) {
	m_mode = mode;
	m_layoutText = posWCenter|posHCenter;
}

void ModeControl::computeSize(GdiRef gdi) {
	const char* str = "W";
	Control::computeSize(gdi, str);
}

void ModeControl::draw(GdiRef gdi) {
	if ( m_mode == DrawView::m_drawInfo.mode )
		gdi->rect(m_rect.x, m_rect.y, m_rect.w, m_rect.h, red, white);
	else
		gdi->rect(m_rect.x, m_rect.y, m_rect.w, m_rect.h, white, white);
	
	const char* text = "";
	switch ( m_mode ) {
		case modeGomme : text = "G"; break;
		case modePoint : text = "P"; break;
		case modeLine  : text = "L"; break;
		case modeRect  : text = "R"; break;
		case modeCircle: text = "C"; break;
		case modeFill  : text = "F"; break;
	}
	
	m_text = text;
	
	gdi->text(xLayoutText(),
			  yLayoutText(),
			  text,
			  black);
}

bool ModeControl::touchBegin(int x, int y) {
	Control::touchBegin(x, y);
	DrawView::m_drawInfo.mode = m_mode;
	return true;
}

ChooseModeControl::ChooseModeControl(int iMode) : ModeControl(iMode) {
}

bool ChooseModeControl::touchBegin(int x, int y) {
	Menu menu;
	
	menu.add(new ModeControl(modeGomme ));
	menu.add(new ModeControl(modePoint ));
	menu.add(new ModeControl(modeLine  ));
	menu.add(new ModeControl(modeRect  ));
	menu.add(new ModeControl(modeCircle));
	menu.add(new ModeControl(modeFill  ));
	
	menu.run();
	
	m_mode = DrawView::m_drawInfo.mode;
	
	return true;
}
