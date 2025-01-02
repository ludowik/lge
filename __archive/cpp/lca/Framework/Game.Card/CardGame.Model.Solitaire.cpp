#include "System.h"
#include "CardGame.h"
#include "CardGame.Model.Solitaire.h"

/* constructeur
 - pas de liberation automatique des cartes par les piles
 - creation des piles pour les couleurs
 */
SolitaireCardGameModel::SolitaireCardGameModel() {
	m_class = "SolitaireCardGameModel";

	CardGameSerie::m_firstCardInSerie = Card::as;
	CardGameSerie::m_memeFamille = 1;
	
	for ( int i = 0 ; i < 4 ; ++i ) {
		m_piles.add(m_series.add(new CardGameSerie()));
	}
	
	m_variante = 0;
}

SolitaireCardGameModel::~SolitaireCardGameModel() {
}

/* une pioche
 */
void SolitaireCardGameModel::pioche() {
	CardsRef ecart = m_ecarts.get(0);
	pioche(ecart->m_npioche);
}

/* une pioche standard de n cartes vers la zone d'ecart
 */
void SolitaireCardGameModel::pioche(int n) {
	Actions* actions = new Actions();
	
	CardsRef ecart = m_ecarts.get(0);
	
	/* On cache l'ecart */
	Iterator i1 = ecart->getIterator();
	i1.end();
	while ( i1.hasPrevious() ) {
		CardRef card = (CardRef)i1.previous();
		if ( !card->m_reverse ) {
			actions->add(new ReverseCardAction(card, true));
		}
		else {
			break;
		}
	}
	
	/* On deplace n cartes et on les rend visibles */	
	Iterator i2 = m_talon.getIterator();
	i2.end();
	for ( int i = 0 ; i < n && i2.hasPrevious() ; ++i ) {
		CardRef card = (CardRef)i2.previous();
		
		actions->add(new MoveCardAction(this, card, &m_talon, ecart));
		actions->add(new ReverseCardAction(card, false));        
	}
	
	pushAction(actions);
}

/* On retourne le talon
 */
void SolitaireCardGameModel::talon() {
	if ( m_talon.m_tourDeTalon == 0 ) {
		return;
	}
	
	m_talon.m_tourDeTalon--;
	
	m_score.stock();
	
	Actions* actions = new Actions(); {
		CardsRef ecart = m_ecarts.get(0);
		
		Iterator i1 = ecart->getIterator();
		i1.begin();
		while ( i1.hasNext() ) {
			CardRef card = (CardRef)i1.next();
			if ( card->m_reverse ) {
				actions->add(new ReverseCardAction(card, false));
			}
			else {
				break;
			}
		}
		
		i1.end();
		while ( i1.hasPrevious() ) {
			CardRef card = (CardRef)i1.previous();
			actions->add(new MoveCardAction(this, card, ecart, &m_talon, false));
		}
		
		actions->add(new ReverseDeckAction(&m_talon, true));
	}
	pushAction(actions);
}

/* Test si le joueur a gagne
 - toutes les series doivent être completes
 */
bool SolitaireCardGameModel::isGameWin() {
	foreach ( CardsRef , pile , m_series ) {
		if ( pile->getCount() < 13 ) {
			return false;
		}
	}
	return true;
}

/* test si le joueur ne peu plus jouer
 */
bool SolitaireCardGameModel::isGameOver() {
	return getNbMoves(0) ? false : true;
}

/* comptabilise le nombre de deplacements possibles
 */
int SolitaireCardGameModel::getNbMoves(CardsRef pile) {
	int n = getNbCardsToMove(pile) > 0 ? 1 : 0;
	
	if ( n == 0 && pile == 0 ) {
		// On passe les series
		int count = m_piles.getCount();
		for ( int i = m_series.getCount() ; i < count ; ++i ) {
			
			CardsRef pile_i = m_piles[i];
			if ( pile_i->getCount() > 0 ) {
				
				CardRef card = pile_i->getLast();
				for ( int j = 0 ; j < count ; ++j ) {
					
					CardsRef pile_j = m_piles[j];
					if ( i != j && pile_j->canMoveTo(pile_i, card) ) {
						n++;
					}
				}
			}
		}
	}
	
	if ( m_talon.m_tourDeTalon > 0 || m_talon.getCount() ) {
		n++;
	}
	
	return n;
}

/* comptabilise le nombre de deplacements possibles
 */
int SolitaireCardGameModel::getNbCardsToMove(CardsRef pile) {
	int n = 0;
	int m = 0;
	
	int count = m_ecarts.getCount();
	for ( int i = 0 ; i < count ; ++i ) {
		CardsRef ecart = m_ecarts[i];
		n += ecart->getCount() == 0 ? 1 : 0 ;
	}
	
	count = m_colonnes.getCount();
	for ( int i = 0 ; i < count ; ++i ) {
		CardsRef colonne = m_colonnes[i];
		if ( colonne != pile ) {
			m += colonne->getCount() == 0 ? 1 : 0 ;
		}
	}
	
	int nbMoves = n * ( m + 1 ) + 1;
	for ( int i = 1 ; i <= m ; ++i ) {
		nbMoves += i;
	}
	
	return nbMoves;
}

