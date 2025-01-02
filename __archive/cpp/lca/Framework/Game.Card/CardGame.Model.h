#pragma once

#include "CardGame.Cards.h"
#include "Game.Model.h"

// TODO : gestion du niveau
enum eLevel {
	easy=0,
	medium,
	hard
};

ImplementClass(CardGameModel) : public ModelGame {
public:
	Cards m_cards;
	
	CardDeckList m_piles;
	
	Talon m_talon;
	
	CardsRef m_pileSelect;
	CardRef m_cardSelect;
	
	bool m_canAutomate;
	
public:
	CardGameModel();
	virtual ~CardGameModel();
	
public:
	virtual void init();
	
	virtual void create();
	virtual void release();
	
	virtual void distrib();
	virtual void range();
	
	virtual bool action();
	virtual bool action(CardsRef pile, CardRef card);
	virtual bool select(CardsRef pile, CardRef card);
	
	virtual void unselect();
	virtual void uncheck();
	
	virtual CardsRef getPile(CardRef card);
	
	virtual void movecard(CardRef card, CardsRef to, bool show=true);
	virtual void movelist(CardRef card, CardsRef to, bool show=true);
	
	virtual void movecard(CardRef card, CardsRef from, CardsRef to, bool show=true);
	virtual void movelist(CardRef card, CardsRef from, CardsRef to, bool show=true);
	
	virtual int automatic(bool user);
	virtual int automatic(CardsRef from, CardRef card, bool user);
	
	virtual bool idle();
	
public:
	virtual bool save(File& file);
	virtual bool load(File& file);
	
	virtual CardRef newCard();
	
public:
	virtual bool onHelp(ObjectRef obj);
	
	virtual const char* getRulesDistrib();
	virtual const char* getRulesPlay();
	
};
