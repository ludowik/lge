#include "System.h"
#include "SkipBo.Cards.h"
#include "SkipBo.Model.h"

#include "CardGame.Action.h"

SkipBoCards::SkipBoCards() {
	m_iplayer = -1;
}

SkipBoCards::~SkipBoCards() {
}

SkipBoStock::SkipBoStock() {
	m_type = eStock;
}

SkipBoStock::~SkipBoStock() {
}

bool SkipBoStock::canMoveTo(CardsRef pile, CardRef card) {
	return false;
}

bool SkipBoStock::automatic(bool user) {
	CardRef card = getLast();
	if ( card
		&& card->m_reverse ) {
		CardGameModel* model = (CardGameModel*)m_model;
		model->pushAction(new ReverseCardAction(card, false));
		return true;
	}
	
	return false;
}

SkipBoMain::SkipBoMain() {
	m_type = eMain;
}

SkipBoMain::~SkipBoMain() {
}

bool SkipBoMain::canMoveTo(CardsRef pile, CardRef card) {
	return false;
}

SkipBoDefausse::SkipBoDefausse() {
	m_type = eDefausse;
}

SkipBoDefausse::~SkipBoDefausse() {
}

bool SkipBoDefausse::canMoveTo(CardsRef pile, CardRef card) {
	if ( ((SkipBoCards*)pile)->m_iplayer == m_iplayer && ((SkipBoCards*)pile)->m_type == eMain ) {
		return true;
	}
	return false;
}

SkipBoSerie::SkipBoSerie() {
	m_type = eEcart;
}

SkipBoSerie::~SkipBoSerie() {
}

bool SkipBoSerie::canMoveTo(CardsRef pile, CardRef card) {
	if ( getCount() == card->m_val-1 ) {
		return true;
	}
	else if ( card->m_val == eJocker ) {
		return true;
	}
	
	return false;
}

bool SkipBoSerie::automatic(bool user) {
	if ( getCount() == 12 ) {
		CardGameModel* model = (CardGameModel*)m_model;
		model->pushAction(new MoveListAction(model, getFirst(), this, &model->m_cards));
		return true;
	}
	return false;
}

SkipBoTalon::SkipBoTalon() {
	m_type = ePioche;
}

SkipBoTalon::~SkipBoTalon() {
}

bool SkipBoTalon::canMoveTo(CardsRef pile, CardRef card) {
	return false;
}

bool SkipBoTalon::automatic(bool user) {
	if ( getCount() == 0 ) {
		CardGameModelRef model = (CardGameModelRef)m_model;

		model->m_cards.mix();
		model->pushAction(new MoveListAction(model, model->m_cards.getFirst(), &model->m_cards, this));

		return true;
	}
	return false;
}