/* renvoie la prochaine carte necessaire pour completer une serie
 - recherche de la serie
 - renvoie de la valeur de la derniere carte + 1
 */
int SolitaireCardGameModel::getBestCardToUp(int serie) {
	foreach ( CardsRef ,  pile , m_series ) {
		CardRef card = pile->getLast();
		if ( card
			&& card->m_serie == serie ) {
			return card->m_val + 1;
		}
	}
	return 1;
}

/* regles automatiques
 - parcours des piles
 - tests si la derniere carte peut monter sur une serie
 - coche des prochaines cartes pour chaque serie dans le jeu
 */
int SolitaireCardGameModel::automatic(bool user) {
	if ( !m_canAutomate ) {
		return 0;
	}
	
	int nbMove = 0;
	int n = 0;
	
	startSubActions();
	
	do {
		n = 0;
		
		foreach ( CardsRef ,  pile , m_piles ) {
			if ( !pile->isKindOf("CardGameSerie") ) {
				CardRef card = pile->getLast();
				if ( card && card->m_reverse == false ) {
					n += automatic(pile, card, user);
					nbMove += n;
				}
			}
		}
	}
	while ( n );
	
	endSubActions();
	
	return nbMove;
}

/* regles automatiques
 - parcours des series
 - test si la carte peut monter sur une serie
 -> ok => deplace la carte
 -> memorise l'action
 -> reinitialise les parametres
 -> reinitialise la selection si c'etait la carte selectionee9
 */
int SolitaireCardGameModel::automatic(CardsRef from, CardRef card, bool user) {
	Actions* actions = new Actions();

	int n = 0;
	
	if ( user ) {
		/* Ecart automatique d'une carte sur une serie */ 
		foreach ( CardsRef, serie, m_series ) {
			if ( serie->canMoveTo(from, card) ) {
				actions->add(new MoveCardAction(this, card, from, serie, false));
				
				card->m_select = false;
				card->m_reverse = false;    
				
				if ( m_cardSelect == card ) {
					m_pileSelect = 0;
					m_cardSelect = 0;
				}
				
				n++;				
				break;
			}
		}
	}
	
	/* Retournement automatique de la premiere carte (côte utilisateur) d'une colonne */
	foreach ( CardsRef, colonne, m_colonnes ) {
		if ( colonne->getCount() ) {
			CardRef last = colonne->getLast();
			if ( last->m_reverse ) {
				actions->add(new ReverseCardAction(last, false));
				n++;
			}
		}
	}
	
	/* La derniere carte d'un ecart doit toujours être visible */
	foreach ( CardsRef, ecart, m_ecarts ) {
		if ( ecart->getCount() ) {
			CardRef last = ecart->getLast();
			if ( last->m_reverse ) {
				actions->add(new ReverseCardAction(last, false));
				n++;
			}
			break;
		}
	}
	
	pushAction(actions);
	
	return n;
}

/* test une suite de deux cartes
 */
bool suiteCarte(CardRef card1, CardRef card2, int type) {
	switch ( type ) {
		case eAlterneCouleur: {
			/* inversion de couleur
			 */
			if (   card1->m_reverse == false
				&& card2->m_reverse == false
				&& abs( card1->m_serie - card2->m_serie ) % 2 == 1
				&& card1->m_val == card2->m_val+1 ) {
				return true;
			}
			break;
		}
		case eAlterneCouleurEnBoucle: {
			/* inversion de couleur et Roi sur As possible
			 */
			if (   card1->m_reverse == false
				&& card2->m_reverse == false
				&& abs( card1->m_serie - card2->m_serie ) % 2 == 1
				&& ( card1->m_val == card2->m_val+1 || ( card1->m_val == Card::as && card2->m_val == Card::roi ) ) ) {
				return true;
			}
			break;
		}
		case eMemeCouleur: {
			/* même couleur
			 */
			if (   card1->m_reverse == false
				&& card2->m_reverse == false
				&& abs( card1->m_serie - card2->m_serie ) % 2 == 0
				&& card1->m_val == card2->m_val+1 ) {
				return true;
			}
			break;
		}
		case eMemeSerie: {
			/* même famille
			 */
			if (   card1->m_reverse == false
				&& card2->m_reverse == false
				&& card1->m_serie == card2->m_serie
				&& card1->m_val == card2->m_val+1 ) {
				return true;
			}
			break;;
		}
		case eSuite: {
			/* suite et on se fout de la couleur ou de la famille
			 */
			if (   card1->m_reverse == false
				&& card2->m_reverse == false
				&& card1->m_val == card2->m_val+1 ) {
				return true;
			}
			break;;
		}
	}
	
	return false;
}
