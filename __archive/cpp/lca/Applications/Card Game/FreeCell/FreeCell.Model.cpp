#include "System.h"
#include "FreeCell.Model.h"
#include "FreeCell.View.h"

FreeCellModel::FreeCellModel() {
	for ( int i = 0 ; i < 8 ; ++i ) {
		FreeCellColonneRef colonne = new FreeCellColonne();
		colonne->model = this;
		m_piles.add(m_colonnes.add(colonne));
	}
	
	for ( int i = 0 ; i < 4 ; ++i ) {
		m_piles.add(m_ecarts.add(new FreeCellEcart()));
	}
	
	m_variante = 0;
}

FreeCellModel::~FreeCellModel() {
}

void FreeCellModel::distrib() {
	CardGameModel::distrib();
	
	Iterator iter = m_cards.getIterator();
	while ( iter.hasNext() ) {
		for ( int i = 0 ; i < m_colonnes.getCount() && iter.hasNext() ; ++i ) {
			CardRef card = (CardRef)iter.removeNext();
			card->m_reverse = false;			
			m_colonnes[i]->add(card);
		}
	}

	m_talon.m_tourDeTalon = 0;
}

void FreeCellModel::movelist(CardRef card, CardsRef from, CardsRef to, bool show) {
	int nbCards = from->getCount() - from->getIndex(card);  
	
	Cards cards;
	
	Iterator iter = from->getIterator();
	iter.end();
	
	for ( int i = 0 ; i < nbCards ; ++i ) {
		cards.add((CardRef)iter.previous());
	}
	
	int last = 0;
	
	CardsRef libre;
	
	for ( int i = 0 ; i < nbCards-1 ; ++i ) {
		CardRef current = cards[i];    
		libre = 0;
		
		for ( int j = 0 ; j < m_ecarts.getCount() ; ++j ) {
			CardsRef pPanel = m_ecarts[j];
			if ( pPanel->getCount() == 0 ) {
				libre = pPanel;
				break;
			}
		}
		
		if ( libre ) {
			CardGameModel::movecard(current, from, libre, show);
			continue;
		}
		
		for ( int j = 0 ; j < m_colonnes.getCount() ; ++j ) {
			CardsRef tas = m_colonnes[j];
			if ( tas->getCount() == 0
				&& tas != to ) {
				libre = tas;
				break;
			}
		}
		
		if ( libre ) {
			CardGameModel::movecard(current, from, libre, show);
			
			for ( int k = i-1 ; k < last-1 ; ++k ) {
				CardGameModel::movecard(cards[k], libre, show);
			}
			
			last = i+1;
		}
	}
	
	CardGameModel::movecard(cards[nbCards-1], to, show);
	
	for ( int i = nbCards-2 ; i > -1 ; --i  ) {
		movecard(cards[i], to, show);
	}
	
	cards.removeAll();
}

const char* FreeCellModel::getRulesDistrib() {
	return label("FreeCell", "RulesDistrib");
}

const char* FreeCellModel::getRulesPlay() {
	return label("FreeCell", "RulesPlay");
}
