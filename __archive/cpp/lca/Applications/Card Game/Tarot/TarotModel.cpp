#include "System.h"
#include "TarotView.h"
#include "TarotModel.h"
#include "Contrat.h"
#include "UserPanel.h"

TarotModel* TarotModel::m_pPartie = NULL;

UserPanel* TarotModel::m_pTapis = NULL;

int TarotModel::m_nbPlayer;
int TarotModel::m_nbCarteDansLeChien;

TarotModel::TarotModel() : CardGameModel() {
	m_iState = TarotsRegChargementJeu;
	
	m_nbPlayer = 4;
	m_nbCarteDansLeChien = 6;
	
	m_pPartie = this;
	
	m_pPlisPreneur = NULL;
	m_pPlisDefense = NULL;
	
	m_pUsers[0] = new UserPanel(Joueur1, "Nord");
	m_pUsers[1] = new UserPanel(Joueur2, "Moi");
	m_pUsers[2] = new UserPanel(Joueur3, "Sud");
	m_pUsers[3] = new UserPanel(Joueur4, "Ouest");
	
	m_sUsers[0] = 0;
	m_sUsers[1] = 0;
	m_sUsers[2] = 0;
	m_sUsers[3] = 0;
	
	m_pPlisPreneur = new UserPanel(Plis);
	m_pPlisDefense = new UserPanel(Plis);
	
	m_pCards = new UserPanel(Jeu);
	
	m_pTapis = new UserPanel(Tapis);
	m_pChien = new UserPanel(Chien);
	
	m_iDonneur = -1;
	m_iPreneur = -1;
	
	m_iFirst = -1;
	m_iCurrent = -1;
	
	m_pCurrent = NULL;
	
	m_bAuto = false;
	
	m_pUsers[1]->m_bAuto = m_bAuto;
	
	m_pCards->createTarot();
}

TarotModel::~TarotModel() {
	delete m_pUsers[0];
	delete m_pUsers[1];
	delete m_pUsers[2];
	delete m_pUsers[3];
	
	delete m_pPlisPreneur;
	delete m_pPlisDefense;
	
	delete m_pCards;
	
	delete m_pTapis;
	delete m_pChien;
}

void TarotModel::init() {
	InitTour();
	
	m_iPreneur = -1;
	
	m_iContrat = Passe;
	
	for ( int i = 0 ; i < m_nbPlayer ; ++i ) {
		m_pCards->adds(m_pUsers[i]);
	}
	
	m_pCards->adds(m_pTapis);
	m_pCards->adds(m_pChien);
	m_pCards->adds(m_pPlisPreneur);
	m_pCards->adds(m_pPlisDefense);
	
	m_pCards->coupe();
	
	m_iState = TarotsRegInitDonneur;
}

void TarotModel::ChargementJeu() {
}

void TarotModel::NouveauJeu() {
}

void TarotModel::InitDonneur() {
	SetState(TarotsRegMelangeJeu);
}

void TarotModel::MelangeJeu() {
	m_pCards->mix();
	SetState(TarotsRegDebutDePartie);
}

void TarotModel::DebutDePartie() {
	SetDonneur(m_iDonneur+1);
	
	int iUser = User(m_iDonneur+1);
	
	while ( m_pCards->getFirst() ) {
		for ( int i = 0 ; i < 3 ; ++i ) {
			CardRef card = (CardRef)m_pCards->getFirst();
			
			card->m_reverse = true;
			movecard(card, m_pCards, m_pUsers[iUser], false);
		}
		
		if ( m_pChien->getCount() < m_nbCarteDansLeChien ) {
			CardRef card = (CardRef)m_pCards->getFirst();
			
			card->m_reverse = true;
			movecard(card, m_pCards, m_pChien, false);
		}
		
		iUser = User(iUser+1);
	}
	
	m_pChien->Reverse(true);
	
	for ( int i = 0 ; i < m_nbPlayer ; ++i ) {
		m_pUsers[i]->Sort();
	}
	
	SetState(TarotsRegAnnonce);
}

