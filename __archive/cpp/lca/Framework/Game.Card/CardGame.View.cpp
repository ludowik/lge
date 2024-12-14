#include "System.h"
#include "CardGame.h"
#include "CardGame.view.h"

/* constructeur
 */
CardGameView::CardGameView() : ViewGame() {
	m_class = "CardGameView";
	
	/* largeur et hauteur de l'affichage */
	m_w = 0;
	m_h = 0;
	
	/* marge interne et externe */
	m_mo = System::Media::getMachineType()==iPad?10:0;
	m_mi = System::Media::getMachineType()==iPad?10:0;
	m_mc = System::Media::getMachineType()==iPad?10:0;
	
	/* largeur et hauteur d'une carte */
	m_wcard = 0;
	m_hcard = 0;
	
	/* rapport entre largeur et hauteur */
	bool mini = System::Media::getMachineType() == iPhone ? true : false;
	m_pwh1 = mini?4./5.:3./4.;
	m_pwh2 = mini?3./4.:2./3.;
	
	/* Delta entre deux cartes d'un même tas */
	m_pwc = .45;
	m_phc = .35;
}

void CardGameView::loadResource() {
}

void CardGameView::createUI() {
}

void CardGameView::createToolBar() {
	m_toolbar = (ToolBarControlRef)startPanel(0, new ToolBarControl()); {
		add(new ButtonControl("End"))->setListener(m_model, (FunctionRef)&ModelGame::onClose);
		add(new ButtonControl("New"))->setListener(m_model, (FunctionRef)&ModelGame::onNew);
		add(new ButtonControl("Auto"))->setListener(m_model, (FunctionRef)&ModelGame::onAutomate);
		add(new ButtonControl("Undo"))->setListener(m_model, (FunctionRef)&ModelGame::onUndoAction);
		add(new ButtonControl("Flip"))->setListener(this , (FunctionRef)&View::onFlip);
		add(new ButtonControl("Stat"))->setListener(m_model, (FunctionRef)&ModelGame::onStat);
		add(new ButtonControl("?"))->setListener(m_model, (FunctionRef)&ModelGame::onHelp);
	}
	endPanel();
}

void CardGameView::erase(GdiRef gdi) {
	return;
	
	Rect rect = gdi->m_rect;
	if ( gdi->isKindOf(classGdiOpenGL) ) {
		gdi->gradient(0, 0, rect.w, rect.h, eVertical, greenDark, white);
	}
	else if ( m_bgImage == 0 ) {
		m_bgImage = new Bitmap();
		m_bgImage->create(rect.w, rect.h);
		m_bgImage->gradient(0, 0, rect.w, rect.h, eVertical, greenDark, white);

		View::erase(gdi);
	}
}

void CardGameView::releaseGdi() {
	View::releaseGdi();

	if ( m_bgImage ) {
		delete m_bgImage;
		m_bgImage = 0;
	}
}

/* initialisation des variables d'affichage
 */
void CardGameView::calc(GdiRef gdi, double nw, double nh) {
	Rect rect = gdi->m_rect;

	/* zone d'affichage */
	m_x = 0;
	m_y = m_statusbar?m_statusbar->m_rect.bottom():0;
	
	m_w = rect.w;
	m_h = m_toolbar?m_toolbar->m_rect.top():rect.h;
	
	m_w -= m_x;
	m_h -= m_y;
	
	/* largeur et hauteur d'une carte */
	if ( System::Media::getOrientation() == orientationPortrait || nh == -1 ) {
		m_wcard = (int) ( ( m_w - ( nw - 1 ) * m_mi - 2 * m_mo - m_mc ) / ( nw ) );
		m_hcard = (int) ( ( m_wcard ) / ( m_pwh2 ) );
	}
	else {
		m_hcard = (int) ( ( m_h - 2 * m_mo - m_mc ) / ( nh ) );
		m_wcard = (int) ( ( m_hcard ) * ( m_pwh2 ) );
	}
	
	/* Delta entre deux cartes d'un même tas */
	m_dwc = (int)( m_wcard * m_pwc );
	m_dhc = (int)( m_hcard * m_phc );
}

void CardGameView::draw(GdiRef gdi) {
}

/* on dessine l'ensemble des tas
 */
