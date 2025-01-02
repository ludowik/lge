#pragma once

#include "Animation.h"
#include "Card.h"

ImplementClass(AnimateCard) : public Animation {
public:
	CardRef m_firstCard;
	
	Cards m_cards;

	CardsRef m_from;
	CardsRef m_to;

	LineRef m_line;

	IteratorRef m_iter;

public:
	AnimateCard(View* view, CardRef card, CardsRef from, CardsRef to);
	virtual ~AnimateCard();

public:
	virtual bool initAnimation();
	virtual bool iterAnimation();
	virtual bool finishAnimation();
	
public:
	virtual bool resetAnimation();
	
};
