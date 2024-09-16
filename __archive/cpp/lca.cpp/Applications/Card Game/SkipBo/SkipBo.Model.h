#pragma once

#include "CardGame.Model.h"
#include "SkipBo.Cards.h"

ImplementClass(SkipBoPlayer) : public Object {
public:
	SkipBoStock m_stock;
	SkipBoMain  m_main;

	CardDeckList m_defausses;

public:
	SkipBoPlayer();
	virtual ~SkipBoPlayer();

};

ImplementClass(SkipBoModel) : public CardGameModel {
public:
	int m_nplayer;
	int m_iplayer;
	int m_iwin;

	bool m_firstPioche;

	SkipBoPlayer m_player[3];

	Talon m_talon;

	CardDeckList m_series;

public:
	SkipBoModel();
	virtual ~SkipBoModel();

public:
	virtual void create();
	virtual void distrib();

	virtual bool action(Cards* pile, CardRef card);
	virtual bool select(Cards* pile, CardRef card);

	virtual void pioche();

	virtual void defausse();

	virtual int automatic(bool user);
	virtual int automatic(Cards* from, CardRef card, bool user);

	virtual bool isGameWin();

public:
	void next_player();

	int play();

	int playcard(CardRef card);

	int playstock();
	int playmain();
	int playdefausse();

};