void CardGameView::drawCardDeckList(GdiRef gdi, CardDeckList* zone, int x, int y, int zx, int zy, int cx, int cy, int cx2, int cy2, int show) {
	foreach_order ( CardsRef , cards , *zone , m_right2left ) {
		drawCards(gdi, cards, x, y, cx, cy, cx2, cy2, show);
		
		x += zx;
		y += zy;
	}

	if ( m_animation ) {
		AnimateCardRef animation = (AnimateCardRef)m_animation;
		
		CardsRef cards = &animation->m_cards;

		int x = cards->m_rect.x;
		int y = cards->m_rect.y;

		drawCards(gdi, cards, -x, -y, cx, cy, cx2, cy2, show);
	}
}

/* on dessine un tas
 */
void CardGameView::drawCards(GdiRef gdi, CardsRef pile, int _x, int _y, int _cx, int _cy, int _cx2, int _cy2, int show) {
	int wc = pile->m_wcard ? pile->m_wcard : m_wcard;
	int hc = pile->m_hcard ? pile->m_hcard : m_hcard;
	
	double x = _x >= 0 ? _x + m_x : -_x;
	double y = _y >= 0 ? _y + m_y : -_y;
	
	double cx = _cx;
	double cy = _cy;
 	
	double cx2 = _cx2 == -1 ? _cx / 3 : _cx2;
	double cy2 = _cy2 == -1 ? _cy / 3 : _cy2;
 	
	// on memorise l'emplacement des tas et des cartes
	pile->m_rect = Rect((int)x, (int)y, (int)wc, (int)hc);
	
	pile->m_cx = (int)cx;
	pile->m_cy = (int)cy;
	
	int n = pile->getCount();
	
	if ( n ) {
		Iterator iter = pile->getIterator();
		
		// Pour etre sur que les cartes non visible aurons un rectangle à 0
		while ( iter.hasNext() ) {
			CardRef card = (CardRef)iter.next();
			card->m_rect = Rect();
		}
		
		// On remet le compteur à 0
		iter.begin();
		
		int i = 0;
		
		// On passe les cartes qui ne seront pas visibles
		if ( show == -1 ) {
			show = n;
			
			if ( cx == 0 && cy == 0 && cx2 == -1 && cy2 == -1 ) {
				for ( ; i < n-1 ; ++i ) {
					iter.next();
				}
			}
			else if ( cx2 == 0 && cy2 == 0 ) {
				for ( ; i < n-1 ; ++i ) {
					CardRef card = (CardRef)iter.next();
					if ( card->m_reverse == false ) {
						break;
					}
				}
				iter.begin();
				for ( int j = 0 ; j < i ; ++j ) {
					iter.next();
				}	
			}
			
		}
		else {
			for ( ; i < n-show ; ++i ) {
				iter.next();
			}
		}
		
		// On adapte les decalages pour que toutes les cartes soient visibles
		int nreverse = 0;
		while ( iter.hasNext() ) {
			CardRef card = (CardRef)iter.next();
			if ( card->m_reverse ) {
				nreverse++;
			}
		}

		if ( cy || cy2 ) {
			int nvisible = n - nreverse - 1;
			int nover = (int)( y + nreverse * cy2 + nvisible * cy + hc - m_h );
		
			if ( nover > 0 && nvisible && cy && cy2 ) {
				if ( nreverse > 0 ) {
					cy2 -= (double)nover/(double)nreverse;
				}
				if ( cy2 <= 2 || nreverse == 0 ) {
					cy2 = _cy2==0?0:2;
					nover = (int)( y + nreverse * cy2 + nvisible * cy + hc - m_h );
					cy -= (double)nover/(double)nvisible;
				}
			}
		}
		
		// On affiches les cartes visibles
		iter.begin(i);
		while ( iter.hasNext() ) {
			CardRef card = (CardRef)iter.next();
			drawCard(gdi, card, pile, (int)x, (int)y, (int)wc, (int)hc, (int)cx, (int)cy);
			
			card->m_rect.x = (int)x;
			card->m_rect.y = (int)y;
			
			card->m_rect.w = wc;
			card->m_rect.h = hc;
			
			if ( !card->m_reverse ) {
				x += cx;
				if ( card->m_check )
					y += _cy;
				else
					y += cy;
			}
			else {
				x += cx2;
				y += cy2;
			}
		}
	}
	else {
		// Un tas vide
		drawCard(gdi, 0, pile, (int)x, (int)y, wc, hc);
	}
}

/* on dessine une carte
 */
void CardGameView::drawCard(GdiRef gdi, CardRef card, CardsRef pile, int x, int y, int w, int h, int cx, int cy) {
	gdi->draw(x, y, w, h, card, pile, cx, cy);
}

