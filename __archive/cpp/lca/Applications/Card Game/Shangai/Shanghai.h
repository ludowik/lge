#pragma once

#include "CardGame.View.h"
#include "CardGame.Model.Solitaire.h"

// famille du mahjong
enum {
	// Honneur supreme (8) : Saisons numerotees de 1 a 4 & Fleurs  numerotees de 1 a 4 (ideogramme avec les noms des fleurs)
	eSaison=10,
	eFleur,

	// Honneur superieur (12): Dragons rouge, vert et blanc, chacun en 4 exemplaires 
	eDragon,

	// Honneur simple (16) : Vents d'Est, du Sud, d'Ouest et du Nord (dans l'ordre des numeros des Fleurs et Saisons correspondantes), chacun en 4 exemplaires 
	eVent,

	// Cercles (36) : serie numerotee de 1 a 9, en 4 exemplaires 
	eCercle,

	// Bambous (36) : serie numerotee de 1 a 9, en 4 exemplaires
	eBambou,

	// Caracteres (36) : serie numerotee de 1 a 9, en 4 exemplaires 
	eCaractere
};

ImplementClass(ShanghaiTuile) : public Card {
public:
	int m_level;

	double m_l;
	double m_c;

public:
	ShanghaiTuile();
	ShanghaiTuile(int serie, int val);
	virtual ~ShanghaiTuile();

public:
	virtual const char* asString();

public:
	virtual bool save(class File& file);
	virtual bool load(class File& file);

public:
	virtual BitmapRef makeBitmap(GdiRef gdi, int w, int h);
	virtual void draw(GdiRef gdi, int x, int y, int w, int h);

};

ImplementClass(ShanghaiModel) : public SolitaireCardGameModel {
public:
	Cards m_ecart;

	int m_cMax;
	int m_lMax;

public:
	ShanghaiModel();
	virtual ~ShanghaiModel();

public:
	virtual void create();
	virtual void distrib();

	void distrib1();
	void distrib2();
	void distrib3();
	void distrib3(int x);
	void distrib4();
	void distrib5();

	void addSerieTuile(int level, double startColonne, double nc, double startLine, double nl);

public:		
	virtual bool action(::CardsRef pile, CardRef card);
	virtual bool select(::CardsRef pile, CardRef card);

	virtual bool selectable(ShanghaiTuileRef card);

	bool hasLeftAndRight(ShanghaiTuileRef tuile);
	bool hasOver(ShanghaiTuileRef tuile);

	virtual CardRef newCard();

public:
	virtual bool isGameOver();
	virtual bool isGameWin();

public:
	virtual const char* getRulesDistrib();
	virtual const char* getRulesPlay();

};

ImplementClass(ShanghaiView) : public CardGameView {
public:
	ShanghaiView();
	virtual ~ShanghaiView();

public:
	virtual void draw(GdiRef gdi);

};
