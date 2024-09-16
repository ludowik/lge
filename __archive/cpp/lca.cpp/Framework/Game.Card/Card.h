#pragma once

enum eSerie {
	eCarreau=0, // diamond = 1
	ePique, // spade = 3
	eCoeur, // heart = 2
	eTrefle, // club = 0
	eAtout=-1
};

enum eCard {
	ePetit=1,
	eExcuse=22,
	eJocker=23
};

ImplementClass(Card) : public Object {
public:
	static int as;
	static int valet;
	static int cavalier;
	static int dame;
	static int roi;
	
public:
	int m_serie;
	int m_val;
	
public:
	bool m_select;
	bool m_reverse;
	bool m_check;
	
public:
	Rect m_rect;
	
public:
	Bitmap m_bitmap;
	Bitmap m_bitmapSelected;
	
public:
	Card();
	Card(int serie, int val);
	
public:
	virtual const char* asString();
	
public:
	virtual bool save(class File& file);
	virtual bool load(class File& file);

public:
	virtual BitmapRef makeBitmap(GdiRef gdi, int w, int h);
	virtual void draw(GdiRef gdi, int x, int y, int w, int h);
					  
};
