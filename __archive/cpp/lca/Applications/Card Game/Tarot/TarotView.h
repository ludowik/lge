#pragma once

#include "CardGame.View.h"
#include "UserPanel.h"

ImplementClass(TarotView) : public CardGameView {
public:
	TarotView();
	
public:
	virtual void createUI();
	virtual void loadResource();
	
	virtual void draw(GdiRef gdi);
	virtual void draw(GdiRef gdi, UserPanel* panel);

};
