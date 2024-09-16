#include "System.h"
#include "Model.h"
#include "SolitaireBis.h"
#include "CardGame.Action.h"

ApplicationObject<SolitaireBisView, SolitaireBisModel> appSolitaireBis("SolitaireBis", "SolitaireBis", 0, 0, pageCardGame);

SolitaireBisColonne::SolitaireBisColonne() {
}

SolitaireBisColonne::~SolitaireBisColonne() {
}

bool SolitaireBisColonne::canMoveTo(CardsRef pile, CardRef card) {
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

bool SolitaireBisColonne::canFollow(CardRef card1, CardRef card2) {
	if ( suiteCarte(card1, card2, eSuite) ) {
		return true;
	}
	return false;
}

SolitaireBisEcart::SolitaireBisEcart() {
}

SolitaireBisEcart::~SolitaireBisEcart() {
}

bool SolitaireBisEcart::canMoveTo(CardsRef pile, CardRef card) {
	return false;
}

SolitaireBisModel::SolitaireBisModel() {
	m_ecarts.m_delete = false;
	
	CardGameSerie::m_memeFamille = 0;
	
	for ( int i = 0 ; i < 4 ; ++i ) {
		m_piles.add(m_colonnes.add(new SolitaireBisColonne()));
	}

	m_piles.add(m_ecarts.add(&m_ecart));
	m_piles.add(&m_talon);
	
	m_ecart.m_npioche = 3;
}

SolitaireBisModel::~SolitaireBisModel() {
}

void SolitaireBisModel::distrib() {
	CardGameModel::distrib();
	
	CardRef card;
	
	Iterator iter = m_cards.getIterator();
	for ( int i = 0 ; i < m_colonnes.getCount() ; ++i ) {
		card = (CardRef)iter.removeNext();
		card->m_reverse = false;
		m_colonnes[i]->add(card);
	}

	while ( iter.hasNext() ) {
		m_talon.add(iter.removeNext());
	}

	m_talon.m_tourDeTalon = 1;
}

bool SolitaireBisModel::action(CardsRef pile, CardRef card) {
	if ( pile == &m_talon ) {
		if ( m_talon.getCount() > 0 ) {
			pioche(1);
		}
		else {
			talon();
		}
	}
	else {
		return CardGameModel::action(pile, card);
	}
	
	return true;
}

const char* SolitaireBisModel::getRulesDistrib() {
	return "A decrire";
}

const char* SolitaireBisModel::getRulesPlay() {
	return "";
}

SolitaireBisView::SolitaireBisView() : CardGameView() {
}

SolitaireBisView::~SolitaireBisView() {
}

void SolitaireBisView::draw(GdiRef gdi) {
	SolitaireBisModelRef model = (SolitaireBisModelRef)m_model;
	
	calc(gdi, model->m_colonnes.getCount()+3, 5);  
	
	if ( m_right2left ) {
		drawCards(gdi, &model->m_talon, m_w-m_mo-m_wcard, m_mo, 0, 0);
		drawCards(gdi, &model->m_ecart, m_w-m_mo-m_wcard-m_mc-m_wcard, m_mo, -m_dwc, 0, 0, 0);

		drawCardDeckList(gdi, &model->m_series, m_mo, m_mo, m_wcard+m_mi, 0, 0, 0);
		drawCardDeckList(gdi, &model->m_colonnes, m_mo, m_mo+m_hcard+m_mi, m_wcard+m_mi, 0, 0, m_dhc, 0, m_dhc);
	}
	else {
		drawCards(gdi, &model->m_talon, m_mo, m_mo, 0, 0);
		drawCards(gdi, &model->m_ecart, m_mo+m_wcard+m_mc, m_mo, m_dwc, 0, 0, 0);

		drawCardDeckList(gdi, &model->m_series, m_w-m_mo-3*m_mi-4*m_wcard, m_mo, m_wcard+m_mi, 0, 0, 0);
		drawCardDeckList(gdi, &model->m_colonnes, m_w-m_mo-3*m_mi-4*m_wcard, m_mo+m_hcard+m_mi, m_wcard+m_mi, 0, 0, m_dhc, 0, m_dhc);
	}
}
