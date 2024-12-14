#pragma once

#include "CardGame.View.h"
#include "CardGame.Model.Solitaire.h"

ImplementClass(NapolitaineColonne) : public Cards {
public:
	NapolitaineColonne();
	virtual ~NapolitaineColonne();

public:
	virtual bool canMoveTo(Cards* pile, CardRef card);
	virtual bool canFollow(CardRef card1, CardRef card2);

};

ImplementClass(NapolitaineEcart) : public Cards {
public:
	NapolitaineEcart();
	virtual ~NapolitaineEcart();

public:
	virtual bool canMoveTo(Cards* pile, CardRef card);

};

ImplementClass(NapolitaineModel) : public SolitaireCardGameModel {
public:
	int indiceEcart;

public:
	NapolitaineModel();
	virtual ~NapolitaineModel();

	virtual bool action(Cards* pile, CardRef card);

public:
	virtual void distrib();
	virtual void pioche();

public:
	virtual const char* getRulesDistrib();
	virtual const char* getRulesPlay();

};

ImplementClass(NapolitaineView) : public CardGameView {
public:
	NapolitaineView();
	virtual ~NapolitaineView();

public:
	virtual void draw(GdiRef gdi);

};