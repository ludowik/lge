#include "System.h"
#include "Cards.h"

Cards::Cards(ModelRef model) {
	m_class = "Cards";
	
	m_rect = Rect();
	
	m_cx = 0;
	m_cy = 0;
	
	m_wcard = 0;
	m_hcard = 0;
	
	m_model = model;
	
	m_type = ePile; 

	m_npioche = 0;
}

Cards::~Cards() {
}

CardRef Cards::get(int i) {
	return (CardRef)List::get(i);
}

CardRef Cards::operator[](int i) {
	return (CardRef)List::get(i);
}

CardRef Cards::getFirst() {
	return (CardRef)List::getFirst();
}

CardRef Cards::getLast() {
	return (CardRef)List::getLast();
}

Rect Cards::getNextPosition() {
	Rect rect = m_rect;
	if ( m_npioche > 0 ) {
		CardRef card = 0;
		
		Iterator iter = getIterator();
		while ( iter.hasNext() ) {
			card = (CardRef)iter.next();
			if ( card && !card->m_reverse ) {
				break;
			}
		}
		if ( card ) {
			rect = card->m_rect;
			rect.x += m_cx;
			rect.y += m_cy;
		}
	}
	else {
		if ( getLast() ) {
			rect = getLast()->m_rect;
			rect.x += m_cx;
			rect.y += m_cy;
		}
	}
	return rect;
}

bool Cards::canMoveTo(CardsRef pile, CardRef card) {
	return true;
}

bool Cards::canMoveTo(CardRef card1, CardRef card2) {
	return true;
}

bool Cards::canFollow(CardRef card1, CardRef card2) {
	return false;
}

bool Cards::automatic(bool user) {
	return false;
}

void Cards::createSerie(int serie, bool cavalier) {
	add(new Card(serie, Card::as));
	
	for ( int val = 2 ; val <= 10 ; ++val ) {
		add(new Card(serie, val));
	}
	
	add(new Card(serie, Card::valet));
	
	if ( cavalier ) {
		add(new Card(serie, Card::cavalier));
	}
	
	add(new Card(serie, Card::dame));
	add(new Card(serie, Card::roi));
}

void Cards::create52(int n) {
	releaseAll();
	
	Card::as = 1;
	Card::valet = 11;
	Card::dame = 12;
	Card::roi = 13;
	
	for ( int i = 0 ; i < n ; ++ i ) {
		for ( int serie = 0 ; serie < 4 ; ++serie ) {
			createSerie(serie);
		}
	}
}

void Cards::create54() {
	create52();
	
	add(new Card(eAtout, eJocker));
	add(new Card(eAtout, eJocker));
}

void Cards::createTarot() {
	releaseAll();
	
	Card::as = 1;
	Card::valet = 11;
	Card::cavalier = 12;
	Card::dame = 13;
	Card::roi = 14;
	
	for ( int serie = 0 ; serie < 4 ; ++serie ) {
		createSerie(serie, true);
	}
	
	for ( int val = ePetit ; val <= 21 ; ++val ) {
		add(new Card(eAtout, val));
	}
	
	add(new Card(eAtout, eExcuse));
}

void Cards::mix() {
	int count = getCount();
	while ( count ) {
		add(remove(System::Math::random(count)));
		count--;
	}
}

void Cards::coupe() {
	int n = System::Math::random(getCount());
	while ( n ) {
		add(0, remove(getLast()));
		n--;
	}
}

void Cards::reverse(bool reverse) {
	Iterator iter = getIterator();
	while ( iter.hasNext() ) {
		CardRef card = (CardRef)iter.next();
		card->m_reverse = reverse;
	}
}

void Cards::select(bool select) {
	Iterator iter = getIterator();
	while ( iter.hasNext() ) {
		CardRef card = (CardRef)iter.next();
		card->m_select = select;
	}
}

void Cards::checked(bool checked) {
	Iterator iter = getIterator();
	while ( iter.hasNext() ) {
		CardRef card = (CardRef)iter.next();
		card->m_check = checked;
	}
}

CardDeckList::CardDeckList() {
	m_delete = true;
}

CardDeckList::~CardDeckList() {
}

CardsRef CardDeckList::get(int i) {
	return (CardsRef)List::get(i);
}

CardsRef CardDeckList::operator[](int i) {
	return (CardsRef)List::get(i);
}
