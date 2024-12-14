#include "System.h"
#include "TarotView.h"
#include "TarotModel.h"
#include "UserPanel.h"
#include "Contrat.h"

bool CouleurValide(int iFamily, int clMasque) {
	switch ( iFamily ) {
		case eCarreau: return clMasque & MK_CARREAU ? true : false;
		case eTrefle : return clMasque & MK_TREFLE  ? true : false;
		case eCoeur  : return clMasque & MK_COEUR   ? true : false;
		case ePique  : return clMasque & MK_PIQUE   ? true : false;
		case eAtout  : return clMasque & MK_ATOUTS  ? true : false;
	}
	
	return false;
}

int getMasque(int iFamily) {
	switch ( iFamily ) {
		case eCarreau: return MK_CARREAU;
		case eTrefle : return MK_TREFLE;
		case eCoeur  : return MK_COEUR;
		case ePique  : return MK_PIQUE;
		case eAtout  : return MK_ATOUTS;
	}
	
	return false;
}

bool SiMeilleur(CardRef pBestCard, CardRef card, int clMasque) {
	if ( !pBestCard ) {
		return true;
	}
	
	if ( !card ) {
		return false;
	}
	
	if ( CouleurValide(pBestCard->m_serie, clMasque) && CouleurValide(card->m_serie, clMasque) ) {
		if ( card->m_val == eExcuse )  {
			return false;
		}    
		else if ( pBestCard->m_val == eExcuse ) {
			return true;
		}
		
		if ( pBestCard->m_serie == card->m_serie ) {
			return ( card->m_val > pBestCard->m_val ) ? true : false;
		}
		
		if ( card->m_serie == eAtout ) {
			return true;
		}
		
		return false;
	}
	
	return false;
}

UserPanel::UserPanel(int type, const char* name) {
	m_csName = name;
	
	m_type = type;
	
	m_bAuto = true;
}

bool UserPanel::TesteCarte(CardRef card, int clMasque) {
	for ( int i = 0;i < getCount();++i ) {
		CardRef testCard = (CardRef)get(i);
		if ( CouleurValide(testCard->m_serie, clMasque) ) {
			if ( !SiMeilleur(testCard, card, clMasque) ) {
				return false;
			}
		}
	}
	
	return true;
}

int CompareCard(Object* pObject1, Object* pObject2) {
	CardRef pCard1 = (CardRef)pObject1;
	CardRef pCard2 = (CardRef)pObject2;
	
	if ( pCard1->m_serie == pCard2->m_serie ) {
		return pCard1->m_val - pCard2->m_val;
	}
	
	return pCard1->m_serie - pCard2->m_serie;
}

void UserPanel::Sort() {
	sort(CompareCard);
}

int UserPanel::ContientCombienCouleur(int iFamily) {
	int iCombien = 0;
	for ( int i = 0 ;i < getCount() ;++i ) {
		CardRef card = (CardRef)get(i);
		if ( card->m_serie == iFamily ) {
			iCombien++;
		}
	}
	return iCombien;
}

bool UserPanel::ContientCarte(int iFamily, int iCard, int iDeb, int iLen) {
	iDeb = ( iDeb == -1 ) ? 0 : iDeb;
	iLen = ( iLen == -1 ) ? getCount() : iLen;
	
	if ( iDeb < 0 || ( iDeb + iLen ) > getCount() ) {
		return false;
	}
	
	for ( int i = iDeb ;i < ( iDeb + iLen ) ;++i ) {
		CardRef card = (CardRef)get(i);
		if ( card->m_serie == iFamily && card->m_val == iCard ) {
			return true;
		}
	}
	
	return false;
}

