#include "System.h"
#include "CardGame.Animation.h"
#include "Pyramid.h"
#include "CardGame.View.h"
#include "CardGame.Model.Solitaire.h"
#include "CardGame.Action.h"

ApplicationObject<PyramidView, PyramidModel> appPyramid("Pyramid", "Pyramid", 0, 0, pageCardGame);

PyramidCards::PyramidCards() {
}

PyramidCards::~PyramidCards() {
}

PyramidModel::PyramidModel() {
	m_ecarts.m_delete = false;
	
	int n = 0;
	for ( int l = 0 ; l < 7 ; ++l ) {
		for ( int c = 0 ; c < l+1 ; ++c, ++n ) {
			m_pyramid[n] = new PyramidCards();
			m_pyramid[n]->l = l;
			m_pyramid[n]->c = c;
			
			m_piles.add(m_colonnes.add(m_pyramid[n]));
		}
	}
	
	m_piles.add(&m_ecart);
	m_piles.add(&m_talon);
}

PyramidModel::~PyramidModel() {
}

bool PyramidModel::action(::CardsRef pile, CardRef card) {
	// Un roi
	if ( card && card->m_val == Card::roi && selectable(pile, card) ) {
		pushAction(new MoveCardAction(this, card, pile, &m_cards));
		unselect();
	}
	// On retourne le talon
	else if ( pile == &m_talon && m_talon.getCount() == 0 ) {
		talon();
	}
	// On pioche
	else if ( ( m_cardSelect == 0 || m_pileSelect == &m_talon ) && pile == &m_talon ) {
		pushAction(new MoveCardAction(this, card, &m_talon, &m_ecart));
		unselect();
	}
	else if ( m_cardSelect && m_cardSelect != card ) {
		// Un  couple qui fait 13
		if ( card && ( card->m_val + m_cardSelect->m_val ) == 13 && selectable(pile, card) ) {
			Actions* actions = new Actions();
			actions->add(new MoveCardAction(this, card, pile, &m_cards));
			actions->add(new MoveCardAction(this, m_cardSelect, m_pileSelect, &m_cards));
			pushAction(actions);
			unselect();
		}
		else {
			unselect();
			select(pile, card);
		}
	}
	else {
		unselect();
		select(pile, card);
	}
	
	return true;
}

bool PyramidModel::select(::CardsRef pile, CardRef card) {
	if ( selectable(pile, card) ) {
		return SolitaireCardGameModel::select(pile, card);
	}
	
	return false;
}

bool PyramidModel::selectable(::CardsRef pile, CardRef card) {
	PyramidCardsRef cards = (PyramidCardsRef)pile;
	
	if ( pile == &m_talon || pile == &m_ecart ) {
		return true;
	}
	
	if ( cards && cards->l < 6 ) {
		int n = 0;
		for ( int l = 0 ; l <= cards->l ; ++l ) {
			n += l+1;
		}
		n += cards->c;
		
		if ( m_pyramid[n]->getCount() || m_pyramid[n+1]->getCount() ) {
			return false;
		}
	}
	
	return card?true:false;
}

int PyramidModel::automatic(bool user) {
	return 0;
}

void PyramidModel::distrib() {
	CardGameModel::distrib();
	
	CardRef card;
	
	Iterator iter = m_cards.getIterator();
	
	for ( int i = 0 ; i < 28 ; ++i ) {
		card = (CardRef)iter.removeNext();
		card->m_reverse = false;
		
		m_pyramid[i]->add(card);
	}
	
	while ( iter.hasNext() ) {
		card = (CardRef)iter.removeNext();
		card->m_reverse = false;
		
		m_talon.add(card);
	}

	m_talon.m_tourDeTalon = 2;
}

void PyramidModel::pioche() {
}

void PyramidModel::talon() {
	if ( m_talon.m_tourDeTalon == 0 ) {
		return;
	}
	
	m_talon.m_tourDeTalon--;

	Actions* actions = new Actions();
	
	Iterator i = m_ecart.getIterator();
	i.end();
	while ( i.hasPrevious() ) {
		CardRef card = (CardRef)i.previous();
		actions->add(new MoveCardAction(this, card, &m_ecart, &m_talon, false));
	}
	
	pushAction(actions);
}

