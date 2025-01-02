#pragma once

#include "CardGame.Cards.h"

ImplementClass(SolitaireColonne) : public Cards {
public:
	SolitaireColonne();
	virtual ~SolitaireColonne();

public:
	virtual bool canMoveTo(CardsRef pile, CardRef card);
	virtual bool canFollow(CardRef card1, CardRef card2);

};

ImplementClass(SolitaireEcart) : public Cards {
public:
	SolitaireEcart();
	virtual ~SolitaireEcart();

public:
	virtual bool canMoveTo(CardsRef pile, CardRef card);

};