int UserPanel::MoinsBonne(int clMasque) {
	if ( clMasque == MK_ALL || clMasque == MK_COULEURS ) {
		int itrefle  = MoinsBonne(MK_TREFLE );
		int icoeur   = MoinsBonne(MK_COEUR  );
		int icarreau = MoinsBonne(MK_CARREAU);
		int ipique   = MoinsBonne(MK_PIQUE  );
		int iatouts  = MoinsBonne(MK_ATOUTS );
		
		CardRef trefle  = itrefle !=-1?(CardRef)get(itrefle ):0;
		CardRef coeur   = icoeur  !=-1?(CardRef)get(icoeur  ):0;
		CardRef carreau = icarreau!=-1?(CardRef)get(icarreau):0;
		CardRef pique   = ipique  !=-1?(CardRef)get(ipique  ):0;
		CardRef atouts  = iatouts !=-1?(CardRef)get(iatouts ):0;
		
		CardRef bad = trefle;
		
		bad = bad ? ( coeur   ? ( bad->m_val > coeur  ->m_val ? coeur   : bad ) : bad ) : coeur  ;
		bad = bad ? ( carreau ? ( bad->m_val > carreau->m_val ? carreau : bad ) : bad ) : carreau;
		bad = bad ? ( pique   ? ( bad->m_val > pique  ->m_val ? pique   : bad ) : bad ) : pique  ;
		
		if ( !bad ) {
			if ( clMasque == MK_ALL ) {
				return iatouts;
			}
			return -1;
		}
		
		// Une gestion de l'excuse de base pour ne pas perdre de
		// points
		if ( bad->m_val > 11 && atouts && atouts->m_val == eExcuse ) {
			return iatouts;
		}
		if ( bad->m_val > 11 && atouts && atouts->m_val == ePetit==false ) {
			return iatouts;
		}
		if ( bad == trefle ) {
			return itrefle;
		}
		if ( bad == carreau ) {
			return icarreau;
		}
		if ( bad == coeur ) {
			return icoeur;
		}
		if ( bad == pique ) {
			return ipique;
		}
		if ( clMasque == MK_ALL ) {
			return iatouts;
		}
		
		return -1;
	}
	
	for ( int i = 0 ; i < getCount() ; ++i ) {
		CardRef card = (CardRef)get(i);
		
		if ( card->m_select && CouleurValide(card->m_serie, clMasque) ) {
			if ( card->m_val == ePetit ) {
				if ( TarotModel::m_pPartie->firstCard && TarotModel::m_pPartie->firstfamily != eAtout && ( TarotModel::m_pPartie->Last == false || TarotModel::m_pPartie->OnGagne ) ) {
					/*
					 int nbr = Memoire->ContientCombienCouleur(firstfamily);
					 */
					if ( MemoireJeu  [TarotModel::m_pPartie->firstfamily-1] ||
						MemoireCoupe[TarotModel::m_pPartie->firstfamily-1] /*|| nbr<=10*/ ) {
						continue;
					}
				}
			}
			return i;
		}
		continue;
	}
	return -1;
}

bool UserPanel::Test1(int couleur) {
	return (   TarotModel::m_pPartie->Defausse
            || (TarotModel::m_pPartie->Defense && TarotModel::m_pPartie->AttaqueAJoue)
            || (TarotModel::m_pPartie->Attaque && TarotModel::m_pPartie->DefenseAJoue)
			|| MemoireCoupe[couleur-1] == false ? true : false );
}

