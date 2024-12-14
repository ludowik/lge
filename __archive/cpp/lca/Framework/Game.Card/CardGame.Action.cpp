#include "System.h"
#include "CardGame.h"

CardGameAction::CardGameAction(ModelRef model, CardRef card, CardsRef from, CardsRef to, bool show) {
	m_class = "CardGameAction";
	
	m_model = (CardGameModel*)model;
	
	m_card = card;
	m_from = from;
	m_to = to;
	m_show = show;
}

MoveListAction::MoveListAction(ModelRef model, CardRef card, CardsRef from, CardsRef to, bool show) : CardGameAction(model, card, from, to, show) {
}

void MoveListAction::execute() {
	m_to->move(m_card, m_from);
}

void MoveListAction::undo() {
	m_from->move(m_card, m_to);
}

MoveCardAction::MoveCardAction(ModelRef model, CardRef card, CardsRef from, CardsRef to, bool show) : CardGameAction(model, card, from, to, show) {
}

void MoveCardAction::execute() {
	m_model->movecard(m_card, m_from, m_to, m_show);
}

void MoveCardAction::undo() {
	m_model->movecard(m_card, m_to, m_from, false);
}

ReverseCardAction::ReverseCardAction(CardRef card, bool reverse, bool show) : CardGameAction(0, card, 0, 0, show) {
	m_reverse = reverse;
}

void ReverseCardAction::execute() {
	m_card->m_reverse = m_reverse;
}

void ReverseCardAction::undo() {
	m_card->m_reverse = !m_reverse;
}

ReverseDeckAction::ReverseDeckAction(CardsRef deck, bool reverse, bool show) : CardGameAction(0, 0, 0, deck, show) {
	m_reverse = reverse;
}

void ReverseDeckAction::execute() {
	m_to->reverse(m_reverse);
}

void ReverseDeckAction::undo() {
	m_to->reverse(!m_reverse);
}
