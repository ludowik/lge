#pragma once

#include "CardGame.View.h"
#include "CardGame.Model.Solitaire.h"

ImplementClass(SoixanteQuatreColonne) : public Cards {
public:
	SoixanteQuatreColonne();
	virtual ~SoixanteQuatreColonne();

public:
	virtual bool canMoveTo(Cards* pile, CardRef card);
	virtual bool canFollow(CardRef card1, CardRef card2);

};

ImplementClass(SoixanteQuatreModel) : public SolitaireCardGameModel {
public:
	Talon m_talon;

public:
	SoixanteQuatreModel();
	virtual ~SoixanteQuatreModel();

	virtual bool action(Cards* pile, CardRef card);

public:
	virtual void create();
	virtual void distrib();
	virtual void pioche();

public:
	virtual const char* getRulesDistrib();
	virtual const char* getRulesPlay();

};

ImplementClass(SoixanteQuatreView) : public CardGameView {
public:
	SoixanteQuatreView();
	virtual ~SoixanteQuatreView();

public:
	virtual void calc(GdiRef gdi, int nw, int nh);

	virtual void draw(GdiRef gdi);

};
