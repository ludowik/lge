#include "System.h"
#include "DrawView.h"
#include "ToolControl.h"

ToolControl::ToolControl(int size, int pen, int adjust) {
	drawInfo.rgb = DrawView::m_drawInfo.rgb;
	
	if ( size == -1 ) 	{
		drawInfo.size = 17;
		bSize = false;
	}
	else {
		drawInfo.size = size;
		bSize = true;
	}
	
	if ( pen == -1 ) {
		drawInfo.pen = DrawView::m_drawInfo.pen;
		bPen = false;
	}
	else {
		drawInfo.pen = pen;
		bPen = true;
	}
	
	if ( adjust == -1 ) {
		drawInfo.adjust = 255;
		bAdjust = false;
	}
	else {
		drawInfo.adjust = adjust;
		bAdjust = true;
	}
}

void ToolControl::computeSize(GdiRef gdi) {
	const char* str = "W";
	Control::computeSize(gdi, str);
}

void ToolControl::draw(GdiRef gdi) {
	drawInfo.rgb = DrawView::m_drawInfo.rgb;
	
    if (   (bSize   && drawInfo.size   == DrawView::m_drawInfo.size)
        || (bPen    && drawInfo.pen    == DrawView::m_drawInfo.pen)
        || (bAdjust && drawInfo.adjust == DrawView::m_drawInfo.adjust) )
		gdi->rect(m_rect.x, m_rect.y, m_rect.w, m_rect.h, red, white);
	else
		gdi->rect(m_rect.x, m_rect.y, m_rect.w, m_rect.h, white, white);

	DrawViewRef view = (DrawViewRef)m_view;
	view->drawPattern(gdi,
		m_rect.x+divby2(m_rect.w),
		m_rect.y+divby2(m_rect.h), &drawInfo);
}

bool ToolControl::touchBegin(int x, int y) {
	Control::touchBegin(x, y);
	
	if ( bSize ) {
		DrawView::m_drawInfo.size = drawInfo.size;
	}
	
	if ( bPen ) {
		DrawView::m_drawInfo.pen = drawInfo.pen;
	}
	
	if ( bAdjust ) {
		DrawView::m_drawInfo.adjust = drawInfo.adjust;
	}
	
	return true;
}

ChooseToolControl::ChooseToolControl(int size, int pen, int adjust) : ToolControl(size, pen, 255) {
}

bool ChooseToolControl::touchBegin(int x, int y) {
	Menu menu;
	
	menu.add(new ToolControl(-1, 0, -1));
	menu.add(new ToolControl(-1, 1, -1));
	menu.add(new ToolControl(-1, 2, -1));
	menu.add(new ToolControl(-1, 3, -1));
	menu.add(new ToolControl(-1, 4, -1));
	menu.add(new ToolControl(-1, 5, -1));
	menu.add(new ToolControl(-1, 6, -1));
	menu.add(new ToolControl(-1, 7, -1));
	
	menu.add(new ToolControl( 3, -1, -1));
	menu.add(new ToolControl( 5, -1, -1));
	menu.add(new ToolControl( 7, -1, -1));
	menu.add(new ToolControl( 9, -1, -1));
	menu.add(new ToolControl(11, -1, -1));
	menu.add(new ToolControl(13, -1, -1));
	menu.add(new ToolControl(15, -1, -1));
	menu.add(new ToolControl(17, -1, -1));
	
	menu.add(new ToolControl(-1, -1,  10));
	menu.add(new ToolControl(-1, -1,  20));
	menu.add(new ToolControl(-1, -1,  30));
	menu.add(new ToolControl(-1, -1,  40));
	menu.add(new ToolControl(-1, -1,  50));
	menu.add(new ToolControl(-1, -1,  60));
	menu.add(new ToolControl(-1, -1,  70));  
	menu.add(new ToolControl(-1, -1, 255));
	
	menu.run();
	
	drawInfo.size = DrawView::m_drawInfo.size;
	drawInfo.pen = DrawView::m_drawInfo.pen;
	
	return true;
}
