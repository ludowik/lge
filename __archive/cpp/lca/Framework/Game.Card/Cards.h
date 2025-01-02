#pragma once

ImplementClass(Model);

enum typeCards {
	ePile,
	eEcart,
	eTalon,
	eStock,
	eDefausse,
	ePioche,
	eMain
};

ImplementClass(Cards) : public List {
public:
	Rect m_rect;
	
	int m_cx;
	int m_cy;
	
	int m_wcard;
	int m_hcard;
	
	ModelRef m_model;
	
	int m_type;

	int m_npioche;
	
public:
	Cards(ModelRef model=0);
	virtual ~Cards();
	
public:
	virtual CardRef get(int i);
	virtual CardRef operator[](int i);
	
	virtual CardRef getFirst();
	virtual CardRef getLast();
	
	virtual Rect getNextPosition();
	
	virtual bool canMoveTo(Cards* pile, CardRef card);
	
	virtual bool canMoveTo(CardRef card1, CardRef card2);
	virtual bool canFollow(CardRef card1, CardRef card2);
	
	virtual bool automatic(bool user);
	
public:
	void createSerie(int serie, bool cavalier=false);
	
	void create52(int n=1);
	void create54();
	void createTarot();
	
	void mix();
	void coupe();
	
	void reverse(bool reverse=true );
	void select (bool select =false);
	void checked(bool checked=false);
	
};

ImplementClass(CardDeckList) : public List {	
public:
	CardDeckList();
	virtual ~CardDeckList();

public:
	virtual CardsRef get(int i);
	virtual CardsRef operator[](int i);
	
};

