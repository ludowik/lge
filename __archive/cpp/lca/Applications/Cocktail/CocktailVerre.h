#pragma once

#include "CocktailObject.h"

ImplementClass(Verre) : public CocktailObject {
public:
	Verre(const char* cl, const char* name);
	virtual ~Verre();
	
};

ImplementClass(Verres) : public CocktailObjects {
public:
	virtual void init();

};

extern Verres m_verres;
