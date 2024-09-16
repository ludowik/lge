#pragma once

#include "Spider.Cards.h"
#include "CardGame.Model.Solitaire.h"

ImplementClass(SpiderModel) : public SolitaireCardGameModel {
public:
	CardDeckList m_colonnes;
	
public:
	SpiderModel();
	
public:
	virtual void create();
	virtual void distrib();
	
	void distribNext();
	
	virtual bool action(Cards* pile, CardRef card);
	
	virtual int automatic(bool user);
	
	virtual bool isGameWin();
	
	virtual const char* getRulesDistrib();
	virtual const char* getRulesPlay();
		
};
