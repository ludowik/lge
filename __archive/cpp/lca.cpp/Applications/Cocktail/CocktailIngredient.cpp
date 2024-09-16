#include "System.h"
#include "CocktailIngredient.h"

Ingredient::Ingredient(const char* type, const char* cl, const char* name, double degreMini) : CocktailObject(cl, name) {
	m_type = type;

	m_degreMini = degreMini;
}

Ingredient::~Ingredient() {
}

bool Ingredient::isAlcool() {
	return m_degreMini>0?true:false;
}

Ingredients m_ingredients;

void Ingredients::init() {
	m_name = "Ingredients";

	add(new Ingredient("whisky", "whisky", "Whisky", 40));
	add(new Ingredient("whiskey", "whiskey", "Whiskey", 40));
	add(new Ingredient("pastis", "pastis", "Pastis", 40));
	
	add(new Ingredient("rhum-blanc", "rhum", "Rhum blanc", 37.5));
	add(new Ingredient("rhum-vieux", "rhum", "Rhum vieux", 37.5));

	add(new Ingredient("rum", "rhum", "Rum-Verschnitt", 37.5));
		
	add(new Ingredient("eau-vie-vin", "eau-de-vie", "Eau-de-vie de vin", 37.5));
	add(new Ingredient("eau-vie-marc-raisin", "eau-de-vie", "Eau-de-vie de marc de raisin", 37.5));
	add(new Ingredient("eau-vie-marc-fruit", "eau-de-vie", "Eau-de-vie de marc de fruit", 37.5));
	add(new Ingredient("eau-vie-raisin", "eau-de-vie", "Eau-de-vie de raisin sec", 37.5));
	add(new Ingredient("eau-vie-fruit", "eau-de-vie", "Eau-de-vie de fruit", 37.5));
	add(new Ingredient("eau-vie-cidre", "eau-de-vie", "Eau-de-vie de cidre", 37.5));
	add(new Ingredient("eau-vie-poire", "eau-de-vie", "Eau-de-vie de poire", 37.5));
	add(new Ingredient("eau-vie-gentiane", "eau-de-vie", "Eau-de-vie de gentiane", 37.5));

	add(new Ingredient("gin", "gin", "Gin", 37.5));
	add(new Ingredient("akvavit", "aquavit", "Akvavit", 37.5));
	add(new Ingredient("aquavit", "aquavit", "Aquavit", 37.5));
	add(new Ingredient("vodka", "vodka", "Vodka", 37.5));
	add(new Ingredient("grappa", "grappa", "Grappa", 37.5));
	add(new Ingredient("ouzo", "ouzo", "Ouzo", 37.5));
	add(new Ingredient("kornbrand", "kornbrand", "Kornbrand", 37.5));

	add(new Ingredient("tequila", "tequila", "Tequila blanco", 37.5));
	add(new Ingredient("tequila-gold", "tequila", "Tequila gold", 37.5));
	add(new Ingredient("tequila-reposado", "tequila", "Tequila reposado", 37.5));
	add(new Ingredient("tequila-anejo", "tequila", "Tequila anejo", 37.5));
	
	add(new Ingredient("brandy", "brandy", "Brandy", 36));
	add(new Ingredient("anis", "anis", "Anis", 35));

	add(new Ingredient("spiritueux-carvi", "spiritueux-carvi", "Boisson spiritueuse au carvi (sauf akvavit/aquavit)", 30));
	add(new Ingredient("spiritueux-fruit", "spiritueux-fruit", "Boisson spiritueuse de fruit", 25));
	add(new Ingredient("spiritueux-anis", "spiritueux-anis", "Boisson spiritueuse anisee (sauf ouzo, pastis et anis)", 15));

	add(new Ingredient("jus-orange", "jus", "Jus d'orange"));
	add(new Ingredient("jus-ananas", "jus", "Jus d'ananas"));
	add(new Ingredient("jus-citron", "jus", "Jus de citron"));

	add(new Ingredient("sucre-blanc", "sucre", "Sucre"));
	add(new Ingredient("sucre-roux", "sucre", "Sucre roux"));
	add(new Ingredient("sucre-canne", "sucre", "Sucre de canne"));

	add(new Ingredient("sirop-canne", "sirop", "Sirop de canne"));

	add(new Ingredient("vanille", "vanille", "Vanille"));

	add(new Ingredient("noix-coco", "fruit", "Noix de coco"));
	add(new Ingredient("orange", "fruit", "Orange"));
	add(new Ingredient("citron", "fruit", "Citron"));
}
