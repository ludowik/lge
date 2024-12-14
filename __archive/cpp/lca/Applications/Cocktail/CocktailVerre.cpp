#include "System.h"
#include "CocktailVerre.h"

Verre::Verre(const char* cl, const char* name) : CocktailObject(cl, name) {
}

Verre::~Verre() {
}

Verres m_verres;

void Verres::init() {
	m_name = "Verres";

	add(new Verre("shot", "Shot"));
	add(new Verre("martini", "Verre a martini"));
	add(new Verre("degustation", "Verre a degustation"));
	add(new Verre("vin", "Verre a vin"));
	add(new Verre("flute", "Flute"));
	add(new Verre("shot", "Shot"));
	add(new Verre("rocks", "Rocks"));
	add(new Verre("highball", "Highball"));
	add(new Verre("toddy", "Toddy"));
	add(new Verre("bouteille", "Bouteille"));
}
