#include "System.h"
#include "Solitaire.Model.h"
#include "Solitaire.View.h"
#include "CardGame.Action.h"

SolitaireModel::SolitaireModel() {
	m_ecarts.m_delete = false;

	for ( int i = 0 ; i < 7 ; ++i ) {
		m_piles.add(m_colonnes.add(new SolitaireColonne()));
	}
	
	m_piles.add(m_ecarts.add(&m_ecart));
	m_piles.add(&m_talon);
		
	m_ecart.m_npioche = 3;
}

SolitaireModel::~SolitaireModel() {
}

void SolitaireModel::distrib() {
	CardGameModel::distrib();
	
	Iterator iter = m_cards.getIterator();
	for ( int i = 0 ; i < m_colonnes.getCount() ; ++i ) {
		for ( int j = i ; j < m_colonnes.getCount() ; ++j ) {
			CardRef card = (CardRef)iter.removeNext();
			m_colonnes[j]->add(card);
			
			card->m_reverse = ( j == i ) ? false: true;
		}
	}
	
	m_talon.adds(&m_cards);
	m_talon.m_tourDeTalon = 4;
}

bool SolitaireModel::action(CardsRef pile, CardRef card) {
	if ( pile == &m_talon ) {
		if ( m_talon.getCount() > 0 ) {
			pioche();
		}
		else {
			talon();
		}
	}
	else if ( card && card->m_reverse && pile->getLast() == card ) {
		unselect();
		pushAction(new ReverseCardAction(card, false));
	}
	else {
		return CardGameModel::action(pile, card);
	}
	
	return true;
}

const char* SolitaireModel::getRulesDistrib() {
	return "Rechercher les regles du solitaire";
}

const char* SolitaireModel::getRulesPlay() {
	return "";
}
