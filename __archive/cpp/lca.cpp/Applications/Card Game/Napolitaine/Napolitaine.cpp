#include "System.h"
#include "Model.h"
#include "Napolitaine.h"
#include "CardGame.Action.h"

ApplicationObject<NapolitaineView, NapolitaineModel> appNapolitaine("Napolitaine", "Napolitaine", 0, 0, pageCardGame);

NapolitaineColonne::NapolitaineColonne() {
}

NapolitaineColonne::~NapolitaineColonne() {
}

bool NapolitaineColonne::canMoveTo(CardsRef pile, CardRef card) {
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

bool NapolitaineColonne::canFollow(CardRef card1, CardRef card2) {
	if ( suiteCarte(card1, card2, eAlterneCouleur) ) {
		return true;
	}
	return false;
}

NapolitaineEcart::NapolitaineEcart() {
}

NapolitaineEcart::~NapolitaineEcart() {
}

bool NapolitaineEcart::canMoveTo(CardsRef pile, CardRef card) {
	return false;
}

NapolitaineModel::NapolitaineModel() {
	for ( int i = 0 ; i < 8 ; ++i ) {
		m_piles.add(m_colonnes.add(new NapolitaineColonne()));
	}
	
	for ( int i = 0 ; i < 2 ; ++i ) {
		m_piles.add(m_ecarts.add(new NapolitaineEcart()));
	}
	
	m_piles.add(&m_talon);
	
	indiceEcart = 0;
}

NapolitaineModel::~NapolitaineModel() {
}

void NapolitaineModel::distrib() {
	CardGameModel::distrib();
	
	Iterator iter = m_cards.getIterator();
	for ( int j = 0 ; j < 4 && iter.hasNext() ; ++j ) {
		for ( int i = 0 ; i < m_colonnes.getCount() && iter.hasNext() ; ++i ) {
			CardRef card = (CardRef)iter.removeNext();
			card->m_reverse = !(j%2);
			m_colonnes[i]->add(card);
		}
	}
	
	while ( iter.hasNext() ) {
		m_talon.add(iter.removeNext());
	}
	
	m_talon.m_tourDeTalon = 4;
}

bool NapolitaineModel::action(CardsRef pile, CardRef card) {
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

void NapolitaineModel::pioche() {
	Actions* actions = new Actions();
	
	/* On deplace 2 cartes et on les rend visibles */
	if ( m_talon.getCount() > 0 ) {
		CardRef card = (CardRef)m_talon.getLast();
		
		actions->add(new MoveCardAction(this, card, &m_talon, m_ecarts[indiceEcart]));
		actions->add(new ReverseCardAction(card, false));
	}
	
	indiceEcart = indiceEcart?0:1;
	
	pushAction(actions);
}

const char* NapolitaineModel::getRulesDistrib() {
	return label("Napolitaine", "RulesDistrib");
}

const char* NapolitaineModel::getRulesPlay() {
	return label("Napolitaine", "RulesPlay");
}

NapolitaineView::NapolitaineView() : CardGameView() {
}

NapolitaineView::~NapolitaineView() {
}

void NapolitaineView::draw(GdiRef gdi) {
	NapolitaineModelRef model = (NapolitaineModelRef)m_model;
	
	calc(gdi, model->m_colonnes.getCount(), 5);  
	
	if ( m_right2left ) {
		drawCards(gdi, &model->m_talon, m_w-m_mo-m_wcard, m_mo, 0, 0);
		drawCardDeckList(gdi, &model->m_ecarts, m_w-m_mo-m_wcard-m_mc-m_wcard, m_mo, -m_mo-m_wcard, 0, 0, 0);
		
		drawCardDeckList(gdi, &model->m_series, m_mo, m_mo, m_wcard + m_mi, 0, 0, 0);
	}
	else {
		drawCards(gdi, &model->m_talon, m_mo, m_mo, 0, 0);
		drawCardDeckList(gdi, &model->m_ecarts, m_mo+m_wcard+m_mc, m_mo, m_mo+m_wcard, 0, 0, 0);
		
		drawCardDeckList(gdi, &model->m_series, m_w-m_mo-3*m_mi-4*m_wcard, m_mo, m_wcard + m_mi, 0, 0, 0);
	}
	
	drawCardDeckList(gdi, &model->m_colonnes, m_mo, m_mo+m_hcard+m_mo*3, m_wcard + m_mi, 0, 0, m_dhc, 0, m_dhc);
}
