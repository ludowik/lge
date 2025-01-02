#pragma once

#include "CardGame.Model.h"
#include "CardGame.View.h"

ImplementClass(SkipBoView) : public CardGameView {
public:
	SkipBoView();
	virtual ~SkipBoView();

public:
	virtual void calc(GdiRef gdi, int ntas);

	virtual void draw(GdiRef gdi);
	virtual void draw(GdiRef gdi, CardRef card, CardsRef pile, int x, int y, int w, int h, int wv, int hv);

};