int UserPanel::Meilleur(int clMasque) {
	if ( clMasque == MK_ALL || clMasque == MK_COULEURS ) {
		int itrefle  = Test1(eTrefle ) ? Meilleur(MK_TREFLE ) : -1;
		int icoeur   = Test1(eCoeur  ) ? Meilleur(MK_COEUR  ) : -1;
		int icarreau = Test1(eCarreau) ? Meilleur(MK_CARREAU) : -1;
		int ipique   = Test1(ePique  ) ? Meilleur(MK_PIQUE  ) : -1;
		
		int iatouts  = MoinsBonne(MK_ATOUTS);
		
		CardRef trefle  = ( itrefle  != -1 ) ? (CardRef)get(itrefle ) : 0;
		CardRef coeur   = ( icoeur   != -1 ) ? (CardRef)get(icoeur  ) : 0;
		CardRef carreau = ( icarreau != -1 ) ? (CardRef)get(icarreau) : 0;
		CardRef pique   = ( ipique   != -1 ) ? (CardRef)get(ipique  ) : 0;
		
		CardRef good = trefle;
		
		good = good ? ( coeur   ? ( good->m_val < coeur  ->m_val ? coeur   : good ) : good ) : coeur  ;
		good = good ? ( carreau ? ( good->m_val < carreau->m_val ? carreau : good ) : good ) : carreau;
		good = good ? ( pique   ? ( good->m_val < pique  ->m_val ? pique   : good ) : good ) : pique  ;
		
		if ( !good ) {
			if ( clMasque == MK_ALL ) {
				return iatouts;
			}
			return -1;
		}
		
		if ( good == trefle ) {
			return itrefle;
		}
		if ( good == carreau ) {
			return icarreau;
		}
		if ( good == coeur ) {
			return icoeur;
		}
		if ( good == pique ) {
			return ipique;
		}
		if ( clMasque == MK_ALL ) {
			return iatouts;
		}
		
		return -1;
	}
	
	int choix = -1;
	
	for ( int i = 0 ;i < getCount() ;++i ) {
		CardRef card = (CardRef)get(i);
		
		if ( card->m_select &&
			CouleurValide(card->m_serie, clMasque) &&
			( TarotModel::m_pPartie->Defausse || TarotModel::m_pTapis->TesteCarte(card) ) &&
			( TarotModel::m_pPartie->Defausse || TarotModel::m_pPartie->Last || TarotModel::m_pPartie->Defense && TarotModel::m_pPartie->AttaqueAJoue /*||Joueur->Memoire->TesteCarte(card, getMasque(card->m_serie))*/ ) ) {
			if ( card->m_val == ePetit ) {
				if ( TarotModel::m_pPartie->firstCard && TarotModel::m_pPartie->firstfamily != eAtout && ( TarotModel::m_pPartie->Last == false || TarotModel::m_pPartie->OnGagne ) ) {
					/*
					 int nbr = Joueur->Memoire->ContientCombienCouleur(TarotModel::m_pPartie->firstfamily);
					 if (nbr>10) {
					 continue;
					 }
					 */
				}
			}
			if ( card->m_val == eExcuse && choix != -1 ) {
				continue;
			}
			choix = i;
		}
	}
	
	if ( choix != -1 ) {
		CardRef card = (CardRef)get(choix);
		if ( card->m_serie == eAtout && ( clMasque == MK_ALL || clMasque == MK_ATOUTS ) ) {
			MoinsBonne(MK_ATOUTS);
		}
		
		return choix;
	}
	
	return -1;
}

int UserPanel::TraitePetit(int iCard, bool bTest) {
	if ( iCard != -1 ) {
		CardRef card = (CardRef)get(iCard);
		if ( card->m_val == ePetit && bTest ) {
			card->m_select = false;
			int iCard2 = MoinsBonne(MK_ALL);
			card->m_select = true;
			
			if ( iCard2 != -1 ) {
				return iCard2;
			}
		}
	}
	
	return iCard;
}

int UserPanel::CarteAJouer() {
	int i = CarteAJouerProc();
	if ( i==-1 ) {
		for ( i = 0 ;i < getCount() ;++i ) {
			CardRef card = (CardRef)get(i);
			if ( card->m_select ) {
				return i;
			}
		}
	}
	
	return i;
}

