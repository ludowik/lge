#include "System.h"

#include "Board.Model.h"
#include "Board.View.h"

BoardView::BoardView() : ViewGame() {
	m_wcell = 0;
	m_hcell = 0;

	m_annoted = false;
	m_allowMove = false;
	
	m_marge = 10;
}

void BoardView::createUI() {
	GameBoardModel* model = (GameBoardModel*)m_model;
	calc(0, model->m_cMax, model->m_lMax);
}

void BoardView::createToolBar() {
	m_toolbar = (ToolBarControlRef)startPanel(0, new ToolBarControl()); {
		add(new ButtonControl("End"))->setListener(m_model, (FunctionRef)&ModelGame::onClose);
		add(new ButtonControl("New"))->setListener(m_model, (FunctionRef)&ModelGame::onNew);
		add(new ButtonControl("Auto"))->setListener(m_model, (FunctionRef)&ModelGame::onAutomate);
		add(new ButtonControl("Undo"))->setListener(m_model, (FunctionRef)&ModelGame::onUndoAction);
		add(new ButtonControl("Flip"))->setListener(this , (FunctionRef)&View::onFlip);
		add(new ButtonControl("?"))->setListener(m_model, (FunctionRef)&ModelGame::onHelp);
	}
	endPanel();
}

void BoardView::addResource(const char* id) {
	m_resources.loadRes(id, m_wcell*9/10, m_hcell*9/10);
}

void BoardView::calc(GdiRef gdi, int nw, int nh) {
	Rect rect = System::Media::getWindowsSize();
	
	int sh = m_statusbar?m_statusbar->m_rect.h:0;
	int th = m_toolbar?m_toolbar->m_rect.h:0;

	int wcell1 = (int)divby( rect.w - 2 * m_marge           , nw );
	int wcell2 = (int)divby( rect.h - 2 * m_marge - sh - th , nh );

	m_wcell = max(wcell1, wcell2);
	if ( ( m_wcell * nw + 2 * m_marge ) >= rect.w ||
		 ( m_wcell * nh + 2 * m_marge + sh + th ) >= rect.h ) {
		m_wcell = min(wcell1, wcell2);
	}

	m_hcell = m_wcell;
}

void BoardView::draw(GdiRef gdi) {
	GameBoardModel* model = (GameBoardModel*)m_model;

	calc(gdi, model->m_cMax, model->m_lMax);

	Rect rect = gdi->m_rect;

	int w = rect.w;
	int h = rect.h;

	int sh = m_statusbar?m_statusbar->m_rect.h:0;
	int th = m_toolbar?m_toolbar->m_rect.h:0;
	
	drawCells(gdi,
		(0 +(w      -m_wcell*model->m_cMax)/2),
		(sh+(h-sh-th-m_hcell*model->m_lMax)/2), m_wcell, m_hcell, model);
}

void BoardView::drawCells(GdiRef gdi, int _x, int _y, int wcell, int hcell, BoardModel* model) {
	int m_cMax = model->m_cMax;
	int m_lMax = model->m_lMax;
	
	int x = 0;
	int y = 0;

	bool selected = false;
	fromto(int, i, 0, 2) {
		x = _x;
		y = _y;
		
		for ( int c = 0 ; c < m_cMax ; ++c ) {
//		for ( int c = m_cMax-1 ; c >= 0 ; --c ) {
			y  = _y;
//			for ( int _l = 0 ; _l < m_lMax ; ++_l ) {
			for ( int _l = m_lMax-1 ; _l >= 0 ; --_l ) {
				int l;
				if ( m_right2left )
					l = m_lMax-1-_l;
				else
					l = _l;
				
				CellRef cell = model->get(c, l);
				if ( cell->m_selected == selected ) {
					cell->m_rect.x = x;
					cell->m_rect.y = y;
					
					cell->m_rect.w = wcell;
					cell->m_rect.h = hcell;
					
					cell->draw(gdi);
				}
				
				y += hcell;
			}
			x += wcell;
		}
		selected = true;
	}
	
	if ( m_annoted && model->get(0, 0) ) {
		String csText;
		
		Color clrAnnotation = red;
		
		CellRef cell;
		for ( int c = 0 ; c < m_cMax ; ++c ) {
			csText.format("%c", 'A' + c);
			
			cell = model->get(c, 0);
			
			Rect textSize = gdi->getTextSize(csText.getBuf());
			Rect rect = gdi->m_rect;

			x = cell->m_rect.x - rect.x + cell->m_rect.w / 2 - textSize.w / 2;
			y = _y - textSize.h / 2;
			
			gdi->text(x, y, csText.getBuf(), clrAnnotation);
		}
		
		for ( int _l = 0 ; _l < m_lMax ; ++_l ) {
			int l;
			if ( m_right2left )
				l = m_lMax-1-_l;
			else
				l = _l;
			csText.format("%ld", 1 + l);
			
			cell = model->get(0, l);
			
			Rect textSize = gdi->getTextSize(csText.getBuf());
			Rect rect = gdi->m_rect;

			x = _x - textSize.w / 2;
			y = cell->m_rect.y - rect.y + cell->m_rect.h / 2 - textSize.h / 2;
			
			gdi->text(x, y, csText.getBuf(), clrAnnotation);
		}
	}
}

bool BoardView::touchMove(int x, int y) {
	if ( View::touchMove(x, y) ) {
		return true;
	}
	
	if ( m_allowMove ) {
		ObjectRef obj = get_object(x, y);
		if ( obj ) {
			return onTouch(obj);
		}
	}
	
	return false;
}

bool BoardView::touchBegin(int x, int y) {
	if ( View::touchBegin(x, y) ) {
		return true;
	}
	
	ObjectRef obj = get_object(x, y);
	if ( obj ) {
		return onTouch(obj);
	}
	
	GameBoardModel* model = (GameBoardModel*)m_model;
	
	model->unselect();
	
	return true;
}

bool BoardView::onTouch(ObjectRef obj) {
	bool ret = false;
	
	GameBoardModel* model = (GameBoardModel*)m_model;
	
	if ( obj->isKindOf("Cell") ) {
		CellRef cell = (CellRef)obj;
		ret = model->action(cell);
	}
	
	model->automatic(false);
	
	return ret;
}

ObjectRef BoardView::get_object(int x, int y) {
	GameBoardModel* model = (GameBoardModel*)m_model;
	
	foreach_reverse ( CellRef , cell , model->m_cells ) {
		if ( cell->m_rect.contains(x, y) ) {
			return cell;
		}
	}
	
	return 0;
}

