#pragma once

#include "CardGame.Cards.h"
#include "CardGame.Model.h"

ImplementClass(SolitaireCardGameModel) : public CardGameModel {
public:
	CardDeckList m_series;
	CardDeckList m_colonnes;
	CardDeckList m_ecarts;
	
	int m_variante;
	
public:
	SolitaireCardGameModel();
	virtual ~SolitaireCardGameModel();
	
public:
	virtual void pioche();
	virtual void pioche(int n);
	
	virtual void talon();
	
public:
	virtual bool isGameWin();
	virtual bool isGameOver();
	
	virtual int getNbMoves(CardsRef pile);
	virtual int getNbCardsToMove(CardsRef pile);
	
	virtual int getBestCardToUp(int serie);
	
	virtual int automatic(bool user);
	virtual int automatic(CardsRef from, CardRef card, bool user);
	
};

enum {
	eAlterneCouleur,
	eAlterneCouleurEnBoucle,
	eMemeCouleur,
	eMemeSerie,
	eSuite
};

bool suiteCarte(CardRef card1, CardRef card2, int type);
