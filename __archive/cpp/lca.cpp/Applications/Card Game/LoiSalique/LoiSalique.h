#pragma once

#include "CardGame.View.h"
#include "CardGame.Model.Solitaire.h"

ImplementClass(LoiSaliqueColonne) : public Cards {
public:
	LoiSaliqueColonne();
	virtual ~LoiSaliqueColonne();

public:
	virtual bool canMoveTo(Cards* pile, CardRef card);
	virtual bool canFollow(CardRef card1, CardRef card2);

};

ImplementClass(LoiSaliqueSeries) : public Cards {
public:
	LoiSaliqueSeries();
	virtual ~LoiSaliqueSeries();

public:
	virtual bool canMoveTo(Cards* pile, CardRef card);
	virtual bool canFollow(CardRef card1, CardRef card2);

};

ImplementClass(LoiSaliqueEcart) : public Cards {
public:
	LoiSaliqueEcart();
	virtual ~LoiSaliqueEcart();

public:
	virtual bool canMoveTo(Cards* pile, CardRef card);

};

ImplementClass(LoiSaliqueModel) : public SolitaireCardGameModel {
public:
	LoiSaliqueModel();
	virtual ~LoiSaliqueModel();

public:
	virtual bool action(Cards* pile, CardRef card);

public:
	virtual void create();
	virtual void distrib();
	virtual void pioche();
	virtual void pioche_proc();

	virtual int automatic(Cards* from, CardRef card, bool user);

	virtual bool isGameWin();

public:
	virtual const char* getRulesDistrib();
	virtual const char* getRulesPlay();

};

ImplementClass(LoiSaliqueView) : public CardGameView {
public:
	LoiSaliqueView();
	virtual ~LoiSaliqueView();

public:
	virtual bool touchBegin(int x, int y);

	virtual void draw(GdiRef gdi);

};