void TarotModel::Annonce() {
	int preneur = -1;
	int cur = 0;
	int parole = User(m_iDonneur+1);
	
	int i = 0;
	
	for ( ; i < m_nbPlayer ; ++i ) {
		int iChoice = m_pUsers[parole]->getParole(cur, m_iContrat);
		if ( iChoice > m_iContrat ) {
			preneur = parole;
			m_iContrat = iChoice;
		}
		
		parole = User(parole+1);
	}
	
	for ( i = 0 ; i < m_nbPlayer ; ++i ) {
		m_pUsers[i]->m_csInfo = "";
	}
	
	if ( preneur >= 0 ) {
		if ( preneur == 1 ) {
			m_pChien->Reverse(false);
		}
		
		SetPreneur(preneur);
		SetState(TarotsRegRetourneChien);
	}
	else {
		SetState(TarotsRegRemiseEnPlaceDuJeu);
	}
}

void TarotModel::RetourneChien() {
	SetState(TarotsRegPriseDuChien);
}

void TarotModel::PriseDuChien() {
	m_pPreneur->add(m_pChien);
	m_pPreneur->Sort();
	
	SetState(TarotsRegEcart);
}

void TarotModel::Ecart(CardRef card) {
	if ( m_pPreneur->m_bAuto ) {
		FaireEcart();
		SetState(TarotsRegBeginTour);
	}
	else {
		if ( card ) {
			if ( card->m_serie != eAtout && card->m_val != Card::roi ) {
				CardsRef parent = getPile(card);
				if ( parent == m_pPreneur ) {
					if ( m_pChien->getCount() < m_nbCarteDansLeChien ) {
						card->m_reverse = false;
						movecard(card, parent, m_pChien);
					}
				}
				else {
					card->m_reverse = false;
					movecard(card, parent, m_pPreneur);
					
					m_pPreneur->Sort();
				}
				
				SetState(TarotsRegEcart);
			}
		}
		else if ( m_pChien->getCount() == m_nbCarteDansLeChien ) {
			m_pPlisPreneur->add(m_pChien);
			
			SetState(TarotsRegBeginTour);
		}
	}
}

void TarotModel::FaireEcart() {
	int passage  = 0;
	int nbrChien = 0;
	
	while ( nbrChien != m_nbCarteDansLeChien ) {
		int indice = 0;
		
		for ( ; nbrChien < m_nbCarteDansLeChien &&  indice < m_pPreneur->getCount() ; ++indice ) {
			CardRef card = (CardRef)m_pPreneur->get(indice);
			
			if ( passage < 2 && card->m_serie == eAtout ) {
				break;
			}
			
			if ( passage == 0 ) {
				int refCouleur = card->m_serie;
				int nbrCouleur = m_pPreneur->ContientCombienCouleur(refCouleur);
				
				bool hasRoi = m_pPreneur->ContientCarte(refCouleur, 
														14, 
														indice, 
														m_pPreneur->getCount()-indice);
				
				if ( hasRoi == true || nbrCouleur > ( m_nbCarteDansLeChien - nbrChien ) ) {
					indice++;
					for ( ; indice < m_pPreneur->getCount() ; ++indice ) {
						CardRef pCard2 = (CardRef)m_pPreneur->get(indice);
						if ( pCard2->m_serie != refCouleur ) {
							break;
						}
					}
					indice--;
					continue;
				}
			}
			else if ( passage == 1 ) {
				int refCouleur = card->m_serie;
				int nbrCouleur = m_pPreneur->ContientCombienCouleur(refCouleur);
				
				if ( card->m_val == Card::roi || nbrCouleur > m_nbCarteDansLeChien-nbrChien ) {
					indice++;
					for ( ; indice < m_pPreneur->getCount() ; ++indice ) {
						CardRef pCard2 = (CardRef)m_pPreneur->get(indice);            
						if ( pCard2->m_serie != refCouleur ) {
							break;
						}
					}
					
					indice--;
					
					continue;
				}
			}
			else if ( passage == 2 ) {
				if ( card->m_val == Card::roi || card->m_serie == eAtout ) {
					continue;
				}
			}
			
			nbrChien++;
			
			indice--;
			
			card->m_reverse = true;
			movecard(card, m_pPreneur, m_pChien);
		}
		passage++;
	}
	
	m_pChien->Reverse(true);
	
	m_pChien->Reverse(false);
	m_pPlisPreneur->add(m_pChien);
}

