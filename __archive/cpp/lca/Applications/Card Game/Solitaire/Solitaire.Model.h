#pragma once

#include "CardGame.Model.Solitaire.h"
#include "Solitaire.Cards.h"

ImplementClass(SolitaireModel) : public SolitaireCardGameModel {
public:	
	SolitaireEcart m_ecart;

public:
	SolitaireModel();
	virtual ~SolitaireModel();

public:		
	virtual bool action(CardsRef pile, CardRef card);  

public:
	virtual void distrib();

public:
	virtual const char* getRulesDistrib();
	virtual const char* getRulesPlay();

};
