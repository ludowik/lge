#pragma once

#include "CardGame.Cards.h"

ImplementClass(SolitaireCardGameModel);

ImplementClass(FreeCellColonne) : public Cards {
public:
	SolitaireCardGameModel* model;

public:
	FreeCellColonne();
	virtual ~FreeCellColonne();

public:
	virtual bool canMoveTo(Cards* pile, CardRef card);
	virtual bool canFollow(CardRef card1, CardRef card2);

};

ImplementClass(FreeCellEcart) : public Cards {
public:
	FreeCellEcart();
	virtual ~FreeCellEcart();

public:
	virtual bool canMoveTo(Cards* pile, CardRef card);

};