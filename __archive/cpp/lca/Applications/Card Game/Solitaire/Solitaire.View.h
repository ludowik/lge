#pragma once

#include "CardGame.View.h"

ImplementClass(SolitaireView) : public CardGameView {
public:
	SolitaireView();
	virtual ~SolitaireView();

public:	
	virtual void draw(GdiRef gdi);

};