void TarotModel::BeginTour() {
	InitTour();                  
	CanPlay(m_pCurrent, m_pTapis);
	SetState(TarotsRegJoueCarte);
}

void TarotModel::JoueCarte(CardRef card) {
	if ( m_pCurrent->m_bAuto ) {
		First = m_pTapis->getCount() == 0 ? true : false;
		Last = m_pTapis->getCount() == m_nbPlayer-1;
		
		Attaque = m_iCurrent == m_iPreneur;
		Defense = !Attaque;
		
		int i = m_pCurrent->CarteAJouer();
		
		PlayCard((CardRef)m_pCurrent->get(i));
	}
	else if ( card ) {
		if ( card->m_select ) {
			PlayCard(card);
		}
	}
}

void TarotModel::JoueurSuivant() {
	if ( m_pTapis->getCount() == m_nbPlayer ) {
		SetState(TarotsRegEndTour);
	}
	else {
		NextUser();
		CanPlay(m_pCurrent, m_pTapis);
		SetState(TarotsRegJoueCarte);
	}
}

void TarotModel::EndTour()
{	
	if ( m_iPreneur == Winner ) {
		m_pPlisPreneur->add(m_pTapis);
	}
	else {
		m_pPlisDefense->add(m_pTapis);
	}
	
	SetWinner(Winner);
	
	if ( m_pCurrent->getCount()==0 ) {
		SetState(TarotsRegFinDePartie);
	}
	else
	{    
		SetState(TarotsRegBeginTour);
	}
}

void TarotModel::FinDePartie() {
	ShowScore();
}

void TarotModel::RemiseEnPlaceDuJeu() {
	init();
}

bool TarotModel::action() {
	return action(0, 0);
}

bool TarotModel::action(CardsRef pile, CardRef card) {
	switch ( m_iState ) {
		case TarotsRegInitDonneur: {
			InitDonneur();
			break;
		}
		case TarotsRegMelangeJeu: {
			MelangeJeu();
			break;
		}
		case TarotsRegDebutDePartie: {
			DebutDePartie();
			break;
		}
		case TarotsRegAnnonce: {
			Annonce();
			break;
		}
		case TarotsRegRetourneChien: {
			RetourneChien();
			break;
		}
		case TarotsRegPriseDuChien: {
			PriseDuChien();
			break;
		}
		case TarotsRegEcart: {
			Ecart(card);
			break;
		}
		case TarotsRegBeginTour: {
			BeginTour();
			break;
		}
		case TarotsRegJoueCarte: {
			JoueCarte(card);
			break;
		}
		case TarotsRegJoueurSuivant: {
			JoueurSuivant();
			break;
		}
		case TarotsRegEndTour: {
			EndTour();
			break;
		}
		case TarotsRegFinDePartie: {
			FinDePartie();
			break;
		}
		case TarotsRegRemiseEnPlaceDuJeu: {
			RemiseEnPlaceDuJeu();
			break;
		}
	}
	
	return false;
}

