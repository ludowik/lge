#include "System.h"
#include "Contrat.h"

const char* getContrat(int iContrat) {
	switch ( iContrat ) {
		case Passe      : return "Passe";
		case Prise      : return "Prise";
		case Pousse     : return "Pousse";
		case Garde      : return "Garde";
		case GardeSans  : return "Garde sans";
		case GardeContre: return "Garde contre";
	}
	return "Erreur";
}

double getPointFor(int iContrat) {
	return 25;
}

double getScoreFor(int iNbBout) {
	switch ( iNbBout ) {
		case 0: return 56;
		case 1: return 51;
		case 2: return 41;
		case 3: return 36;
	}
	return 0;
}

int AskContrat(int iCurContrat) {
	// Choix d'un contrat
	View contrat;
	
	contrat.add(new StaticControl("Choix du contrat"));
	
	int iContrat = Passe;
	contrat.add(new RadioButtonControl("Passe", &iContrat, Passe), posNextLine);    
	
	switch ( iCurContrat ) {
		case Passe:
			contrat.add(new RadioButtonControl("Prise", &iContrat, Prise), posNextLine);
		case Prise:
			contrat.add(new RadioButtonControl("Pousse", &iContrat, Pousse), posNextLine);
		case Pousse:
			contrat.add(new RadioButtonControl("Garde", &iContrat, Garde), posNextLine);
		case Garde:
			contrat.add(new RadioButtonControl("Garde Sans", &iContrat, GardeSans), posNextLine);
		case GardeSans:
			contrat.add(new RadioButtonControl("Garde Contre", &iContrat, GardeContre), posNextLine);
	}
	
	contrat.add(new ButtonControl("OK"), posNextLine)->setListener(&contrat, (FunctionRef)&View::onClose);
	
	contrat.run();
	
	return iContrat;
}
