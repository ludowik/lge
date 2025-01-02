#include "System.h"
#include "Card.h"
#include "CardGame.h"

int CardGameSerie::m_firstCardInSerie = Card::as;
int CardGameSerie::m_memeFamille = 1;

CardGameSerie::CardGameSerie() {
	m_class = "CardGameSerie";
	m_type = eEcart;
}

bool CardGameSerie::canMoveTo(CardsRef pile, CardRef card) {
	if ( getCount() > 0 ) {
		CardRef last = getLast();
		
		int nbCards = pile->getCount()-pile->getIndex(card);
		if ( nbCards == 1 ) {
			if ( canFollow(last, card) ) {
				return true;
			}
		}
	}
	else if ( card && card->m_val == m_firstCardInSerie ) {
		return true;
	}
	
	return false;
}

bool CardGameSerie::canFollow(CardRef card1, CardRef card2) {
	if ( m_memeFamille == 0 || card1->m_serie == card2->m_serie ) {
		if ( card1->m_val == card2->m_val-1 ) {
			return true;
		}
		else if ( m_firstCardInSerie != Card::as && card1->m_val == Card::roi && card2->m_val == Card::as ) {
			return true;
		}
	}
	return false;
}

Talon::Talon() {
	m_class = "Talon";
	m_type = eTalon;

	m_tourDeTalon = 4;
}

bool Talon::canMoveTo(CardsRef pile, CardRef card) {
	return false;
}
