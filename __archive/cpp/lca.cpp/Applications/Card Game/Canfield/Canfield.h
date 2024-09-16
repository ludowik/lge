#pragma once

#include "CardGame.View.h"
#include "CardGame.Model.Solitaire.h"

ImplementClass(CanfieldColonne) : public Cards {
public:
	CanfieldColonne();
	virtual ~CanfieldColonne();

public:
	virtual bool canMoveTo(Cards* pile, CardRef card);
	virtual bool canFollow(CardRef card1, CardRef card2);

};

ImplementClass(CanfieldReserve) : public Cards {
public:
	CanfieldReserve();
	virtual ~CanfieldReserve();

public:
	virtual bool canMoveTo(Cards* pile, CardRef card);
	virtual bool canFollow(CardRef card1, CardRef card2);

};

ImplementClass(CanfieldEcart) : public Cards {
public:
	CanfieldEcart();
	virtual ~CanfieldEcart();

public:
	virtual bool canMoveTo(Cards* pile, CardRef card);

};

ImplementClass(CanfieldModel) : public SolitaireCardGameModel {
public:
	CanfieldEcart m_ecart;

	CanfieldReserve m_reserve;

public:
	CanfieldModel();
	virtual ~CanfieldModel();

	virtual bool action(Cards* pile, CardRef card);

public:
	virtual void distrib();

	virtual bool load();

public:
	virtual const char* getRulesDistrib();
	virtual const char* getRulesPlay();

};

ImplementClass(CanfieldView) : public CardGameView {
public:
	CanfieldView();
	virtual ~CanfieldView();

public:
	virtual void draw(GdiRef gdi);

};