int UserPanel::CarteAJouerProc() {
	int iCard;
	
	// Premiere card
	if ( TarotModel::m_pPartie->First || ( TarotModel::m_pPartie->firstCard->m_val == eExcuse && TarotModel::m_pTapis->getCount() == 1 ) ) {
		// Attaque
		if ( TarotModel::m_pPartie->Attaque ) {
			iCard = Meilleur(MK_COULEURS);
			if ( iCard != -1 ) {
				return TraitePetit(iCard, getCount()>1);
			}
			
			iCard = MoinsBonne(MK_COULEURS);
			if ( iCard != -1 ) {
				return TraitePetit(iCard, getCount()>1);
			}
			
			iCard = MoinsBonne(MK_ATOUTS);
			if ( iCard != -1 ) {
				return TraitePetit(iCard, getCount()>1);
			}
			
			return -1;
		}
		
		// Defense
		iCard = MoinsBonne(MK_COULEURS);
		if ( iCard != -1 ) {
			return TraitePetit(iCard, getCount()>1);
		}
		
		iCard = MoinsBonne(MK_ATOUTS);
		if ( iCard != -1 ) {
			return TraitePetit(iCard, getCount()>1);
		}
		
		return -1;
	}
	
	// Derniere carte
	if ( TarotModel::m_pPartie->Last ) {
		// Attaque
		if ( TarotModel::m_pPartie->Attaque ) {
			if ( TarotModel::m_pPartie->firstfamily == eAtout && TarotModel::m_pPartie->firstCard->m_val != eExcuse ) {
				iCard = MoinsBonne(getMasque(TarotModel::m_pPartie->firstfamily));
			}
			else {
				iCard = Meilleur(getMasque(TarotModel::m_pPartie->firstfamily));
			}
			
			if ( iCard != -1 ) {
				return TraitePetit(iCard, TarotModel::m_pTapis->TesteCarte((CardRef)get(iCard))==false);
			}
			
			iCard = MoinsBonne(getMasque(TarotModel::m_pPartie->firstfamily));
			if ( iCard != -1 ) {
				return TraitePetit(iCard, TarotModel::m_pPartie->DefenseGagne);
			}
			
			iCard = MoinsBonne(MK_ALL);
			if ( iCard != -1 ) {
				return iCard;
			}
			
			return -1;
		}
		
		// Si defense
		if ( TarotModel::m_pPartie->Defausse ) {
			iCard = Meilleur(MK_CARREAU|MK_TREFLE|MK_COEUR|MK_PIQUE);
		}
		else if ( TarotModel::m_pPartie->firstfamily == eAtout && TarotModel::m_pPartie->firstCard->m_val != eExcuse ) {
			iCard = MoinsBonne(getMasque(TarotModel::m_pPartie->firstfamily));
		}
		else {
			iCard = Meilleur(getMasque(TarotModel::m_pPartie->firstfamily));
		}
		
		if ( iCard != -1 ) {
			return TraitePetit(iCard, TarotModel::m_pPartie->AttaqueGagne&&TarotModel::m_pTapis->TesteCarte((CardRef)get(iCard))==false);
		}
		
		iCard = MoinsBonne(getMasque(TarotModel::m_pPartie->firstfamily));
		if ( iCard != -1 ) {
			return iCard;
		}
		
		return -1;
	}
	// Au milieu
	else {
		// Attaque
		if ( TarotModel::m_pPartie->Attaque ) {
			if ( TarotModel::m_pPartie->firstfamily == eAtout && TarotModel::m_pPartie->firstCard->m_val != eExcuse ) {
				iCard = MoinsBonne(getMasque(TarotModel::m_pPartie->firstfamily));
			}
			else {
				iCard = Meilleur(getMasque(TarotModel::m_pPartie->firstfamily));
			}
			
			if ( iCard!=-1 ) {
				return TraitePetit(iCard, TarotModel::m_pPartie->DefenseGagne);
			}
			
			iCard = MoinsBonne(getMasque(TarotModel::m_pPartie->firstfamily));
			if ( iCard != -1 ) {
				return TraitePetit(iCard, TarotModel::m_pPartie->DefenseGagne);
			}
			
			iCard = MoinsBonne(MK_ALL);
			if ( iCard != -1 ) {
				return iCard;
			}
			
			return -1;
		}
		
		// Si defense et attaque a joue
		if ( TarotModel::m_pPartie->AttaqueAJoue ) {
			if ( TarotModel::m_pPartie->Defausse ) {
				iCard = Meilleur(MK_CARREAU|MK_TREFLE|MK_COEUR|MK_PIQUE);
			}
			
			if ( TarotModel::m_pPartie->firstfamily == eAtout && TarotModel::m_pPartie->firstCard->m_val != eExcuse ) {
				iCard = MoinsBonne(getMasque(TarotModel::m_pPartie->firstfamily));
			}
			else {
				iCard = Meilleur(getMasque(TarotModel::m_pPartie->firstfamily));
			}
			
			if ( iCard != -1 ) {
				return TraitePetit(iCard, TarotModel::m_pPartie->AttaqueGagne&&TarotModel::m_pTapis->TesteCarte((CardRef)get(iCard))==false);
			}
			
			iCard = MoinsBonne(getMasque(TarotModel::m_pPartie->firstfamily));
			if ( iCard != -1 ) {
				return iCard;
			}
			
			return -1;
		}
		
		// Si defense et attaque n'a pas joue
		iCard = MoinsBonne(MK_ALL);
		if ( iCard != -1 ) {
			return TraitePetit(iCard, 1);
		}
		
		return -1;
	}
	
	return -1;
}

