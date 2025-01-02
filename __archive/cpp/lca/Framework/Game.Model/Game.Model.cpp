#include "System.h"
#include "Game.Model.h"
#include "Score.h"

ModelGame::ModelGame() {
	m_score.m_value = 0;
	m_subActions = 0;
}

ModelGame::~ModelGame() {
}

void ModelGame::pushAction(ActionRef action) {
	if ( m_subActions ) {
		if ( m_subActions == action )
			m_actions.add(action);
		else
			m_subActions->push(action);
	}
	else {
		m_actions.push(action);
	}
}

bool ModelGame::onUndoAction(ObjectRef obj) {
	if ( m_actions.getCount() > 0 ) {
		m_actions.pop();
		m_score.undo();
		return true;
	}
	return false;
}

void ModelGame::startSubActions() {
	m_subActions = new Actions();
}

void ModelGame::endSubActions() {
	pushAction(m_subActions);
	m_subActions = 0;
}

ActionRef ModelGame::getLastAction() {
	return (ActionRef)m_actions.getLast();
}

void ModelGame::init() {
	m_actions.releaseAll();
	m_score.m_value = 0;
}

int ModelGame::automatic(bool user) {
	return 0;
}

bool ModelGame::isGameWin() {
	return false;
}

bool ModelGame::isGameOver() {
	return false;
}

void ModelGame::gameOver() {
	Message(m_view, "Game Over", "Start a new game?", this, "Yes", (FunctionRef)&ModelGame::onInit);
}

void ModelGame::gameWin() {
	Message(m_view, "Game Win", "Start a new game?", this, "Yes", (FunctionRef)&ModelGame::onInit);
}

bool ModelGame::onNew(ObjectRef obj) {
	Message(m_view, "New?", "Start a new game?", this, "Yes", (FunctionRef)&ModelGame::onInit);
	return true;
}

bool ModelGame::onClose(ObjectRef obj) {
	Message(m_view, "Close?", "Suspend and Close game?", m_view, "Yes", (FunctionRef)&View::onClose);
	return true;
}

bool ModelGame::onInit(ObjectRef obj) {
	if ( isGameWin() ) {
		m_score.gameWin();
		m_scores.add(new Score(eGameWin, m_score.m_value));
	}
	else if ( isGameOver() ) {
		m_scores.add(new Score(eGameOver, m_score.m_value));
	}
	else {
		m_scores.add(new Score(eGameAbandon, m_score.m_value));
	}
	
	init();

	return true;
}

bool ModelGame::onHelp(ObjectRef obj) {
	msgAlert("Help");
	return true;
}

bool ModelGame::onAutomate(ObjectRef obj) {
	automatic(true);
	return true;
}

bool ModelGame::onStat(ObjectRef obj) {
	int nbGameWin = 0;
	int nbGameOver = 0;
	int nbGameAbandon = 0;
	
	Iterator iter = m_scores.getIterator();
	while ( iter.hasNext() ) {
		ScoreRef score = (ScoreRef)iter.next();
		switch ( score->m_win ) {
			case eGameWin: {
				nbGameWin++;
				break;
			}
			case eGameOver: {
				nbGameOver++;
				break;
			}
			case eGameAbandon: {
				nbGameAbandon++;
				break;
			}
		}
	}
	
	View view;
	
	view.startPanel(posHCenter); {
		view.add(new StaticControl("Statistiques"), posWCenter);
		
		view.add(new StaticControl("Jeux gagnes :"), posNextLine|posWCenter|posLeftAlign);
		view.add(new IntegerControl(nbGameWin), posWCenter|posRightAlign);
		
		view.add(new StaticControl("Jeux perdus :"), posNextLine|posWCenter|posLeftAlign);
		view.add(new IntegerControl(nbGameOver), posWCenter|posRightAlign);
		
		view.add(new StaticControl("Jeux abandonnes :"), posNextLine|posWCenter|posLeftAlign);
		view.add(new IntegerControl(nbGameAbandon), posWCenter|posRightAlign);
		
		view.add(new ButtonControl("OK"), posNextLine|posWCenter)->setListener(&view, (FunctionRef)&View::onClose);
	}
	view.endPanel();
	
	view.run();

	return true;
}

bool ModelGame::save(File& file) {
	if ( Model::save(file) ) {
		file << m_scores.getCount();
		foreach ( ScoreRef, score, m_scores ) {
			file << score->m_win;
			file << score->m_value;
		}
		return true;
	}
	return false;
}

bool ModelGame::load(File& file) {
	if ( Model::load(file) ) {
		int win;
		int score;
		
		int n;
		file >> n;
		
		m_scores.releaseAll();
		for ( int i = 0 ; i < n ; ++i ) {
			file >> win;
			file >> score;
			m_scores.add(new Score(win, score)); 
		}
		return true;
	}
	return false;
}
