#pragma once

ImplementClass(CardGameSerie) : public Cards {
public:
	static int m_firstCardInSerie;
	static int m_memeFamille;
	
public:
	CardGameSerie();
	
public:
	virtual bool canMoveTo(CardsRef pile, CardRef card);
	virtual bool canFollow(CardRef card1, CardRef card2);
	
};

ImplementClass(Talon) : public Cards {
public:
	int m_tourDeTalon;
	
public:
	Talon();
	
public:
	virtual bool canMoveTo(CardsRef pile, CardRef card);
	
};