//------------------------------------------------------------------------------
// Formule d'evaluation
// Quelques rËgles de base :
// 1. Compter 5 pour un roi
//    Compter 4 pour une dame si possËde le roi
//    Compter 3 pour un cavalier si possËde le roi et la dame
//            2 sinon
//    Compter 2 pour un valet si possËde le roi et la dame et le cavalier
//            1 sinon
//    Max pour une couleur (1)-> +14 * 4 = +56
//    Min pour une couleur (1)-> + 0 * 4 = + 0        
// 2. Si 0 bout compter  0+ 0 Minimum=56 56-56= 0   
//       1 bout compter  5+ 5 Minimum=51 56-51= 5
//       2 bout compter 10+15 Minimum=41 56-41=15
//       3 bout compter 15+20 Minimum=36 56-36=20
//    Max pour l'atout (1)-> +35 = +35
//    Min pour l'atout (1)-> + 0 = + 0    
int UserPanel::getEvaluation1(int couleur) {
	int v = 0;
	switch (couleur)    {
		case eAtout: {
			int nbBouts = (asPetit?1:0)+(asGrand?1:0)+(asExcuse?1:0);
			v += nbBouts*5;
			switch (nbBouts) {
				case 1: 
					v += 5;
					break;
				case 2: 
					v += 15;
					break;
				case 3: 
					v += 20;
					break;
			}
			break ;
		}
		default:     {
			if (asRoi)
				v += 5;
			if (asDame)  
				v += 4;
			if (asCavalier)  
				v += asRoi&&asDame?3:2;
			if (asValet)  
				v += asRoi&&asDame&&asCavalier?2:1;
			break ;
		}
	}  
	return v;
}

//------------------------------------------------------------------------------
// 3. Prendre en compte le nombre de carte dans la couleur pour evaluer
//    la valeur des têtes ? Si beaucoup de carte risque de ne pas passer
//    les têtes...
//    Max pour une couleur (2)-> + 0 * 4 = + 0
//    Min pour une couleur (2)-> - 3 * 4 = -12
//    Max pour l'atout     (2)-> +15     = +15
//    Min pour l'atout     (2)-> - 5     = - 5
int UserPanel::getEvaluation2(int couleur) {
	int v = 0;
	switch (couleur)    {
		case eAtout: {
			double nbrAtoutsMoyen = NbrAtouts/TarotModel::m_nbPlayer;
			if (curNbrCouleur<nbrAtoutsMoyen-6)
				v -= 15;
			if (curNbrCouleur<nbrAtoutsMoyen-4)
				v -= 10;
			if (curNbrCouleur<nbrAtoutsMoyen-2)
				v -=  5;
			else if (curNbrCouleur<nbrAtoutsMoyen-0)
				v +=  5;
			else if (curNbrCouleur<nbrAtoutsMoyen+2)
				v +=  5;
			else if (curNbrCouleur<nbrAtoutsMoyen+4)
				v += 10;
			else  
				v += 15;
			break;
		}
		default:     {
			double nbrCartesMoyen = NbrCarteParCouleur/TarotModel::m_nbPlayer;//+1
			if (curNbrCouleur<nbrCartesMoyen+0)
				break;
			else if (curNbrCouleur<nbrCartesMoyen+1)
				v -= 2;
			else if (curNbrCouleur<nbrCartesMoyen+2)
				v -= 4;
			else if (curNbrCouleur<nbrCartesMoyen+3)
				v -= 8;
			else if (curNbrCouleur<nbrCartesMoyen+4)
				v -= 4;
			else if (curNbrCouleur<nbrCartesMoyen+5)
				v -= 2;
			break;
		}
	}  
	return v;
}

//------------------------------------------------------------------------------
// 4. Si nombre d'atouts < 22/NbJoueurs et petit en plus retirer N2
//    Max pour une couleur (3)-> + 0 * 4 = + 0
//    Min pour une couleur (3)-> + 0 * 4 = + 0
//    Max pour l'atout     (3)-> + 0     = + 0
//    Min pour l'atout     (3)-> -10     = -10
int UserPanel::getEvaluation3(int couleur) {
	int v = 0;
	switch (couleur)    {
		case eAtout: {
			double nbrAtoutsMoyen = NbrAtouts/TarotModel::m_nbPlayer;
			if (curNbrCouleur<nbrAtoutsMoyen&&asPetit)
				v -= 10;
			else if (curNbrCouleur==nbrAtoutsMoyen&&asPetit)
				v -= 5;
			break;
		}
	}
	return v;
}

