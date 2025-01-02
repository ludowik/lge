#include "System.h"
#include "CardGame.Animation.h"

AnimateCard::AnimateCard(View* view, CardRef card, CardsRef from, CardsRef to) : Animation(view) {
	m_cards.m_delete = false;

	m_firstCard = card;

	to = to?to:from;

	Rect rect;
	if ( to->getCount() ) {
		rect = to->getNextPosition();
	}
	else {
		rect = to->m_rect;
	}

	m_from = from;
	m_to = to;

	Point fromPos(card->m_rect.x, card->m_rect.y);
	Point toPos  (rect.x, rect.y);

	m_line = new Line(&fromPos, &toPos, 0, minmax(get_view()->g_frameRateReal, 4, 12));
	
	m_iter = 0;
}

AnimateCard::~AnimateCard() {
	if ( m_line )
		delete m_line;
	if ( m_iter )
		delete m_iter;
}

bool AnimateCard::initAnimation() {
	Animation::initAnimation();

	if ( !m_iter ) {
		m_cards.move(m_firstCard, m_from);
		m_iter = m_line->getIterator();
	}
	return true;
}

bool AnimateCard::iterAnimation() {
	Animation::iterAnimation();

	if ( m_iter && m_iter->hasNext() ) 		{     
		PointRef point = (PointRef)m_iter->next();

		m_cards.m_rect.x = (int)point->x;
		m_cards.m_rect.y = (int)point->y;

		return true;
	}

	return false;
}

bool AnimateCard::finishAnimation() {
	Animation::finishAnimation();

	m_to->move(m_firstCard, &m_cards);

	delete m_iter;
	m_iter = 0;

	return true;
}

bool AnimateCard::resetAnimation() {
	Animation::resetAnimation();

	m_from->move(m_firstCard, &m_cards);
	
	delete m_iter;
	m_iter = 0;
	
	return true;
}
