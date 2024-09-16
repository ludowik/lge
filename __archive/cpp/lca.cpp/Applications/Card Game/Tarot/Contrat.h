#pragma once

enum {
	Passe=0,
	Prise,
	Pousse,
	Garde,
	GardeSans,
	GardeContre
};

const char* getContrat(int iContrat);

double getScoreFor(int iNbBout);
double getPointFor(int iContrat);

int AskContrat(int iCurContrat);
