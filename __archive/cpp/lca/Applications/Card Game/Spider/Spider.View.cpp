#include "System.h"
#include "Spider.h"

ApplicationObject<SpiderView, SpiderModel> appSpider("Spider", "Spider", 0, 0, pageCardGame);

SpiderView::SpiderView() : CardGameView() {
	m_mc = 0;
}

void SpiderView::draw(GdiRef gdi) {
	SpiderModel* m = (SpiderModel*)m_model;
	
	calc(gdi, m->m_colonnes.getCount());
	
	drawCardDeckList(gdi, &m->m_colonnes, m_mo, m_mo, m_wcard+m_mi, 0, 0, m_dhc);
	drawCards(gdi, &m->m_talon, m_mo, m_h-m_mo-m_hcard, 2, 0);
}
