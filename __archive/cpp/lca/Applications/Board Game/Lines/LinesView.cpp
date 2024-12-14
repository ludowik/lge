#include "System.h"
#include "LinesCell.h"
#include "LinesModel.h"
#include "LinesView.h"

ApplicationObject<LinesView, LinesModel> appLines("Lines", "Lines", "lines.png", 0, pageBoardGame);

LinesView::LinesView() : BoardView() {
}

void LinesView::loadResource() {
	addResource("black.png");
	addResource("red.png");
	addResource("brown.png");
	addResource("gray.png");
	addResource("yellow.png");
	addResource("mouchete.png");
	addResource("sun.png");
}

void LinesView::draw(GdiRef gdi) {
	LinesModel* model = (LinesModel*)m_model;

	Rect rect;
	if ( m_statusbar )
		rect = m_statusbar->m_rect;	
	else
		rect = gdi->m_rect;	

	int x = rect.left()-40;
	int y = rect.bottom()+15;
	
	String score(model->m_score.m_value);
	gdi->text(x, y, score.getBuf());
	
	BoardView::draw(gdi);
	BoardView::drawCells(gdi, 7, y, m_wcell, m_hcell, model->m_pNxtBoard);
}
