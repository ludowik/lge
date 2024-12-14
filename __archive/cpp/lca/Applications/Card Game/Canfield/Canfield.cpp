#include "System.h"
#include "Model.h"
#include "Canfield.h"
#include "CardGame.Action.h"

ApplicationObject<CanfieldView, CanfieldModel> appCanfield("Canfield", "Canfield", 0, 0, pageCardGame);

CanfieldColonne::CanfieldColonne() {
}

CanfieldColonne::~CanfieldColonne() {
}

bool CanfieldColonne::canMoveTo(CardsRef pile, CardRef card) {
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

bool CanfieldColonne::canFollow(CardRef card1, CardRef card2) {
	if ( suiteCarte(card1, card2, eAlterneCouleurEnBoucle) ) {
		return true;
	}
	return false;
}

CanfieldReserve::CanfieldReserve() {
}

CanfieldReserve::~CanfieldReserve() {
}

bool CanfieldReserve::canMoveTo(CardsRef pile, CardRef card) {
	return false;
}

bool CanfieldReserve::canFollow(CardRef card1, CardRef card2) {
	if ( suiteCarte(card1, card2, eAlterneCouleur) ) {
		return true;
	}
	return false;
}

CanfieldEcart::CanfieldEcart() {
}

CanfieldEcart::~CanfieldEcart() {
}

bool CanfieldEcart::canMoveTo(CardsRef pile, CardRef card) {
	return false;
}

CanfieldModel::CanfieldModel() {
	m_ecarts.m_delete = false;
	
	for ( int i = 0 ; i < 4 ; ++i ) {
		m_piles.add(m_colonnes.add(new CanfieldColonne()));
	}

	m_piles.add(m_ecarts.add(&m_ecart));
	m_piles.add(&m_talon);
	m_piles.add(&m_reserve);
	
	m_ecart.m_npioche = 3;
}

CanfieldModel::~CanfieldModel() {
}

void CanfieldModel::distrib() {
	CardGameModel::distrib();
	
	CardRef card;
	
	Iterator iter = m_cards.getIterator();
	card = (CardRef)iter.removeNext();
	card->m_reverse = false;
	m_series[0]->add(card);
	
	CardGameSerie::m_firstCardInSerie = m_series[0]->get(0)->m_val;
	
	for ( int i = 0 ; i < 4 ; ++i ) {
		card = (CardRef)iter.removeNext();
		card->m_reverse = false;
		m_colonnes[i]->add(card);
	}

	for ( int i = 0 ; i < 13 ; ++i ) {
		card = (CardRef)iter.removeNext();
		card->m_reverse = false;
		m_reserve.add(card);
	}
	
	while ( iter.hasNext() ) {
		m_talon.add(iter.removeNext());
	}

	m_talon.m_tourDeTalon = 4;
}

bool CanfieldModel::action(CardsRef pile, CardRef card) {
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

const char* CanfieldModel::getRulesDistrib() {
	return label("Canfield", "RulesDistrib");
}

const char* CanfieldModel::getRulesPlay() {
	return label("Canfield", "RulesPlay");
}

bool CanfieldModel::load() {
	bool b = ::Model::load();

	Iterator iter = m_series.getIterator();
	while ( iter.hasNext() ) {
		CardsRef serie = (CardsRef)iter.next();
		if ( serie && serie->getCount() > 0 ) {
			CardRef card = serie->get(0);
			if ( card ) {
				CardGameSerie::m_firstCardInSerie = card->m_val;
				break;
			}
		}
	}

	return b;
}

CanfieldView::CanfieldView() : CardGameView() {
}

CanfieldView::~CanfieldView() {
}

void CanfieldView::draw(GdiRef gdi) {
	CanfieldModelRef model = (CanfieldModelRef)m_model;
	
	calc(gdi, model->m_colonnes.getCount()+3, 5);  
	
	Rect rect = gdi->m_rect;
	if ( m_right2left ) {
		drawCards(gdi, &model->m_talon, m_w-m_mo-m_wcard, m_mo, 0, 0);
		drawCards(gdi, &model->m_ecart, m_w-m_mo-m_wcard-m_mc-m_wcard, m_mo, -m_dwc, 0, 0, 0);

		if ( rect.w > rect.h )
			drawCards(gdi, &model->m_reserve, m_w-m_mo-3*m_wcard-m_mi-m_mc-m_wcard, m_mo, 0, m_dhc);
		else
			drawCards(gdi, &model->m_reserve, m_w-m_mo-m_wcard-m_mc-m_wcard, m_mo+m_hcard+m_mi, 0, m_dhc);
		
		drawCardDeckList(gdi, &model->m_series, m_mo, m_mo, m_wcard+m_mi, 0, 0, 0);
		drawCardDeckList(gdi, &model->m_colonnes, m_mo, m_mo+m_hcard+m_mi, m_wcard+m_mi, 0, 0, m_dhc, 0, m_dhc);
	}
	else {
		drawCards(gdi, &model->m_talon, m_mo, m_mo, 0, 0);
		drawCards(gdi, &model->m_ecart, m_mo+m_wcard+m_mc, m_mo, m_dwc, 0, 0, 0);
		
		if ( rect.w > rect.h )
			drawCards(gdi, &model->m_reserve, m_mo+3*m_wcard+m_mi+m_mc, m_mo, 0, m_dhc);
		else
			drawCards(gdi, &model->m_reserve, m_mo+m_wcard+m_mc, m_mo+m_hcard+m_mi, 0, m_dhc);
		
		drawCardDeckList(gdi, &model->m_series, m_w-m_mo-3*m_mi-4*m_wcard, m_mo, m_wcard+m_mi, 0, 0, 0);
		drawCardDeckList(gdi, &model->m_colonnes, m_w-m_mo-3*m_mi-4*m_wcard, m_mo+m_hcard+m_mi, m_wcard+m_mi, 0, 0, m_dhc, 0, m_dhc);
	}
}
