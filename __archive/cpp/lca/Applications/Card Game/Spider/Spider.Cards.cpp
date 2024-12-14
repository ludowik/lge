#include "System.h"
#include "Spider.h"

bool SpiderTas::canMoveTo(CardsRef pile, CardRef card) {
	if ( getCount() > 0 ) {
		if ( canMoveTo(getLast(), card) ) {
			return true;
		}
	}
	else {
		return true;
	}
	
	return false;
}

bool SpiderTas::canMoveTo(CardRef card1, CardRef card2) {
	if ( card1->m_reverse == false && card1->m_val == ( card2->m_val + 1 ) ) {
		return true;
	}
	
	return false;
}

bool SpiderTas::canFollow(CardRef card1, CardRef card2) {
	if ( suiteCarte(card1, card2, eMemeCouleur) ) {
		return true;
	}
	return false;
}
