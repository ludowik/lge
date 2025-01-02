#include "System.h"
#include "SkipBo.Model.h"
#include "SkipBo.View.h"

ApplicationObject<SkipBoView, SkipBoModel> appSkipBo("SkipBo", "SkipBo", "skipbo.png", 0, pageCardGame);

SkipBoView::SkipBoView() : CardGameView() {
	/* marge interne et externe */
	m_mo = 2;
	m_mi = 4;
	m_mc = 8;
}

SkipBoView::~SkipBoView() {
}

void SkipBoView::calc(GdiRef gdi, int ntas) {
	CardGameView::calc(gdi, ntas, 7);

	if ( m_w < m_h ) {
		m_wcard = (int) ( ( m_w - 2*m_mo - 2*m_mc - 4*m_mi ) / ( 7 ) );
		m_hcard = (int) ( ( m_wcard ) / ( m_pwh1 ) );
	}
	else { 
		m_wcard = (int) ( ( m_h - 2*m_mo - 2*m_mc - 4*m_mi ) / ( 7 ) );
		m_hcard = (int) ( ( m_wcard ) / ( m_pwh1 ) );
	}
}

#define xn(n) ((m_w-(n?n:1)*m_wcard-(n?n-1:0)*m_mi)/2)

void SkipBoView::draw(GdiRef gdi) {
	SkipBoModelRef model = (SkipBoModelRef)m_model;

	CardGameView::calc(gdi, 9, 7);

	int y = m_mo;

	SkipBoPlayerRef player = &model->m_player[0];
	int n = player->m_defausses.getCount();
	drawCardDeckList(gdi, &player->m_defausses, xn(n), y, m_wcard+m_mi, 0, 0, 0);

	y += m_mi+m_hcard;
	drawCards(gdi, &player->m_stock, m_mo, y, 0, 0);

	n = player->m_main.getCount();
	drawCards(gdi, &player->m_main, xn(n), y, m_wcard+m_mi, 0);

	drawCards(gdi, &model->m_talon, m_w-m_mo-m_wcard, y, 0, 0);

	y += m_mi+m_hcard+m_mo;
	n = model->m_series.getCount();
	drawCardDeckList(gdi, &model->m_series, xn(n), y, m_wcard+m_mi, 0, 0, 0);

	y += m_mo;
	for ( int iplayer = 1 ; iplayer < model->m_nplayer ; ++iplayer ) {
		y += m_mi+m_hcard;
		player = &model->m_player[iplayer];
		drawCards(gdi, &player->m_stock, m_mo, y,  0, 0);

		n = player->m_main.getCount();
		drawCards(gdi, &player->m_main , xn(n), y, m_wcard+m_mi, 0);

		y += m_mi+m_hcard;
		n = player->m_defausses.getCount();
		drawCardDeckList(gdi, &player->m_defausses, xn(n), y, m_wcard+m_mi, 0, 0, 0);
	}
}

void draw(CardRef card, CardsRef pile, int x, int y, int w, int h) {
	BitmapRef bitmap = card->m_select ? &card->m_bitmapSelected : &card->m_bitmap;
	if ( bitmap->isValid() == false ) {
		bitmap->create(w, h);

		if ( card->m_select ) {
			bitmap->drawBitmap("bgSelect", x, y, w, h);
		} else {
			bitmap->drawBitmap("bgUnselect", x, y, w, h);
		}

		Rect rect(x, y, w, h);

		int radius = max(w, h)/10;

		Color fg = card->m_select ? red : black;
		switch ( card->m_serie % 4 ) {
			case 0: fg = red  ; break;
			case 1: fg = blue ; break;
			case 2: fg = green; break;
			case 3: fg = black; break;
		}

		rect.inset(5, 5);

		int x1 = rect.x;
		int y1 = rect.y;

		int w1 = rect.w;
		int h1 = rect.h;

		int mw = w1 / 2;

		for ( int i = 0 ; i < mw ; ++i ) {
			bitmap->moveto(x1     , y1+mw-i);
			bitmap->lineto(x1+mw+i, y1+h1, white);

			bitmap->moveto(x1+i , y1);
			bitmap->lineto(x1+w1, y1+h1-i, white);
		}

		bitmap->roundrect(&rect, radius, fg);

		int size = w * 3 / 8;

		String s;
		if ( card->m_val == eJocker ) {
			s = "SB";
		} 
		else {
			s = card->m_val;
		}

		Rect r = bitmap->getTextSize(s.getBuf(), 0, size);
		bitmap->text(rect.x+(rect.w-r.w)/2, rect.y+(rect.h-r.h)/2, s.getBuf(), fg, 0, size);
	}
}

void SkipBoView::draw(GdiRef gdi, CardRef card, CardsRef pile, int x, int y, int w, int h, int wv, int hv) {
	if ( card && card->m_reverse == false ) {
		::draw(card, pile, 0, 0, m_wcard, m_hcard);
		BitmapRef bitmap = card->m_select ? &card->m_bitmapSelected : &card->m_bitmap;
		if ( bitmap->isValid() ) {
			gdi->copy(bitmap, x, y);
		}		
	}
	else {
		CardGameView::drawCard(gdi, card, pile, x, y, w, h);
	}
}
