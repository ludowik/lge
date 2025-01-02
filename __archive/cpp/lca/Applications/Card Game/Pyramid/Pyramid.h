#pragma once

#include "CardGame.View.h"
#include "CardGame.Model.Solitaire.h"

ImplementClass(PyramidCards) : public Cards {
public:
	PyramidCards();
	virtual ~PyramidCards();

public:
	int l;
	int c;

};

ImplementClass(PyramidModel) : public SolitaireCardGameModel {
public:
	Cards m_ecart;

	PyramidCardsRef m_pyramid[28];

public:
	PyramidModel();
	virtual ~PyramidModel();

public:		
	virtual bool action(::Cards* pile, CardRef card);
	virtual bool select(::Cards* pile, CardRef card);

	virtual bool selectable(::Cards* pile, CardRef card);

	virtual int automatic(bool user);

	virtual bool isGameOver();
	virtual bool isGameWin();

public:
	virtual void distrib();
	virtual void pioche();
	virtual void talon();

public:
	virtual const char* getRulesDistrib();
	virtual const char* getRulesPlay();

};

ImplementClass(PyramidView) : public CardGameView {
public:
	PyramidView();
	virtual ~PyramidView();

public:
	virtual void draw(GdiRef gdi);

};
