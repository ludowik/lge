#pragma once

#include "CocktailObject.h"

ImplementClass(Accessoire) : public CocktailObject {
public:
	Accessoire(const char* cl, const char* name);
	virtual ~Accessoire();
};

ImplementClass(Accessoires) : public CocktailObjects {
public:
	virtual void init();
};

extern Accessoires m_accessoires;
