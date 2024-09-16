#pragma once

#include "Action.h"

ImplementClass(CardGameModel);

ImplementClass(CardGameAction) : public Action {
public:
	CardGameModel* m_model;
	
	CardRef m_card;
	
	CardsRef m_from;
	CardsRef m_to;
	
	bool m_show;
	
public:
	CardGameAction(ModelRef model, CardRef card, CardsRef from, CardsRef to, bool m_show);
	
};

ImplementClass(MoveListAction) : public CardGameAction {
public:
	MoveListAction(ModelRef model, CardRef card, CardsRef from, CardsRef to, bool show=true);
	
public:
	virtual void execute();
	virtual void undo();
	
};

ImplementClass(MoveCardAction) : public CardGameAction {
public:
	MoveCardAction(ModelRef model, CardRef card, CardsRef from, CardsRef to, bool show=true);
	
public:
	virtual void execute();
	virtual void undo();
	
};

ImplementClass(ReverseCardAction) : public CardGameAction {
protected:
	bool m_reverse;
	
public:
	ReverseCardAction(CardRef card, bool reverse, bool show=false);
	
	virtual void execute();
	virtual void undo();
	
};

ImplementClass(ReverseDeckAction) : public CardGameAction {
protected:
	bool m_reverse;
	
public:
	ReverseDeckAction(CardsRef deck, bool reverse, bool show=false);
	
public:
	virtual void execute();
	virtual void undo();
	
};
