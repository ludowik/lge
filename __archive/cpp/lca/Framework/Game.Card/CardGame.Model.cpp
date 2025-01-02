#include "System.h"
#include "CardGame.h"

/* constructeur vide
 - initialisation carte et pile selectionnee
 */
CardGameModel::CardGameModel() {
	m_class = "CardGameModel";

	m_piles.m_delete = false;
	
	m_pileSelect = 0;
	m_cardSelect = 0;
	
	m_canAutomate = true;
}

CardGameModel::~CardGameModel() {
}

/* initialiation du jeu
 - creation
 - distribution
 */
void CardGameModel::init() {
	ModelGame::init();
	
	range();

	if ( m_cards.getCount() == 0 ) {
		create();
	}
	
	distrib();
}

/* creation du jeu
 - creation d'un jeu de 52 cartes
 - melange du jeu
 */
void CardGameModel::create() {
	m_cards.create52();
	m_cards.mix();
}

/* liberation du jeu
 - rangement 
 - liberation à partir du tas
 */
void CardGameModel::release() {
	ModelGame::release();
	range();
	m_cards.releaseAll();
}

/* base de la distribution du jeu 
 - faire pointer toutes les piles sur le modele
 - ranger les cartes
 - melanger les cartes
 fonction devant être derive
 */
void CardGameModel::distrib() {
	foreach ( CardsRef , pile , m_piles ) {
		pile->m_model = this;
	}
	
	range();
	m_cards.mix();
}

/* ranger les cartes
 - remmettre toutes les cartes dans le tas
 - remmettre toutes les cartes dans le même sens
 */
void CardGameModel::range() {
	foreach ( CardsRef , pile , m_piles ) {
		m_cards.adds(pile);
	}
	
	m_cards.reverse(true);
}

/* gestion d'une action (click sur une carte)
 Si une carte est selectionnee et que le deplacement est possible
 - deplacement de la suite
 - memorisation du mouvement
 - deselection
 Sion
 - selection de la carte
 Sinon  
 */
bool CardGameModel::action() {
	return false;
}

bool CardGameModel::action(CardsRef pile, CardRef card) {
	if ( m_cardSelect && m_pileSelect != pile ) {
		if ( pile->canMoveTo(m_pileSelect, m_cardSelect) ) {
			if ( pile && pile->isKindOf("CardGameSerie") ) {
				m_score.cardInSerie();
			}
			if ( m_pileSelect && m_pileSelect->isKindOf("CardGameSerie") ) {
				m_score.cardOutOfSerie();
			}
			
			startSubActions(); {
				CardsRef pileSelect = m_pileSelect;
				pushAction(new MoveListAction(this, m_cardSelect, m_pileSelect, pile));
				CardRef last = pileSelect->getLast();
				if ( last && last->m_reverse ) {
					pushAction(new ReverseCardAction(last, false));
				}
			}
			endSubActions();
			
			unselect();
			
			return true;
		}
		else {
			unselect();
		}
	}
	else {
		select(m_pileSelect, m_cardSelect);
	}
	
	return false;
}

/* selection d'une suite ou marquage de la carte si suite impossible
 - selection des cartes une par une
 - validation de la selection et de la suite a chaque iteration
 - chaque carte est marquee
 - on memorise la "premiere" carte de la suite
 - on memorise la pile
 */
bool CardGameModel::select(CardsRef pile, CardRef card) {
	Iterator iter = pile->getIterator();
	iter.end();
	
	CardRef previous = 0;
	CardRef current = 0;
	
	while ( iter.hasPrevious() ) {
		current = (CardRef)iter.previous();
		
		if ( current->m_reverse ) {
			break;
		}
		
		if ( previous ) {
			if ( !pile->canFollow(current, previous) ) {
				break;
			}
		}
		
		current->m_select = true;
		m_cardSelect = current;
		
		if ( card == current ) {
			break;
		}
		
		previous = current;
	}
	
	if ( card == m_cardSelect ) {
		m_pileSelect = pile;
		return true;
	}
	
	unselect();
	card->m_check = true;
	
	return false;
}

/* deselection de toutes les cartes
 - iteration sur toutes les piles
 - deselection de toutes les cartes d'une pile
 - initialisation de la "premiere" carte
 - initialisation de la pile
 */
void CardGameModel::unselect() {
	foreach ( CardsRef , pile , m_piles ) {
		pile->select(false);
		pile->checked(false);
	}
	
	m_cardSelect = 0;
	m_pileSelect = 0;
}

/* decoche de toutes les cartes
 - iteration sur toutes les piles
 - decoche de toutes les cartes d'une pile
 */
void CardGameModel::uncheck() {
	foreach ( CardsRef , pile , m_piles ) {
		pile->checked(false);
	}
}

/* recherche de la pile parente
 - iteration sur toutes les piles
 - recherche de la carte dans une pile
 - renvoie de la bonne pile, null le cas echeant
 */
