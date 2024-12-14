#include "System.h"
#include "Model.h"
#include "SoixanteQuatre.h"
#include "CardGame.Action.h"

ApplicationObject<SoixanteQuatreView, SoixanteQuatreModel> appSoixanteQuatre("SoixanteQuatre", "SoixanteQuatre", 0, 0, pageCardGame);

SoixanteQuatreColonne::SoixanteQuatreColonne() {
}

SoixanteQuatreColonne::~SoixanteQuatreColonne() {
}
	
bool SoixanteQuatreColonne::canMoveTo(CardsRef pile, CardRef card) {
	if ( getCount() > 0 ) {
		if ( canFollow(getLast(), card) ) {
			return true;
		}
	}
	else {
		return true;
	}
	
	return false;
}

bool SoixanteQuatreColonne::canFollow(CardRef card1, CardRef card2) {
	if ( suiteCarte(card1, card2, eAlterneCouleur) ) {
		return true;
	}
	return false;
}

SoixanteQuatreModel::SoixanteQuatreModel() {
	for ( int i = 0 ; i < 4 ; ++i ) {
		m_piles.add(m_series.add(new CardGameSerie()));
	}
	
	for ( int i = 0 ; i < 8 ; ++i ) {
		m_piles.add(m_colonnes.add(new SoixanteQuatreColonne()));
	}
	
	m_piles.add(&m_talon);
}

SoixanteQuatreModel::~SoixanteQuatreModel() {
}

/* creation du jeu
 - creation de 2 jeux de 52 cartes
 - melange du jeu
 */
void SoixanteQuatreModel::create() {
	m_cards.create52(2);
	m_cards.mix();
}

void SoixanteQuatreModel::distrib() {
	CardGameModel::distrib();
	
	Iterator iter = m_cards.getIterator();
	for ( int j = 0 ; j < 8 && iter.hasNext() ; ++j ) {
		for ( int i = 0 ; i < m_colonnes.getCount() && iter.hasNext() ; ++i ) {
			CardRef card = (CardRef)iter.removeNext();
			card->m_reverse = false;
			m_colonnes[i]->add(card);
		}
	}
	
	while ( iter.hasNext() ) {
		m_talon.add(iter.removeNext());
	}

	m_talon.m_tourDeTalon = 4;
}

bool SoixanteQuatreModel::action(CardsRef pile, CardRef card) {
	if ( pile == &m_talon ) {
		if ( m_talon.getCount() > 0 ) {
			pioche();
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

void SoixanteQuatreModel::pioche() {
	Actions* actions = new Actions();
	
	/* On deplace 1 carte sur la colonne de gauche */
	if ( m_talon.getCount() > 0 ) {
		CardRef card = (CardRef)m_talon.getLast();
		
		actions->add(new MoveCardAction(this, card, &m_talon, m_colonnes[0]));
		actions->add(new ReverseCardAction(card, false));
	}
	
	pushAction(actions);
}

const char* SoixanteQuatreModel::getRulesDistrib() {
	return label("SoixanteQuatre", "RulesDistrib");
}

const char* SoixanteQuatreModel::getRulesPlay() {
	return label("SoixanteQuatre", "RulesPlay");
}

SoixanteQuatreView::SoixanteQuatreView() : CardGameView() {
}

SoixanteQuatreView::~SoixanteQuatreView() {
}

void SoixanteQuatreView::calc(GdiRef gdi, int nw, int nh) {
	CardGameView::calc(gdi, nw, nh);

	SoixanteQuatreModelRef model = (SoixanteQuatreModelRef)m_model;
	for ( int i = 0 ; i < 8 ; ++i ) {
		model->m_series[i]->m_wcard = (int)( m_wcard * .8 );
		model->m_series[i]->m_hcard = (int)( m_hcard * .8 );
	}
}

void SoixanteQuatreView::draw(GdiRef gdi) {
	SoixanteQuatreModelRef model = (SoixanteQuatreModelRef)m_model;
	
	calc(gdi, model->m_colonnes.getCount(), 5);  
	
	int wc = model->m_series[0]->m_wcard;
	if ( m_right2left ) {
		drawCards(gdi, &model->m_talon, m_w-m_mo-m_wcard, m_mo, 0, 0);
		drawCardDeckList(gdi, &model->m_series, m_mo, m_mo, wc+m_mi, 0, 0, 0, 0, 0);
	}
	else {
		drawCards(gdi, &model->m_talon, m_mo, m_mo, 0, 0);
		drawCardDeckList(gdi, &model->m_series, m_w-m_mo-7*m_mi-8*wc, m_mo, wc+m_mi, 0, 0, 0, 0, 0);
	}
	
	drawCardDeckList(gdi, &model->m_colonnes, m_mo, m_mo+m_hcard+m_mi, m_wcard+m_mi, 0, 0, m_dhc, 0, m_dhc);
}
