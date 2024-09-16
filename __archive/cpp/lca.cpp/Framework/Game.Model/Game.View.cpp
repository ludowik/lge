#include "System.h"
#include "Game.View.h"

ViewGame::ViewGame() {
	m_timer = 0;
}

ViewGame::~ViewGame() {
}

void ViewGame::createView() {
	View::createView();

	if ( m_toolbar->getCount() ) {
		ControlRef ctrl = (ControlRef)m_toolbar->getFirst();
		ctrl->m_layout |= posNextLine;
	}

	ModelGameRef model = (ModelGameRef)m_model;
	
	m_toolbar->insert(new IntegerControl(model->m_score.m_nCards), 0, posWCenter);
	m_toolbar->insert(new IntegerControl(model->m_score.m_value), 0, posLeftAlign);
	
	m_timer = new TimerControl();
	m_toolbar->insert(m_timer, 0, posRightAlign);	
}

void ViewGame::loaded() {
	View::loaded();
	m_timer->m_timer.timerInit();
}

bool ViewGame::timer() {
	m_timer->m_timer.timerUpdate();
	return View::timer();
}