CardsRef CardGameModel::getPile(CardRef card) {
	foreach ( CardsRef , pile , m_piles ) {
		if ( pile->getIndex(card) != -1 ) {
			return pile;
		}
	}
	
	if ( m_cards.getIndex(card) != -1 ) {
		return &m_cards;
	}
	
	return 0;
}

/* deplacement d'une carte vers une pile
 - recherche de la pile de depart
 - appel de la methode adaptee
 */
void CardGameModel::movecard(CardRef card, CardsRef to, bool show) {
	CardsRef from = getPile(card);
	if ( from == to ) {
		return;
	}
	unselect();
	
	movecard(card, from, to, show);
}

/* deplacement d'une carte vers une pile
 - retire la carte de sa pile
 - ajout de la carte dans la nouvelle pile
 - execution des regles automatiques
 - gestion de l'affichage
 */
void CardGameModel::movecard(CardRef card, CardsRef from, CardsRef to, bool show) {
	CardGameView* view = (CardGameView*)m_view;
	if ( show ) {
		view->movecard_draw(card, from, to);
	}
	else {
		from->remove(card);		
		to->add(card);

		from->automatic(false);
		to->automatic(false);
	}
}

/* deplacement d'une suite vers une pile
 - recherche de la pile de depart
 - appel de la methode adaptee
 */
void CardGameModel::movelist(CardRef card, CardsRef to, bool show) {
	CardsRef from = getPile(card);
	if ( from == to ) {
		return;
	}
	unselect();  
	
	movelist(card, from, to, show);
}

/* deplacement d'une suite vers une pile
 - recherche de la "premiere" carte de la suite dans la pile
 - deplacement des cartes de la suite une par une
 - execution des regles automatiques
 */
void CardGameModel::movelist(CardRef card, CardsRef from, CardsRef to, bool show) {
	to->move(card, from);
	
	from->automatic(false);
	to->automatic(false);
}

/* regles automatiques
 */
int CardGameModel::automatic(bool user) {
	return 0;
}

/* regles automatiques
 */
int CardGameModel::automatic(CardsRef from, CardRef card, bool user) {
	return 0;
}

/* gestion automatique
 - execution des regles automatiques
 - execution action si le joueur a gagne
 - execution action si le joueur a perdu
 - renvoie true si au moins une action
 */
bool CardGameModel::idle() {
	if ( isGameWin() ) {
		gameWin();
		return true;
	}
	else if ( isGameOver() ) {
		gameOver();
		return true;
	}
	
	return false;
}

/* sauvegarde du jeu
 */
bool CardGameModel::save(File& file) {
	if ( ModelGame::save(file) ) {
		int npiles = m_piles.getCount();
		file << npiles;
		
		foreach ( CardsRef , pile , m_piles ) {
			
			file << pile->getCount();
			
			foreach ( CardRef, card , *pile ) {
				card->save(file);
			}
		}
		file << m_talon.m_tourDeTalon;
		return true;
	}
	
	return false;
}

/* chargement du jeu
 */
bool CardGameModel::load(File& file) {
	if ( ModelGame::load(file) ) {
		int npiles = 0;
		file >> npiles;
		
		if ( npiles == m_piles.getCount() ) {
			release();		
			
			foreach ( CardsRef , pile , m_piles ) {
				
				int ncards = 0;
				file >> ncards;
				
				for ( int i = 0 ; i < ncards ; ++i ) {
					CardRef card = newCard();
					card->load(file);
					pile->add(card);
				}
			}
			file >> m_talon.m_tourDeTalon;
			return true;
		}
	}
	return false;
}

CardRef CardGameModel::newCard() {
	return new Card();
}

bool CardGameModel::onHelp(ObjectRef obj) {
	View view;
	if ( !m_view->g_gdi->isKindOf(classGdiOpenGL) ) {
		view.m_bgImage = m_view->g_gdi;
	}
	
	view.m_text = "Help";
	
	view.startPanel(posHCenter)->m_opaque = true; {
		String str;
		str.format("<center>%s</center></nl>"\
			       "<left>%s</left></nl>"\
				   "<center>%s</center></nl>"\
			       "<left>%s</left>",
			  CardGameModel::getRulesDistrib(), getRulesDistrib(),
			  CardGameModel::getRulesPlay(), getRulesPlay());
		
		view.add(new RichTextControl(str), posNextLine|posRightExtend);

		view.add(new ButtonControl("OK"), posNextLine|posWCenter)->setListener(&view, (FunctionRef)&View::onClose);
	}	
	view.endPanel();
	
	view.run();

	return true;
}

const char* CardGameModel::getRulesDistrib() {
	return label("Game", "RulesDistrib");
}

const char* CardGameModel::getRulesPlay() {
	return label("Game", "RulesPlay");
}
