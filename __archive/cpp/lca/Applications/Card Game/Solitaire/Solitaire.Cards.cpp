#include "System.h"
#include "Solitaire.Cards.h"
#include "Solitaire.Model.h"

SolitaireColonne::SolitaireColonne() {
}

SolitaireColonne::~SolitaireColonne() {
}

bool SolitaireColonne::canMoveTo(CardsRef pile, CardRef card) {
	if ( getCount() > 0 ) {
		if ( canFollow(getLast(), card) ) {
			return true;
		}
	}
	else if ( card->m_val == Card::roi ) {
		return true;
	}
	
	return false;
}

bool SolitaireColonne::canFollow(CardRef card1, CardRef card2) {
	if ( suiteCarte(card1, card2, eAlterneCouleur) ) {
		return true;
	}
	return false;
}

SolitaireEcart::SolitaireEcart() {
}

SolitaireEcart::~SolitaireEcart() {
}

bool SolitaireEcart::canMoveTo(CardsRef pile, CardRef card) {
	return false;
}
