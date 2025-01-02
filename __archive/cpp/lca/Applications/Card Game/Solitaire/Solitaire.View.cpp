#include "System.h"
#include "Solitaire.Model.h"
#include "Solitaire.View.h"

ApplicationObject<SolitaireView, SolitaireModel> appSolitaire("Solitaire", "Solitaire", 0, 0, pageCardGame);

SolitaireView::SolitaireView() : CardGameView() {
}

SolitaireView::~SolitaireView() {
}

void SolitaireView::draw(GdiRef gdi) {
	SolitaireModelRef model = (SolitaireModelRef)m_model;
	
	calc(gdi, model->m_colonnes.getCount(), 4);
	
	if ( m_right2left ) {
		drawCards(gdi, &model->m_talon, m_mo, m_mo, 0, 0);
		drawCards(gdi, &model->m_ecart, m_mo+m_wcard+m_mc, m_mo, m_dwc, 0, m_dwc/3, 0, model->m_ecart.m_npioche);
		
		drawCardDeckList(gdi, &model->m_series, m_w-m_mo-3*m_mi-4*m_wcard, m_mo, m_wcard+m_mi, 0, 0, 0);
	}
	else {
		drawCards(gdi, &model->m_talon, m_w-m_mo-m_wcard, m_mo, 0, 0);
		drawCards(gdi, &model->m_ecart, m_w-m_mo-m_wcard-m_mc-m_wcard, m_mo, -m_dwc, 0, -m_dwc/3, 0, model->m_ecart.m_npioche);
		
		drawCardDeckList(gdi, &model->m_series, m_mo, m_mo, m_wcard + m_mi, 0, 0, 0);
	}
	
	drawCardDeckList(gdi, &model->m_colonnes, m_mo, m_mo+m_hcard+m_mo*3, m_wcard+m_mi, 0, 0, m_dhc);
}
