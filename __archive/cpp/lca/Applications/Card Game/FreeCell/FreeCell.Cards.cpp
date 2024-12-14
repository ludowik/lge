#include "System.h"
#include "FreeCell.Cards.h"
#include "FreeCell.Model.h"

FreeCellColonne::FreeCellColonne() {
}

FreeCellColonne::~FreeCellColonne() {
}

bool FreeCellColonne::canMoveTo(CardsRef pile, CardRef card) {
	FreeCellModelRef model = (FreeCellModelRef)m_model;
	
	CardRef last = getLast();
	
	int nbCards = pile->getCount() - pile->getIndex(card);
	
	int nbCardsToMove = model->getNbCardsToMove(this);
	
	if ( nbCards == 1 || nbCards <= nbCardsToMove ) {
		if ( getCount() > 0 ) {
			if ( canFollow(last, card) ) {
				return true;
			}
		}
		else {
			return true;
		}
	}
	
	return false;
}

bool FreeCellColonne::canFollow(CardRef card1, CardRef card2) {
	if ( suiteCarte(card1, card2, model->m_variante==0?eAlterneCouleur:eMemeSerie) ) {
		return true;
	}
	return false;
}

FreeCellEcart::FreeCellEcart() {
}

FreeCellEcart::~FreeCellEcart() {
}

bool FreeCellEcart::canMoveTo(CardsRef pile, CardRef card) {
	if ( getCount() == 0 ) {
		int nbCards = pile->getCount() - pile->getIndex(card);
		if ( nbCards == 1 ) {
			return true;
		}
	}
	
	return false;
}
