#pragma once

#include "CocktailObject.h"

#include "CocktailIngredient.h"
#include "CocktailAccessoire.h"
#include "CocktailMesure.h"
#include "CocktailVerre.h"

ImplementClass(Sessions) : public List {
public:
	virtual ObjectRef add(ObjectRef obj);
	virtual void init();
	
};

extern Sessions m_sessions;

ImplementClass(Cocktail) : public CocktailObject {
public:
	VerreRef m_verre;
	
	Ingredients m_ingredients;
	
	Accessoires m_accessoire;
	
public:
	Cocktail(const char* nom);
	virtual ~Cocktail();
	
public:
	bool setVerre(const char* classVerre);
	
	bool addIngredient(const char* classIngredient, double quantite, const char* classMesure);
	bool addAccessoire(const char* classAccessoire);
	
public:
	String getRecette();

};

ImplementClass(Cocktails) : public CocktailObjects {
public:
	virtual void init();
};

extern Cocktails m_cocktails;