//------------------------------------------------------------------------------
int UserPanel::getEvaluation(int couleur) {
	if (!curCouleur)
		return 0;
	int v = 0;
	v += getEvaluation1(couleur);
	v += getEvaluation2(couleur);
	v += getEvaluation3(couleur);
	return v;
}

//------------------------------------------------------------------------------
// AprËs calcul comparer le resultat ‡ un tableau
//   Res < X1 alors rien
//   Res < X2 alors prise si aucune enchËre sinon passe
//   Res < X3 alors garde si aucune enchËre superieure ‡ la prise sinon passe
//   Res < X4 alors garde sans si aucune enchËre superieure ‡ la garde sinon passe
//   Res < X5 alors garde contre si aucune enchËre superieure ‡ la garde sans sinon passe
int UserPanel::getEvaluation() {
	curCouleur = 0;
	curNbrCouleur = 0;
	curTotCouleur = 0;
	
	asValet    = false;
	asCavalier = false;
	asDame     = false;
	asRoi      = false;
	asPetit    = false;
	asGrand    = false;
	asExcuse   = false;
	
	int v = 0;
	
	CardRef carte = (CardRef)get(0);
	
	curCouleur = carte->m_serie;
	
	for ( int i = 0 ; i < getCount() ; ++i ) {
		carte = (CardRef)get(i);
		if (curCouleur!=carte->m_serie) {
			v += getEvaluation(curCouleur);
			
			curCouleur = carte->m_serie;
			curNbrCouleur = 0;
			curTotCouleur = 0;
			asValet    = false;
			asCavalier = false;
			asDame     = false;
			asRoi      = false;
			asPetit    = false;
			asGrand    = false;
			asExcuse   = false;
		}
		curNbrCouleur++;
		curTotCouleur += carte->m_val;
		switch (carte->m_serie)    {
			case eAtout: {
				switch (carte->m_val)   {
					case  1: asPetit  = true; break;
					case 21: asGrand  = true; break;
					case 22: asExcuse = true; break;
				} 
				break;
			}
			default:     {
				switch (carte->m_val)   {
					case 11: asValet    = true; break;
					case 12: asCavalier = true; break;
					case 13: asDame     = true; break;
					case 14: asRoi      = true; break;
				} 
				break;
			}
		}  
		continue;
	}
	v += getEvaluation(curCouleur);
	return v;
}

//------------------------------------------------------------------------------
int UserPanel::getParole(int& cur, int iCurContrat) {
	int iContrat = 0;
	
	if ( m_bAuto ) {
		cur = getEvaluation();
		
		int base=35;
		
		if ( cur < base + 00 ) {
			iContrat = Passe;
		}
		else if ( cur < base + 05 ) {
			iContrat = Prise;
		}
		else if ( cur < base + 10 ) {
			iContrat = Garde;
		}
		else if ( cur < base + 18 ) {
			iContrat = GardeSans;
		}
		else {
			iContrat = GardeContre;
		}
	}
	else {
		iContrat = AskContrat(iCurContrat);
	}
	
	m_csInfo = getContrat(iContrat);
	
	if ( iContrat > iCurContrat ) {
		return iContrat;
	}
	
	return 0;
}

int UserPanel::getVal() {
	// TODO : évaluation du jeu ?
	return 0;
}

int UserPanel::getNbBout() {
	int iNbBout = 0;
	for ( int i = 0;i < getCount();++i ) {
		CardRef testCard = (CardRef)get(i);
		if (   testCard->m_val == ePetit
			|| testCard->m_val == 21
			|| testCard->m_val == eExcuse ) {
			iNbBout++;
		}
	}
	return iNbBout;
}

void UserPanel::Reverse(bool ok) {
	for ( int i = 0;i < getCount();++i ) {
		CardRef card = (CardRef)get(i);
		card->m_reverse = ok;
	}
}
