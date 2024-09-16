#pragma once

#include "CardGame.Model.h"
#include "UserPanel.h"

enum {
	TarotsRegChargementJeu=0,
	TarotsRegNouveauJeu,
	TarotsRegInitDonneur,
	TarotsRegMelangeJeu,
	TarotsRegDebutDePartie,
	TarotsRegAnnonce,
	TarotsRegRetourneChien,
	TarotsRegPriseDuChien,
	TarotsRegEcart,
	TarotsRegBeginTour,
	TarotsRegJoueCarte,
	TarotsRegJoueurSuivant,
	TarotsRegEndTour,
	TarotsRegFinDePartie,
	TarotsRegRemiseEnPlaceDuJeu
};

ImplementClass(TarotModel) : public CardGameModel {
public:
	static TarotModel* m_pPartie;
	
	static UserPanel* m_pTapis;
	
	static int m_nbPlayer;
	static int m_nbCarteDansLeChien;
	
public:
	UserPanel* m_pCards;
	
	int m_iState;
	
	int m_iDonneur;
	int m_iPreneur;
	int m_iContrat;
	
	int m_iFirst;
	int m_iCurrent;  
	
	UserPanel* m_pUsers[4];
	double m_sUsers[4];
	
	UserPanel* m_pCurrent;
	UserPanel* m_pPreneur;
	
	UserPanel* m_pChien;
	
	UserPanel* m_pPlisPreneur;
	UserPanel* m_pPlisDefense;
	
	bool AttaqueAJoue;
	bool DefenseAJoue;
	
	bool Attaque;
	bool Defense;
	
	bool First;
	bool Last;
	
	int Winner;
	
	bool AttaqueGagne;
	bool DefenseGagne;
	
	bool OnGagne;
	
	bool Defausse;
	
	CardRef firstCard;
	
	int firstfamily;
	
	bool m_bAuto;
	
public:
	TarotModel();
	virtual ~TarotModel();
	
public:
	void ChargementJeu();
	void NouveauJeu();
	void InitDonneur();
	void MelangeJeu();
	void DebutDePartie();
	void Annonce();
	void RetourneChien();
	void PriseDuChien();
	void Ecart(CardRef card);
	void BeginTour();
	void JoueCarte(CardRef card);
	void JoueurSuivant();
	void EndTour();
	void FinDePartie();
	void RemiseEnPlaceDuJeu();
	
public:
	virtual void init();
	
	virtual bool action();
	virtual bool action(Cards* pile, CardRef card);
	
	virtual void OnTest();
	
public:
	void SetDonneur(int iUser);
	void SetPreneur(int iUser);
	void SetWinner (int iUser);
	
	void NextUser();
	
	int User(int iUser);
	
	void SetState(int iState);
	
	void FaireEcart();
	
	void CanPlay(UserPanel* pUser, UserPanel* pHand);
	
	void InitTour();
	void PlayCard(CardRef card);
	
	int WhoWin(UserPanel* pTapis);
	
	void ShowScore();
	
};
