#pragma once

#include "CocktailObject.h"

ImplementClass(Mesure) : public CocktailObject {
public:
	Mesure(const char* cl, const char* nom);
	virtual ~Mesure();
	
};

ImplementClass(Mesures) : public CocktailObjects {
public:
	virtual void init();
};

extern Mesures m_mesures;
