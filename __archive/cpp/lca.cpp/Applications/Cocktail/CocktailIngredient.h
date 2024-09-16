#pragma once

#include "CocktailObject.h"

ImplementClass(Ingredient) : public CocktailObject {
public:
	String m_type;

	double m_degreMini;

public:
	Ingredient();
	Ingredient(const char* type, const char* cl, const char* name, double degreMini=0);
	virtual ~Ingredient();

public:
	bool isAlcool();

};

ImplementClass(Ingredients) : public CocktailObjects {
public:
	virtual void init();
};

extern Ingredients m_ingredients;
