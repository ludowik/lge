#include "System.h"
#include "Notes.h"

ApplicationObject<NotesView, NotesModel> appNotes("Notes", "Notes", "notes.png");

NotesView::NotesView() {
	m_ctrl = 0;
}

void NotesView::createUI() {
	m_notes = add(new Control());
}

void NotesView::createToolBar() {
	startPanel(0, new ToolBarControl()); {
		add(new ButtonControl("End"))->setListener(this, (FunctionRef)&View::onClose);
		add(new ButtonControl("New"))->setListener(this, (FunctionRef)&NotesView::onNew);
		add(new ButtonControl("Undo"))->setListener(this, (FunctionRef)&NotesView::onUndo);
		add(new ButtonControl("New Line"))->setListener(this, (FunctionRef)&NotesView::onNewLine);
	}
	endPanel();
}

bool NotesView::onNew(ObjectRef obj) {
	m_notes->releaseAll();
	return true;
}

bool NotesView::onUndo(ObjectRef obj) {
	int n = m_notes->getCount();
	if ( n > 0 ) {
		m_notes->remove(n-1);
		return true;
	}
	return false;
}

bool NotesView::onNewLine(ObjectRef obj) {
	m_notes->add(new ShapeControl(), posNextLine);
	return true;
}

void NotesView::draw(GdiRef gdi) {
	View::draw(gdi);
	
	if ( m_ctrl ) {
		m_ctrl->draw(gdi);
	}
}

bool NotesView::touchBegin(int x, int y) {
	if ( View::touchBegin(x, y) == false ) {
		m_ctrl = new ShapeControl();
		m_ctrl->m_points.add(new Point(x, y));
	}
	
	return true;
}

bool NotesView::touchMove(int x, int y) {
	if ( m_ctrl ) {
		m_needsRedrawAutomatic = false;

		Event event;				
		do {
			getEvent(event, eAllTouchEvent);
			
			if ( event.m_type == eTouchMove ) {
				x = (int)event.x;
				y = (int)event.y;

				m_ctrl->m_points.add(new Point(x, y));

				System::Media::redraw();
			}
			
			System::Event::waitEvent();
		}
		while ( event.m_type == eTouchMove || ( event.m_type != eTouchEnd && event.m_type != eTouchBegin ) );
		
		m_needsRedrawAutomatic = true;

		x = (int)event.x;
		y = (int)event.y;

		touchEnd(x, y);
		
		return true;
	}
	
	return false;
}

bool NotesView::touchEnd(int x, int y) {
	if ( m_ctrl ) {
		if ( m_ctrl->isAction() == false )  {
			m_ctrl->m_points.add(new Point(x, y));
			m_notes->add(m_ctrl);
			m_compute = true;
		}
		else {
			delete m_ctrl;
		}
	}
	
	m_ctrl = 0;
	
	return true;
}

NotesModel::NotesModel() {
	m_version = 3;
}

bool NotesModel::save(File& file) {
	if ( Model::save(file) ) {
		ControlRef notes = (ControlRef)((NotesView*)m_view)->m_notes;
		file << notes->getCount();
		
		Iterator iter = notes->getIterator();
		while ( iter.hasNext() ) {
			ShapeControlRef ctrl = (ShapeControlRef)iter.next();
			ctrl->save(file);
		}
	}
	
	return true;
}

bool NotesModel::load(File& file) {
	if ( Model::load(file) ) {
		ControlRef notes = (ControlRef)((NotesView*)m_view)->m_notes;
		
		int n;
		file >> n;
		
		while ( n > 0 && n-- ) {
			ShapeControlRef ctrl = new ShapeControl();
			notes->add(ctrl);
			ctrl->load(file);
		}
	}
	
	return true;
}

ShapeControl::ShapeControl() {
	m_marginIn.setMargin(4);
	m_marginEx.setMargin(4);
	
	rw = 1;
	rh = 1;
}

void ShapeControl::computeSize(GdiRef gdi) {
	int xmin = INT_MAX;
	int ymin = INT_MAX;
	
	int xmax = INT_MIN;
	int ymax = INT_MIN;
	
	Iterator iter = m_points.getIterator();
	while ( iter.hasNext() ) {
		PointRef point = (PointRef)iter.next();
		
		xmin = min(xmin, point->x);
		ymin = min(ymin, point->y);
		
		xmax = max(xmax, point->x);
		ymax = max(ymax, point->y);
	}

	Rect rect = gdi->m_rect;

	ymin = 0;
	ymax = rect.h;
	
	rh = 32./(rect.h);
	rw = rh;
	
	m_rect.x = xmin;
	m_rect.y = ymin;
	
	m_rect.w = (int)(( xmax - xmin ) * rw);
	m_rect.h = (int)(( ymax - ymin ) * rh);
	
	/*iter.begin();
	while ( iter.hasNext() ) {
		PointRef point = (PointRef)iter.next();
	
		point->x -= xmin;
		point->y -= ymin;
	
		point->x = (int)(((double)point->x)*rw);
		point->y = (int)(((double)point->y)*rh);
	}*/
}

void ShapeControl::draw(GdiRef gdi) {
	gdi->lines(&m_points, white, m_rect.x, m_rect.y, rw, rh, false);
}

bool ShapeControl::isAction() {
	if ( m_points.getCount() < 4 ) {
		return true;
	}
	return false;
}

bool ShapeControl::save(File& file) {
	file << m_layout;
	file << m_points.getCount();
		
	Iterator iter = m_points.getIterator();
	while ( iter.hasNext() ) {
		PointRef point = (PointRef)iter.next();
		file << point->x;
		file << point->y;
	}
	return true;
}

bool ShapeControl::load(File& file) {
	int n = 0;

	file >> m_layout;
	file >> n;
	
	while ( n-- ) {
		PointRef point = new Point();
		m_points.add(point);
		file >> point->x;
		file >> point->y;
	}
	return true;
}
