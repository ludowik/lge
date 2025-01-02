#pragma once

#include "CardGame.View.h"

ImplementClass(SpiderView) : public CardGameView {
public:
	SpiderView();
	
public:
	virtual void draw(GdiRef gdi);
	
};
