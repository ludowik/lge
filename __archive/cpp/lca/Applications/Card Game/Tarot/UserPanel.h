#pragma once

#define MK_CARREAU  0x0001
#define MK_TREFLE   0x0002
#define MK_COEUR    0x0004
#define MK_PIQUE    0x0008
#define MK_ATOUTS   0x0010

#define MK_COULEURS (MK_CARREAU|MK_COEUR|MK_TREFLE|MK_PIQUE)
#define MK_ALL      (MK_COULEURS|MK_ATOUTS)

enum {
	Joueur1=0,
	Joueur2,
	Joueur3,
	Joueur4,
	Chien,
	Tapis,
	Plis,
	Jeu
};

bool SiMeilleur(CardRef pBestCard, CardRef card, int clMasque=MK_ALL);

ImplementClass(UserPanel) : public Cards {
public:
	bool asValet;
	bool asCavalier;
	bool asDame;
	bool asRoi;
	bool asPetit;
	bool asGrand;
	bool asExcuse;
	
	int curCouleur;
	int curNbrCouleur;
	int curTotCouleur;
	
	int NbrAtouts;
	int NbrCarteParCouleur;
	
	bool m_bAuto;
	
	int MemoireCoupe[5];
	int MemoireJeu  [5];
	
	int m_type;
	
	String m_csName;
	String m_csInfo;
	
public:
	UserPanel(int type, const char* name=NULL);
	
public:
	virtual void Sort();
	
	int ContientCombienCouleur(int iFamily);
	
	bool ContientCarte(int iFamily, int iCard, int deb=-1, int len=-1);
	
	int Meilleur  (int clMasque);
	int MoinsBonne(int clMasque);
	
	bool TesteCarte(CardRef carte, int clMasque=MK_ALL);
	
	int CarteAJouer();
	int CarteAJouerProc();
	
	int TraitePetit(int iCarte1, bool bTest);
	
	bool Test1(int couleur);
	
	int getParole(int& cur, int iCurContrat);
	
	int getEvaluation1(int couleur);
	int getEvaluation2(int couleur);
	int getEvaluation3(int couleur);
	
	int getEvaluation(int couleur);
	int getEvaluation();
	
	int getVal();
	
	int getNbBout();
	
	void Reverse(bool ok);
	
};
