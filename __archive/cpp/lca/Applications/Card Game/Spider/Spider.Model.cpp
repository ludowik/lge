#include "System.h"
#include "Spider.h"

#include "CardGame.Action.h"

SpiderModel::SpiderModel() {
	for ( int i = 0 ; i < 10 ; ++i ) {
		m_piles.add(m_colonnes.add(new SpiderTas()));
	}
	m_piles.add(&m_talon);
}

void SpiderModel::create() {
	range();
	
	int mode = medium;
	
	switch ( mode ) {
		case easy: {
			for ( int i = 0 ; i < 8 ; ++i ) {
				m_cards.createSerie(ePique);
			}
			break;
		}
		case medium: {
			for ( int i = 0 ; i < 4 ; ++i ) {
				m_cards.createSerie(ePique);
				m_cards.createSerie(eCoeur);
			}
			break;
		}
		case hard: {
			for ( int i = 0 ; i < 2 ; ++i ) {
				m_cards.createSerie(ePique);
				m_cards.createSerie(eCoeur);
				m_cards.createSerie(eTrefle);
				m_cards.createSerie(eCarreau);
			}
			break;
		}
	}
	
	m_cards.mix();
}

void SpiderModel::distrib() {
	CardGameModel::distrib();
	
	int n = 44;
	
	Iterator iter = m_cards.getIterator();
	for ( int i = 0 ; i < n ; ) {
		for ( int j = 0 ; j < m_colonnes.getCount() && i < n ; ++i, ++j ) {
			CardRef card = (CardRef)iter.removeNext();
			m_colonnes[j]->add(card);
			
			card->m_reverse = true;
		}
	}
	
	m_talon.adds(&m_cards);
	m_talon.m_tourDeTalon = 4;
	
	distribNext();
}

void SpiderModel::distribNext() {
	unselect();
	
	Actions* actions = new Actions();
	
	Iterator iter = m_talon.getIterator();
	
	iter.end();
	for ( int i = 0 ; i < m_colonnes.getCount() ; ++i ) {
		CardRef card = (CardRef)iter.previous();
		
		actions->add(new MoveCardAction(this, card, &m_talon, m_colonnes[i]));
		actions->add(new ReverseCardAction(card, false));
	}
	
	pushAction(actions);
}

bool SpiderModel::action(CardsRef pile, CardRef card) {
	if ( pile == &m_talon ) {
		if ( m_talon.getCount() > 0 ) {
			distribNext();
		}
	}
	else if ( card
			 && card->m_reverse
			 && pile->getLast() == card ) {
		unselect();
		pushAction(new ReverseCardAction(card, false));
	}
	else {
		return CardGameModel::action(pile, card);
	}
	
	return true;
}

int SpiderModel::automatic(bool user) {
	int n = 0;
	
	for ( int i = 0 ; i < m_colonnes.getCount() ; ++i ) {
		CardRef card = m_colonnes[i]->getLast();
		if ( card
			&& card->m_reverse ) {
			card->m_reverse = false;
			n++;
		}
	}
	
	for ( int i = 0 ; i < m_colonnes.getCount() ; ++i ) {
		CardRef card = m_colonnes[i]->getLast();
		if ( card
			&& card->m_reverse == false
			&& card->m_val == Card::as ) {
			Iterator iter = m_colonnes[i]->getIterator();
			
			int index = Card::as;
			
			iter.end();
			while ( iter.hasPrevious() ) {
				CardRef card = (CardRef)iter.previous();
				if ( card->m_val != index ) {
					break;
				}
				if ( card->m_val == Card::roi ) {
					movelist(card, m_colonnes[i], &m_cards);
					break;
				}
				index++;
			}
		}
	}
	
	return n;
}

bool SpiderModel::isGameWin() {
	foreach ( CardsRef , pile , m_piles ) {
		if ( pile->getCount() ) {
			return false;
		}
	}
	return true;
}

const char* SpiderModel::getRulesDistrib() {
	return label("SpiderModel", "RulesDistrib");
}

const char* SpiderModel::getRulesPlay() {
	return label("SpiderModel", "RulesPlay");
}
