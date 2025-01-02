#include "System.h"
#include "TarotView.h"
#include "TarotModel.h"
#include "Contrat.h"
#include "UserPanel.h"

ApplicationObject<TarotView, TarotModel> appTarot("Tarot", "Tarot", "tarot.png", 0, pageCardGame);

TarotView::TarotView() : CardGameView() {
}

void TarotView::loadResource() {
	m_resources.loadRes("pique.png");
	m_resources.loadRes("carreau.png");
	m_resources.loadRes("trefle.png");
	m_resources.loadRes("coeur.png");
}

void TarotView::createUI() {
	CardGameView::createUI();
	
	/*
	 m_pUsers[0] = (ControlRef)add(new UserPanel(Joueur1, "Nord"), posHCenter|posNextLine);
	 m_pUsers[1] = (ControlRef)add(new UserPanel(Joueur2, "Moi"), posWCenter|posRight);
	 m_pUsers[2] = (ControlRef)add(new UserPanel(Joueur3, "Sud"), posHCenter|posBottom);
	 m_pUsers[3] = (ControlRef)add(new UserPanel(Joueur4, "Ouest"), posWCenter|posLeft);
	 */
	
	/*
	 m_pPlisPreneur = (ControlRef)add(new UserPanel(Plis), posBottom|posLeft);
	 m_pPlisDefense = (ControlRef)add(new UserPanel(Plis), posBottom|posRight);  
	 */
	 {
		/*
		 m_pCards = (ControlRef)layout->add(new UserPanel(Jeu), posHCenter);
		 m_pCards->m_layout = posOver;
		 
		 m_pTapis = (ControlRef)layout->add(new UserPanel(Tapis), posHCenter|posNextLine);  
		 m_pChien = (ControlRef)layout->add(new UserPanel(Chien), posHCenter|posNextLine);
		 */
	}
}

void TarotView::draw(GdiRef gdi) {
	TarotModel* model = (TarotModel*)m_model;
	
	draw(gdi, model->m_pUsers[0]);
	draw(gdi, model->m_pUsers[1]);
	draw(gdi, model->m_pUsers[2]);
	draw(gdi, model->m_pUsers[3]);

	draw(gdi, model->m_pChien);

	draw(gdi, model->m_pTapis);
}

void TarotView::draw(GdiRef gdi, UserPanel* panel) {
	switch ( panel->m_type ) {
		case Joueur1:
		case Joueur2:
		case Joueur4:
		case Joueur3: {
			panel->Reverse(true);
			
			if ( !getCount() ) {
				gdi->rect(0, 0, m_rect.w, m_rect.h);
			}
			
			String csText = panel->m_csName;
			if ( TarotModel::m_pPartie->m_iDonneur == panel->m_type ) {
				csText += "*";
			}
			if ( TarotModel::m_pPartie->m_iPreneur == panel->m_type ) {
				csText += "\nPreneur";
			}
			if ( panel->m_csInfo.getLen() > 0 ) {
				csText += "\n";
				csText += panel->m_csInfo;
			}
			
			int fontSize = 24;
			
			Rect size = gdi->getTextSize(csText.getBuf(), 0, fontSize);
			
			int wt = size.w;
			int ht = size.h;
			
			Rect rect = gdi->m_rect;
			
			Point point;
			switch ( panel->m_type ) {
				case Joueur1:
					point = Point(divby2(rect.right())-divby2(wt), m_rect.bottom()+1);
					break;
				case Joueur2:
					point = Point(m_rect.x-wt-1, divby2(rect.bottom())-divby2(ht));
					break;
				case Joueur3:
					point = Point(divby2(rect.right())-divby2(wt), m_rect.y-ht-1);
					break;
				case Joueur4:
					point = Point(m_rect.right()+1, divby2(rect.bottom())-divby2(ht));
					break;
			}
			
			gdi->setFont(0, fontSize);
			
			gdi->text(point.x-m_rect.x,
					  point.y-m_rect.y, csText.getBuf());
			break;
		}
		case Tapis: {
			int i = TarotModel::m_pPartie->m_iFirst;
			
			int w = m_wcard;
			int h = divby2(m_hcard) + 4;
			
			foreach ( CardRef , pControl , *panel ) {
				Point point;
				switch ( i ) {
					case Joueur1: point = Point(m_rect.x     , m_rect.y-h); break;
					case Joueur2: point = Point(m_rect.x+w+10, m_rect.y  ); break;
					case Joueur3: point = Point(m_rect.x     , m_rect.y+h); break;
					case Joueur4: point = Point(m_rect.x-w-10, m_rect.y  ); break;
				}
				gdi->draw(point.x, point.y, m_wcard, m_hcard, pControl, panel);
				
				i = TarotModel::m_pPartie->User(i+1);
			}
			break;
		}
		case Chien: {
			drawCards(gdi, panel, 0, 0, m_wcard, 0);
			break;
		}
		case Plis: {
			double fVal = panel->getVal();
			if ( fVal > 0. ) {
				String csText;
				csText.format("%g", fVal);
				
				gdi->text(m_rect.x, m_rect.y, csText.getBuf());
			}
			break;
		}
	}
}