void CardGameView::movecard_draw(CardRef card, CardsRef from, CardsRef to) {
	m_animation = new AnimateCard(this, card, from, to);
	m_animation->initAnimation();

	while ( m_animation->iterAnimation() ) {
		System::Media::redraw();
	}

	m_animation->finishAnimation();

	delete m_animation;
	m_animation = 0;
}

bool CardGameView::touchBegin(int x, int y) {
	if ( View::touchBegin(x, y) ) {
		return true;
	}
	
	return onDrag(x, y, true);
}

bool CardGameView::touchMove(int x, int y) {
	if ( View::touchMove(x, y) ) {
		return true;
	}

	return onDrag(x, y, false);
}

bool CardGameView::touchEnd(int x, int y) {
	if ( View::touchEnd(x, y) ) {
		return true;
	}

	return false; // onDrop(x, y);
}

bool CardGameView::onDrag(int x, int y, bool init) {
	static int xs;
	static int ys;
	
	CardGameModel* model = (CardGameModel*)m_model;
	
	if ( init ) {
		if ( model->m_cardSelect && model->m_pileSelect ) {
			onDrop(x, y);
		}
		else {
			model->unselect();

			ObjectRef obj = get_object(x, y);
			if ( obj && obj->isKindOf("Card") ) {
				CardRef card = (CardRef)obj;
				CardsRef pile = model->getPile((CardRef)card);

				bool ret = model->select(pile, card);
				
				xs = x;
				ys = y;
				
				model->action(pile, card);
				
				return ret;
			}
		}
	}
	else {
		if ( model->m_cardSelect && model->m_pileSelect ) {
			CardRef card = model->m_cardSelect;
			CardsRef pile = model->m_pileSelect;

			m_animation = new AnimateCard(this, card, pile, 0);
			m_animation->initAnimation();

			AnimateCardRef animation = (AnimateCardRef)m_animation;

			animation->m_cards.m_rect.x = card->m_rect.x;
			animation->m_cards.m_rect.y = card->m_rect.y;

			xs -= card->m_rect.x;
			ys -= card->m_rect.y;

			Event event;
			do {
				getEvent(event, eAllTouchEvent);					
				if ( event.m_type == eTouchMove ) {
					animation->m_cards.m_rect.x = (int)( event.x - xs );
					animation->m_cards.m_rect.y = (int)( event.y - ys );

					System::Media::redraw();
				}
				else {					
					System::Event::waitEvent();
				}
			}
			while ( event.m_type == eTouchMove || ( event.m_type != eTouchEnd && event.m_type != eTouchBegin ) );

			m_animation->resetAnimation();

			delete m_animation;
			m_animation = 0;

			onDrop((int)event.x, (int)event.y);

			return true;
		}
	}

	return false;
}

bool CardGameView::onDrop(int x, int y) {	
	CardGameModel* model = (CardGameModel*)m_model;
	
	bool ret = false;

	ObjectRef obj = get_object(x, y);
	if ( obj ) {
		CardRef card = model->m_cardSelect;
		CardsRef pile = model->m_pileSelect;

		if ( obj->isKindOf("Card") ) {
			card = (CardRef)obj;
			pile = model->getPile((CardRef)card);
			
			ret = model->action(pile, card);
		}
		else {
			pile = (CardsRef)obj;      
			ret = model->action(pile, 0);
		}
		
		if ( ret ) {
			model->unselect();
			model->automatic(false);
		}
	}
	else {
		ret = model->action();
		
		if ( ret ) {
			model->unselect();
		}
	}
	
	return ret;
}

bool CardGameView::touchDoubleTap(int x, int y) {
	if ( View::touchDoubleTap(x, y) ) {
		return true;
	}
	
	CardGameModel* model = (CardGameModel*)m_model;
	
	ObjectRef obj = get_object(x, y);
	if ( obj ) {
		CardsRef pile = model->getPile((CardRef)obj);
		if ( pile ) {
			CardRef card = (CardRef)obj;
			model->automatic(pile, card, true);
		}
	}
	else {
		return model->automatic(true) > 0 ? true: false;
	}
	
	return false;
}

ObjectRef CardGameView::get_object(int x, int y) {
	CardGameModel* model = (CardGameModel*)m_model;
	
	foreach_reverse ( CardsRef , pile , model->m_piles ) {
		if ( pile->getCount() ) {
			foreach_reverse ( CardRef , card , *pile ) {
				if ( card != model->m_cardSelect && card->m_rect.contains(x, y) ) {
					return card;
				}
			}
		}
		else if ( pile->m_rect.contains(x, y) ) {
			return pile;
		}
	}
	
	return 0;
}
