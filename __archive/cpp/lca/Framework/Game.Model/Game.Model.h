#pragma once

#include "Model.h"
#include "Score.h"

enum {
	eGameOver=0,
	eGameWin=1,
	eGameAbandon=2
};

ImplementClass(ModelGame) : public Model {
public:
	// Les statistiques
	List m_scores;

	// Le score courant
	Score m_score;
		
private:
	Actions m_actions;
	ActionsRef m_subActions;
		
public:
	ModelGame();
	virtual ~ModelGame();
	
public:
	virtual void pushAction(ActionRef action);

	void startSubActions();
	void endSubActions();

	ActionRef getLastAction();
	
public:
	virtual void init();

	virtual int automatic(bool user);
	
public:
	virtual bool isGameWin();
	virtual bool isGameOver();
	
	virtual void gameOver();
	virtual void gameWin();

public:
	virtual bool onNew       (ObjectRef obj);
	virtual bool onClose     (ObjectRef obj);	
	virtual bool onStat      (ObjectRef obj);
	virtual bool onInit      (ObjectRef obj);
	virtual bool onHelp      (ObjectRef obj);
	virtual bool onUndoAction(ObjectRef obj);
	virtual bool onAutomate  (ObjectRef obj);
	
public:
	virtual bool save(class File& file);
	virtual bool load(class File& file);

};
