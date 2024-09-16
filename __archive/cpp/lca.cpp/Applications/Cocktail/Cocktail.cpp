#include "System.h"
#include "Cocktail.h"

Cocktail::Cocktail(const char* name) : CocktailObject("cocktail", name) {
}

Cocktail::~Cocktail() {
}

bool Cocktail::setVerre(const char* classVerre) {
	m_verre = (VerreRef)m_verres.get(classVerre);
	return false;
}

bool Cocktail::addIngredient(const char* classIngredient, double quantite, const char* classMesure) {
	return false;
}

bool Cocktail::addAccessoire(const char* classAccessoire) {
	return false;
}

Cocktails m_cocktails;

void Cocktails::init() {
	m_name = "Cocktails";

	CocktailRef cocktail = new Cocktail("Rhum coco");
	add(cocktail);
	
	cocktail->setVerre("bouteille");
	
	cocktail->addIngredient("rhum_blanc", 75, "cl");
	cocktail->addIngredient("noix_coco",  1, "unite");
	cocktail->addIngredient("vanille",  1, "gousse");
	cocktail->addIngredient("sucre_canne",  1, "...");
}

Sessions m_sessions;

ObjectRef Sessions::add(ObjectRef obj) {
	CocktailObjects* objs = (CocktailObjects*)obj;
	objs->init();
	return List::add(obj);
};

void Sessions::init() {
	add((ObjectRef)&m_ingredients);
	add((ObjectRef)&m_mesures);
	add((ObjectRef)&m_accessoires);
	add((ObjectRef)&m_verres);
	add((ObjectRef)&m_cocktails);
	add(new Cocktail("Rhum coco"));

}