void TarotModel::ShowScore() {
	double preneur = 45;
	double defense = 46;
	
	int bout = 2;
	
	if ( m_pPlisPreneur ) {
		preneur = m_pPlisPreneur->getVal();
		defense = m_pPlisDefense->getVal();
		
		bout = m_pPlisPreneur->getNbBout();
	}
	
	double contrat = getScoreFor(bout);
	
	double ecart = preneur - contrat;
	
	double pointsajoutes = ( ecart >= 0 ? 1 : -1 ) * getPointFor(m_iContrat);
	
	double point = ecart + pointsajoutes;
	
	for ( int i = 0 ; i < 4 ; ++i ) {
		if ( i == m_iPreneur )
			m_sUsers[i] += point * 3;
		else
			m_sUsers[i] -= point;
	}
	
	View dialog;
	
	dialog.add(new StaticControl("Score"));
	
	dialog.add(new StaticControl("Bouts"), posNextLine|posHCenter|posRightAlign);
	dialog.add(new IntegerControl(bout, 4), posHCenter|posLeftAlign)->m_layoutText = posRightAlign;
	
	dialog.add(new StaticControl("Points"), posNextLine|posHCenter|posRightAlign);
	dialog.add(new FloatControl(preneur, 4), posHCenter|posLeftAlign)->m_layoutText = posRightAlign;
	
	dialog.add(new StaticControl("Contrat"), posNextLine|posHCenter|posRightAlign);
	dialog.add(new FloatControl(contrat, 4), posHCenter|posLeftAlign)->m_layoutText = posRightAlign;
	
	dialog.add(new StaticControl("Gain"), posNextLine|posHCenter|posRightAlign);
	dialog.add(new FloatControl(ecart, 4), posHCenter|posLeftAlign)->m_layoutText = posRightAlign;
	
	dialog.add(new StaticControl("Gain du contrat"), posNextLine|posHCenter|posRightAlign);
	dialog.add(new FloatControl(pointsajoutes, 4), posHCenter|posLeftAlign)->m_layoutText = posRightAlign;
	
	dialog.add(new StaticControl("Score"), posNextLine|posHCenter|posRightAlign);
	dialog.add(new FloatControl(point, 4), posHCenter|posLeftAlign)->m_layoutText = posRightAlign;
	
	dialog.add(new ButtonControl("OK"), posNextLine|posRight);
	
	dialog.run();
	
	for ( int i = 0 ; i < 4 ; ++i ) {
		dialog.add(new StaticControl(m_pUsers[i]->m_csName), posNextLine|posHCenter);
		dialog.add(new FloatControl(m_sUsers[i], 4), posHCenter|posLeftAlign)->m_layoutText = posRight;
	}

	dialog.add(new ButtonControl("OK"), posNextLine|posHCenter);
	dialog.run();

	SetState(TarotsRegRemiseEnPlaceDuJeu);
}

void TarotModel::SetState(int iState) {
	m_iState = iState;
}

int TarotModel::WhoWin(UserPanel* pTapis) {
	int i = 0;
	int iWinner = 0;
	
	CardRef pBestCard = NULL;
	
	foreach ( CardRef , card , *pTapis ) {
		if ( SiMeilleur(pBestCard, card) ) {
			pBestCard = card;
			iWinner = i;
		}
		i++;
	}
	
	return User(iWinner+m_iFirst);
}

