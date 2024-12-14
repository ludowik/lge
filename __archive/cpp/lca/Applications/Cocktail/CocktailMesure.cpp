#include "System.h"
#include "CocktailMesure.h"

Mesure::Mesure(const char* cl, const char* name) : CocktailObject(cl, name) {
}

Mesure::~Mesure() {
}

Mesures m_mesures;

void Mesures::init() {
	m_name = "Mesures";

	add(new Mesure("unite" , "unité"));

	add(new Mesure("gousse", "gousse"));
	add(new Mesure("cl", "cl"));
	add(new Mesure("...", "selon les gouts"));
}
