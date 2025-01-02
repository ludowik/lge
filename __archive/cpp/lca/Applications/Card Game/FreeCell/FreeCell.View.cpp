#include "System.h"
#include "FreeCell.Model.h"
#include "FreeCell.View.h"

ApplicationObject<FreeCellView, FreeCellModel> appFreeCell("FreeCell", "FreeCell", 0, 0, pageCardGame);

FreeCellView::FreeCellView() : CardGameView() {
}

FreeCellView::~FreeCellView() {
}

void FreeCellView::draw(GdiRef gdi) {
	FreeCellModelRef model = (FreeCellModelRef)m_model;
	
	calc(gdi, model->m_colonnes.getCount(), 5);
	
	int wcardmi = m_wcard + m_mi;
	
	if ( m_right2left ) {
		drawCardDeckList(gdi, &model->m_ecarts, m_mo, m_mo, wcardmi, 0, 0, 0);
		drawCardDeckList(gdi, &model->m_series, m_w-m_mo-(m_wcard+m_mi)*model->m_series.getCount(), m_mo, wcardmi, 0, 0, 0);
	}
	else {
		drawCardDeckList(gdi, &model->m_ecarts, m_w-m_mo-(m_wcard+m_mi)*model->m_series.getCount(), m_mo, wcardmi, 0, 0, 0);
		drawCardDeckList(gdi, &model->m_series, m_mo, m_mo, wcardmi, 0, 0, 0);
	}

	drawCardDeckList(gdi, &model->m_colonnes, m_mo, m_mo+m_hcard+m_mc, wcardmi, 0, 0, m_dhc);
}
