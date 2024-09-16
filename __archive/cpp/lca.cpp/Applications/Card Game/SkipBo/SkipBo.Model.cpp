#include "System.h"
#include "SkipBo.Model.h"
#include "SkipBo.View.h"
#include "CardGame.Action.h"

SkipBoPlayer::SkipBoPlayer() {
}

SkipBoPlayer::~SkipBoPlayer() {
}

SkipBoModel::SkipBoModel() {
	m_class = "SkipBoModel";
	
	m_nplayer = sizeof(m_player)/sizeof(SkipBoPlayer);
	
	m_iplayer = 0;
	m_firstPioche = true;

	m_iwin = -1;
	
	for ( int iplayer = 0 ; iplayer < m_nplayer ; ++iplayer ) {
		SkipBoPlayerRef player = &m_player[iplayer];
		
		player->m_stock.m_iplayer = iplayer;
		player->m_main .m_iplayer = iplayer;
		
		m_piles.add(&player->m_stock);
		m_piles.add(&player->m_main );
		
		for ( int i = 0 ; i < 4 ; ++i )
		{      
			SkipBoDefausseRef defausse = (SkipBoDefausseRef)m_piles.add(player->m_defausses.add(new SkipBoDefausse()));
			defausse->m_iplayer = iplayer;
		}
	}
	
	m_piles.add(&m_talon);
	for ( int i = 0 ; i < 4 ; ++i ) {
		m_piles.add(m_series.add(new SkipBoSerie()));
	}
}

SkipBoModel::~SkipBoModel() {
}

void SkipBoModel::create() {
	range();
	
	for ( int serie = 0 ; serie < 12 ; ++serie ) {
		for ( int val = 1 ; val <= 12 ; ++val ) {
			m_cards.add(new Card(serie, val));
		}
	}
	
	for ( int val = 0 ; val < 18 ; ++val ) {
		m_cards.add(new Card(12, eJocker));
	}
	
	m_cards.mix();
}

void SkipBoModel::distrib() {
	CardGameModel::distrib();
	
	int n = 30;
	
	Iterator iter = m_cards.getIterator();
	for ( int i = 0 ; i < n ; ++i ) {
		for ( int j = 0 ; j < m_nplayer ; ++j ) {
			CardRef card = (CardRef)iter.removeNext();
			m_player[j].m_stock.add(card);
			
			card->m_reverse = true;
		}
	}
	
	for ( int j = 0 ; j < m_nplayer ; ++j ) {
		CardRef card = (CardRef)m_player[j].m_stock.getLast();
		card->m_reverse = false;
	}
	
	m_talon.adds(&m_cards);
}

bool SkipBoModel::action(CardsRef pile, CardRef card) {
	if ( pile == &m_talon ) {
		if ( m_talon.getCount() > 0 ) {
			pioche();
		}
	}
	else {
		if ( m_cardSelect
			&& pile->canMoveTo(m_pileSelect, m_cardSelect) ) {
			pushAction(new MoveCardAction(this, m_cardSelect, m_pileSelect, pile));
			unselect();
		}
		else {
			unselect();
			select(pile, card);
		}
		
		CardGameAction* action = (CardGameAction*)getLastAction();
		if (  action ) {
			CardsRef pile = (CardsRef)action->m_to;
			
			SkipBoPlayerRef player = &m_player[m_iplayer];
			if (   pile == player->m_defausses[0]
				|| pile == player->m_defausses[1]
				|| pile == player->m_defausses[2]
				|| pile == player->m_defausses[3] ) {
				next_player();
			}
		}
		
		return true;
	}
	
	return true;
}

bool SkipBoModel::select(CardsRef pile, CardRef card) {
	m_pileSelect = pile;
	m_cardSelect = card;
	
	if ( m_cardSelect ) {
		m_cardSelect->m_select = true;
	}
	
	return true;
}

void SkipBoModel::pioche() {
	SkipBoPlayerRef player = &m_player[m_iplayer];
	
	if ( m_firstPioche == false && player->m_main.getCount() ) {
		return;
	}

	m_firstPioche = false;
	
	ActionsRef actions = new Actions();
	for ( int i = player->m_main.getCount() ; i < 5 && i < m_talon.getCount() ; ++i ) {
		CardRef card = (CardRef)m_talon[i];
		
		actions->add(new ReverseCardAction(card, false));        
		actions->add(new MoveCardAction(this, card, &m_talon, &player->m_main));
	}
	pushAction(actions);
}

void SkipBoModel::defausse() {
	SkipBoPlayerRef player = &m_player[m_iplayer];

	CardRef card = (CardRef)player->m_main.getLast();
	if ( card ) {
		pushAction(new MoveCardAction(this, card, &player->m_main, player->m_defausses[0]));
	}
}

int SkipBoModel::automatic(bool user) {
	while ( m_iplayer != 0 ) {
		play();
	}
	return true;
}

void SkipBoModel::next_player() {
	m_iplayer++;
	m_iplayer = m_iplayer % m_nplayer;
	m_firstPioche = true;
}

int SkipBoModel::play() {
	int n = 0;
	int m = 0;
	
	pioche();
	
	do {
		m = 0;
		
		do {
			n = playstock();
			m += n;
		}
		while ( n );
		
		n = playmain();
		m += n;
		
		do {
			n = playstock();
			m += n;
		}
		while ( n );
		
		n = playdefausse();
		m += n;
		
		pioche();
	}
	while ( m );
	
	defausse();
	
	next_player();
	
	return 1;
}

int SkipBoModel::automatic(CardsRef from, CardRef card, bool user) {
	return playcard(card);
}

int SkipBoModel::playcard(CardRef card) {
	if ( card ) {
		SkipBoPlayerRef player = &m_player[m_iplayer];
		
		Iterator iter = m_series.getIterator();
		while ( iter.hasNext() ) {
			CardsRef serie = (CardsRef)iter.next();
			if ( serie->canMoveTo(&player->m_stock, card) ) {
				pushAction(new MoveCardAction(this, card, getPile(card), serie));
				
				card = player->m_stock.getLast();
				if ( card ) {
					card->m_reverse = false;
				}
				return 1;
			}
		}
	}
	
	return 0;
}

int SkipBoModel::playstock() {
	SkipBoPlayerRef player = &m_player[m_iplayer];  
	return playcard(player->m_stock.getLast());
}

int SkipBoModel::playmain() {
	SkipBoPlayerRef player = &m_player[m_iplayer];
	
	int n = 0;
	
	Iterator iter = player->m_main.getIterator();
	while ( iter.hasNext() ) {
		CardRef card = (CardRef)iter.next();
		n += playcard(card);
	}
	
	return n;
}

int SkipBoModel::playdefausse() {
	SkipBoPlayerRef player = &m_player[m_iplayer];
	
	int n = 0;
	
	Iterator iter = player->m_defausses.getIterator();
	while ( iter.hasNext() ) {
		CardsRef pile = (CardsRef)iter.next();
		n += playcard(pile->getLast());
	}
	
	return n;
}

bool SkipBoModel::isGameWin() {
	for ( int iplayer = 0 ; iplayer < m_nplayer ; ++iplayer ) {
		SkipBoPlayerRef player = &m_player[iplayer];
		if ( player->m_stock.getCount() == 0 ) {
			m_iwin = iplayer;
			return true;
		}
	}
	
	return false;
}
