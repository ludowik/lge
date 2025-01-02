#include "System.h"
#include "Model.h"
#include "LoiSalique.h"
#include "CardGame.Action.h"
#include "LoiSalique.h"

ApplicationObject<LoiSaliqueView, LoiSaliqueModel> appLoiSalique("Loi Salique", "LoiSalique", 0, 0, pageCardGame);

LoiSaliqueColonne::LoiSaliqueColonne() {
}

LoiSaliqueColonne::~LoiSaliqueColonne() {
}

bool LoiSaliqueColonne::canMoveTo(CardsRef pile, CardRef card) {
	if ( getCount() > 0 ) {
		if ( canFollow(getLast(), card) ) {
			return true;
		}
	}
	else if ( card->m_val == Card::roi ) {
		return true;
	}
	return false;
}

bool LoiSaliqueColonne::canFollow(CardRef card1, CardRef card2) {
	if ( card1->m_val == Card::roi ) {
		return true;
	}
	return false;
}

LoiSaliqueSeries::LoiSaliqueSeries() {
}

LoiSaliqueSeries::~LoiSaliqueSeries() {
}

bool LoiSaliqueSeries::canMoveTo(CardsRef pile, CardRef card) {
	if ( getCount() > 0 ) {
		if ( canFollow(getLast(), card) ) {
			return true;
		}
	}
	else if ( card->m_val == Card::as ) {
		return true;
	}
	return false;
}

bool LoiSaliqueSeries::canFollow(CardRef card1, CardRef card2) {
	if ( card1->m_val+1 == card2->m_val && card2->m_val != Card::dame ) {
		return true;
	}
	return false;
}

LoiSaliqueEcart::LoiSaliqueEcart() {
}

LoiSaliqueEcart::~LoiSaliqueEcart() {
}

bool LoiSaliqueEcart::canMoveTo(CardsRef pile, CardRef card) {
	if ( getCount() > 0 ) {
		return false;
	}
	else if ( card->m_val == Card::dame ) {
		return true;
	}
	
	return false;
}

LoiSaliqueModel::LoiSaliqueModel() {
	for ( int i = 0 ; i < 8 ; ++i ) {
		m_piles.add(m_series.add(new LoiSaliqueSeries()))->m_class = "CardGameSerie";
	}
	
	for ( int i = 0 ; i < 8 ; ++i ) {
		m_piles.add(m_colonnes.add(new LoiSaliqueColonne()));
	}
	
	for ( int i = 0 ; i < 8 ; ++i ) {
		m_piles.add(m_ecarts.add(new LoiSaliqueEcart()));
	}
	
	m_piles.add(&m_talon);
	
	m_canAutomate = false;
}

LoiSaliqueModel::~LoiSaliqueModel() {
}

/* creation du jeu
 - creation de 2 jeux de 52 cartes
 - melange du jeu
 */
void LoiSaliqueModel::create() {
	m_cards.create52(2);
	m_cards.mix();
}

void LoiSaliqueModel::distrib() {
	CardGameModel::distrib();
	
	Iterator iter = m_cards.getIterator();
	while ( iter.hasNext() ) {
		CardRef card = (CardRef)iter.removeNext();
		if ( card->m_val == Card::roi && m_colonnes[0]->getCount() == 0 ) {
			m_colonnes[0]->add(card);
			card->m_reverse = false;
		}
		else {
			m_talon.add(card);
		}
	}
	
	m_talon.m_tourDeTalon = 0;	
}

bool LoiSaliqueModel::action(CardsRef pile, CardRef card) {
	if ( pile == &m_talon ) {
		if ( m_talon.getCount() > 0 ) {
			pioche();
		}
	}
	else {
		return CardGameModel::action(pile, card);
	}
	
	return true;
}

int LoiSaliqueModel::automatic(CardsRef from, CardRef card, bool user) {
	int r = SolitaireCardGameModel::automatic(from, card, user);
	
	/* retournement d'une serie si complete */
	foreach ( CardsRef ,  pile , m_series ) {
		if ( pile->getCount() == 11 ) {
			CardRef last = pile->getLast();
			if ( !last->m_reverse ) {
				pushAction(new ReverseCardAction(last, false));
			}
		}
	}
	
	return r;
}

void LoiSaliqueModel::pioche() {
	pioche_proc();
	
	while ( m_series[0]->getCount() == 0) {
		pioche_proc();
	}
}

void LoiSaliqueModel::pioche_proc() {
	Actions* actions = new Actions();
	
	/* On pioche une carte */
	if ( m_talon.getCount() > 0 ) {
		CardRef card = (CardRef)m_talon.getLast();
		
		CardsRef pile = 0;
		
		int i = 0;
		if ( card->m_val == Card::roi ) {
			for ( ; m_colonnes[i]->getCount() ; ++i);
			pile = m_colonnes[i];
		}
		else if ( card->m_val == Card::dame ) {
			for ( ; m_ecarts[i]->getCount() ; ++i);
			pile = m_ecarts[i];
		}
		else if ( card->m_val == Card::as ) {
			for ( ; m_series[i]->getCount() ; ++i);
			pile = m_series[i];
		}
		else {
			for ( ; m_colonnes[7-i]->getCount() == 0 ; ++i);
			pile = m_colonnes[7-i];
		}
		
		actions->add(new MoveCardAction(this, card, &m_talon, pile));
		actions->add(new ReverseCardAction(card, false));
	}
	
	pushAction(actions);
}

/* Test si le joueur a gagne
 - toutes les series doivent être completes
 */
bool LoiSaliqueModel::isGameWin() {
	foreach ( CardsRef ,  pile , m_series ) {
		if ( pile->getCount() < 11 ) { // Jusqu'au Valet uniquement
			return false;
		}
	}
	return true;
}

const char* LoiSaliqueModel::getRulesDistrib() {
	return label("LoiSalique", "RulesDistrib");
}

const char* LoiSaliqueModel::getRulesPlay() {
	return label("LoiSalique", "RulesPlay");
}

LoiSaliqueView::LoiSaliqueView() : CardGameView() {
}

LoiSaliqueView::~LoiSaliqueView() {
}

bool LoiSaliqueView::touchBegin(int x, int y) {
	if ( CardGameView::touchBegin(x, y) ) {
		return true;
	}
	
	LoiSaliqueModel* model = (LoiSaliqueModel*)m_model;
	model->pioche();
	
	return true;
}

void LoiSaliqueView::draw(GdiRef gdi) {
	LoiSaliqueModelRef model = (LoiSaliqueModelRef)m_model;
	
	calc(gdi, model->m_colonnes.getCount(), 4.5);  
	
	int y = m_mo;
	if ( System::Media::getOrientation() == orientationPortrait ) {
		y += m_hcard;
	}
	
	drawCards(gdi, &model->m_talon, (m_w-m_wcard)/2, y, 0, 0);
	
	int x = m_w - model->m_colonnes.getCount() * m_wcard - ( model->m_colonnes.getCount() - 1 ) * m_mi;
	x /= 2;
	
	drawCardDeckList(gdi, &model->m_series  , x, y+1*(m_hcard+m_mi), m_wcard + m_mi, 0, 0, 0);
	drawCardDeckList(gdi, &model->m_colonnes, x, y+2*(m_hcard+m_mi), m_wcard + m_mi, 0, 0, 0);
	drawCardDeckList(gdi, &model->m_ecarts  , x, y+3*(m_hcard+m_mi), m_wcard + m_mi, 0, 0, 0);
}
