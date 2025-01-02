#pragma once

#include "CardGame.View.h"
#include "CardGame.Model.Solitaire.h"

ImplementClass(SolitaireBisColonne) : public Cards {
public:
	SolitaireBisColonne();
	virtual ~SolitaireBisColonne();
	
public:
	virtual bool canMoveTo(Cards* pile, Card* card);
	virtual bool canFollow(Card* card1, Card* card2);

};

ImplementClass(SolitaireBisEcart) : public Cards {
public:
	SolitaireBisEcart();
	virtual ~SolitaireBisEcart();

public:
	virtual bool canMoveTo(Cards* pile, Card* card);

};

ImplementClass(SolitaireBisModel) : public SolitaireCardGameModel {
public:
	SolitaireBisEcart m_ecart;

public:
	SolitaireBisModel();
	virtual ~SolitaireBisModel();

public:
	virtual bool action(Cards* pile, Card* card);

public:
	virtual void distrib();

public:
	virtual const char* getRulesDistrib();
	virtual const char* getRulesPlay();

};

ImplementClass(SolitaireBisView) : public CardGameView {
public:
	SolitaireBisView();
	virtual ~SolitaireBisView();

public:
	virtual void draw(GdiRef gdi);

};