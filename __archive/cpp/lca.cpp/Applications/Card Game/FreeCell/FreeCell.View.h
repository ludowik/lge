#pragma once

#include "CardGame.View.h"
#include "FreeCell.Model.h"

ImplementClass(FreeCellView) : public CardGameView {
public:
	FreeCellView();
	virtual ~FreeCellView();

public:
	virtual void draw(GdiRef gdi);

};
