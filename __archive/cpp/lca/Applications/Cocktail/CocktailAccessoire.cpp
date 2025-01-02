#include "System.h"
#include "CocktailAccessoire.h"

Accessoire::Accessoire(const char* cl, const char* name) : CocktailObject(cl, name) {
}

Accessoire::~Accessoire() {
}

Accessoires m_accessoires;

void Accessoires::init() {
	m_name = "Accessoires";
	
	add(new Accessoire("verre", "Verre a melange"));
	add(new Accessoire("shaker", "shaker"));
	add(new Accessoire("mixeur", "mixeur"));
}