bool PyramidModel::isGameOver() {
	int nb = sizeof(m_pyramid)/sizeof(PyramidCardsRef);
	
	fromto(int, i, 0, nb+2) {
		CardsRef pile1 = 0;
		CardRef card1 = 0;

		if ( i < nb ) {
			if ( m_pyramid[i]->getCount() == 1 ) {
				pile1 = m_pyramid[i];
				card1 = m_pyramid[i]->getFirst();
			}
		}
		else if ( i == nb ) {
			pile1 = &m_talon;
			card1 = m_talon.getLast();
		}
		else if ( i == nb + 1 ) {
			pile1 = &m_ecart;
			card1 = m_ecart.getLast();
		}

		if ( pile1 && card1 && selectable(pile1, card1) ) {
			if ( card1->m_val == Card::roi ) {
				return false;
			}

			fromto(int, j, 0, nb) {
				if ( i!= j && m_pyramid[j]->getCount() == 1 ) {
					CardsRef pile2 = m_pyramid[j];
					CardRef card2 = m_pyramid[j]->getFirst();

					if ( selectable(pile2, card2) ) {
						if ( card1->m_val + card2->m_val == 13 ) {
							return false;
						}
					}
				}
			}
		}
	}

	if ( m_talon.m_tourDeTalon ) {
		return false;
	}

	if ( m_talon.getCount() ) {
		return false;
	}

	return true;
}

/* Il existe plusieurs variantes de Pyramide, qui se distinguent par leur fin.
 - Variante 1 : Il faut marier toutes les cartes de la pyramide
 - Variante 2 : Il faut marier toutes les cartes de la pyramide, en ne retournant qu'une seule fois le talon
 - Variante 3 : Il faut marier toutes les cartes de la pyramide, ainsi que du talon et de l'ecart
 */
bool PyramidModel::isGameWin() {
	if ( m_pyramid[0]->getCount() == 0 ) {
		if ( m_variante == 0 ) {
			return true;
		}
		if ( m_talon.m_tourDeTalon > 0 ) {
			if ( m_variante == 1 ) {
				return true;
			}
			if ( m_talon.getCount() == 0 && m_ecart.getCount() == 0 ) {
				if ( m_variante == 3 ) {
					return true;
				}				
			}
		}
	}
	
	return false;
}

const char* PyramidModel::getRulesDistrib() {
	return label("Pyramid", "RulesDistrib");
}

const char* PyramidModel::getRulesPlay() {
	return label("Pyramid", "RulesPlay");
}

PyramidView::PyramidView() : CardGameView() {
}

PyramidView::~PyramidView() {
}

void PyramidView::draw(GdiRef gdi) {
	PyramidModelRef model = (PyramidModelRef)m_model;
	
	calc(gdi, 7, 4);
	
	int y = m_mo;	
	if ( System::Media::getOrientation() == orientationPortrait ) {
		y += m_hcard;
	}
	
	if ( m_right2left ) {
		drawCards(gdi, &model->m_talon, m_w-m_mo-m_wcard, y, 0, 0);
		drawCards(gdi, &model->m_ecart, m_w-m_mo-m_wcard, y+m_hcard+m_mi, 0, 0, 0, 0);
	}
	else {
		drawCards(gdi, &model->m_talon, m_mo, y, 0, 0);
		drawCards(gdi, &model->m_ecart, m_mo, y+m_hcard+m_mi, 0, 0, 0, 0);
	}
	
	int n = 0;
	
	for ( int l = 0 ; l < 7 ; ++l ) {
		int x = (int)( m_w/2. - ( l * ( m_wcard + m_mi ) + m_wcard )/2.);
		
		for ( int c = 0 ; c < l+1 ; ++c, ++n ) {
			int i = m_right2left ? n+l-c-c : n;
			if ( model->m_pyramid[i]->getCount() ) {
				drawCards(gdi, model->m_pyramid[i], x, y, m_wcard, m_hcard);
			}
			else {
				model->m_pyramid[n]->m_rect = Rect();
			}
			x += m_wcard+m_mi;
		}
		
		y += m_hcard/2;
	}

	if ( m_animation ) {
		AnimateCardRef animation = (AnimateCardRef)m_animation;
		
		CardsRef cards = &animation->m_cards;

		int x = cards->m_rect.x;
		int y = cards->m_rect.y;

		drawCards(gdi, cards, -x, -y, m_wcard, m_hcard);
	}
}
