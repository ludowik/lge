#pragma once

#include "Game.View.h"

DeclareClass(BoardModel);

ImplementClass(BoardView) : public ViewGame {
public:
	int m_wcell;
	int m_hcell;
	
	bool m_annoted;
	bool m_allowMove;
	
	int m_marge;
	
public:
	BoardView();
	
public:
	ObjectRef get_object(int x, int y);
	
public:
	virtual void createUI();
	virtual void createToolBar();

public:
	virtual void addResource(const char* id);

public:
	virtual void calc(GdiRef gdi, int nw, int nh=-1);

	virtual void draw(GdiRef gdi);
	virtual void drawCells(GdiRef gdi, int x, int y, int wcell, int hcell, BoardModelRef model);
	
	virtual bool touchBegin(int x, int y);
	virtual bool touchMove (int x, int y);
	
	virtual bool onTouch(ObjectRef obj);
	
};
