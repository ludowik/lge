#pragma once

#include "Game.View.h"

ImplementClass(CardGameView) : public ViewGame {
public:
	int m_x; /* x de la zone d'affichage */
	int m_y; /* y de la zone d'affichage */
	int m_w; /* w de la zone d'affichage */
	int m_h; /* h  de la zone d'affichage */
	
	int m_mo; /* marge externe */
	int m_mi; /* marge interne */
	int m_mc; /* marge centre  */
	
	int m_wcard; /* largeur d'une carte */
	int m_hcard; /* hauteur d'une carte */ 
	
	double m_pwh1; /* rapport 1 entre largeur et hauteur */
	double m_pwh2; /* rapport 2 entre largeur et hauteur */
	
	double m_pwc; /* delta entre deux cartes d'un même tas en largeur en pourcentage */
	double m_phc; /* delta entre deux cartes d'un même tas en hauteur en pourcentage */
	
	int m_dwc; /* delta entre deux cartes d'un même tas en largeur */
	int m_dhc; /* delta entre deux cartes d'un même tas en hauter  */
	
public:
	CardGameView();
	
public:
	ObjectRef get_object(int x, int y);
	
public:
	virtual void loadResource();
	
	virtual void createUI();
	virtual void createToolBar();
	
	virtual void releaseGdi();
	
	virtual void calc(GdiRef gdi, double nw, double nh=-1);
	
	virtual void erase(GdiRef gdi);

	virtual void draw(GdiRef gdi);
	
	virtual void drawCardDeckList(GdiRef gdi, CardDeckList* zone, int x, int y, int zx, int zy, int cx, int cy, int cx2=-1, int cy2=-1, int show=-1);
	virtual void drawCards(GdiRef gdi, CardsRef pile, int x, int y, int cx, int cy, int cx2=-1, int cy2=-1, int show=-1);
	
	virtual void drawCard(GdiRef gdi, CardRef card, CardsRef pile, int x, int y, int w, int h, int cx=-1, int cy=-1);

	virtual void movecard_draw(CardRef card, CardsRef from, CardsRef to);
	
	virtual bool touchBegin(int x, int y);
	virtual bool touchMove (int x, int y);
	virtual bool touchEnd  (int x, int y);
	
	virtual bool touchDoubleTap(int x, int y);
	
public:
	virtual bool onDrag(int x, int y, bool init);
	virtual bool onDrop(int x, int y);
	
};