void TarotModel::CanPlay(UserPanel* pUser, UserPanel* pTapis) {
	int iTheFamily = -1;
	int iTheMaxAtout = -1;
	
	int iMyMaxAtout = -1;
	
	// Initialisation et mon atout max
	foreach ( CardRef , card , *pUser ) {
		if ( card->m_serie == eAtout ) {
			iMyMaxAtout = max(iMyMaxAtout, card->m_val);
		}
		card->m_select = card->m_val == eExcuse ? true : false;
	}
	
	// Famille demande et atout max pose
	foreach_nodecl ( CardRef , card , *pTapis ) {
		card->m_select = false;
		if ( card->m_val != eExcuse ) {
			if ( iTheFamily==-1 ) {
				iTheFamily = card->m_serie;
			}
			if ( card->m_serie == eAtout ) {
				iTheMaxAtout = max(iTheMaxAtout, card->m_val);
			}
		}
	}
	
	if ( iTheFamily==-1 ) {
		// Le premier ‡ jouer
		foreach ( CardRef , card , *pUser ) {
			card->m_select = true;
		}
	}
	else {
		// Peut-on jouer la famille demandee ?
		int nb = 0;
		foreach ( CardRef , card , *pUser ) {
			if ( card->m_serie == iTheFamily && card->m_val != eExcuse ) {
				if ( card->m_serie != eAtout || card->m_val > iTheMaxAtout || iMyMaxAtout < iTheMaxAtout ) {
					card->m_select = true;
					nb++;
				}
			}
		}
		
		if ( nb==0 ) {
			// L'utilisateur n'a pas la famille demandee
			
			if ( iTheFamily==eAtout || iMyMaxAtout==-1 ) {
				// eAtout demande, je pisse
				foreach ( CardRef , card , *pUser ) {
					if ( card->m_serie!=eAtout ) {
						card->m_select = true;
					}
				}
			}
			else {
				// Autre famille demande, je coupe
				foreach ( CardRef , card , *pUser ) {
					if ( card->m_serie==eAtout ) {
						if ( card->m_val>iTheMaxAtout || iMyMaxAtout<iTheMaxAtout ) {
							card->m_select = true;
						}
					}
				}
			}
		}
	}
}

void TarotModel::InitTour() {
	AttaqueAJoue = false;
	DefenseAJoue = false;
	
	Attaque = false;
	Defense = false;
	
	First = true;
	Last = false;
	
	Winner = -1;
	
	AttaqueGagne = false;
	DefenseGagne = false;
	
	OnGagne = false;
	
	Defausse = false;
	
	firstCard = NULL;  
	firstfamily = -1;  
}

void TarotModel::PlayCard(CardRef card) {
	ControlRef pUser = (ControlRef)getPile(card);  
	foreach ( CardRef , pUserCard , *pUser ) {
		pUserCard->m_select = false;
	}
	
	card->m_reverse = false;
	movecard(card, m_pTapis);
    
	if ( m_iCurrent==m_iPreneur ) {
		AttaqueAJoue = true;
	}
	if ( m_iCurrent!=m_iPreneur ) {
		DefenseAJoue = true;
	}
	
	Winner = WhoWin(m_pTapis);
	
	AttaqueGagne = Winner == m_iPreneur;
	DefenseGagne = !AttaqueGagne;
	
	OnGagne = Defense && AttaqueAJoue && DefenseGagne;
	
	Defausse = AttaqueAJoue && DefenseGagne;
	
	firstCard = (CardRef)m_pTapis->get(0);
	firstfamily = firstCard->m_serie;
	
	SetState(TarotsRegJoueurSuivant);
}

void TarotModel::SetDonneur(int iUser) {
	m_iDonneur = User(iUser);
	m_iFirst = User(m_iDonneur+1);
	m_iCurrent = m_iFirst;
}

void TarotModel::SetPreneur(int iUser) {
	m_iPreneur = User(iUser);
	
	m_pCurrent = m_pUsers[m_iCurrent];
	m_pPreneur = m_pUsers[m_iPreneur];
}

void TarotModel::SetWinner(int iUser) {
	m_iFirst = User(iUser);
	m_iCurrent = m_iFirst;
	m_pCurrent = m_pUsers[m_iCurrent];
}

void TarotModel::NextUser() {
	m_iCurrent = User(m_iCurrent+1);  
	m_pCurrent = m_pUsers[m_iCurrent];
}

int TarotModel::User(int iUser) {
	while ( iUser<0 ) {
		iUser += m_nbPlayer;
	}
	iUser = iUser % m_nbPlayer;
	
	return iUser;
}

void TarotModel::OnTest() {
	m_bAuto = true;
}

