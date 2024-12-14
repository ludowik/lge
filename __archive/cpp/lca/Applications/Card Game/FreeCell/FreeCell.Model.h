#pragma once

#include "CardGame.Model.Solitaire.h"
#include "FreeCell.Cards.h"

ImplementClass(FreeCellModel) : public SolitaireCardGameModel {
public:
	FreeCellModel();
	virtual ~FreeCellModel();

public:
	virtual void distrib();

	virtual void movelist(CardRef card, Cards* from, Cards* to, bool show=true);

	virtual const char* getRulesDistrib();
	virtual const char* getRulesPlay();

};
