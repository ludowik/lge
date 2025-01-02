#pragma once

ImplementClass(OthelloModel) : public GameBoardModel {
public:
  OthelloModel();

};

ImplementClass(OthelloView) : public BoardView {
public:
	OthelloView();
	
public:
	virtual void loadResource();
	virtual void createUI();

public:
	virtual void draw(GdiRef gdi, int _x, int _y, int wcell, int hcell, BoardModel* model);

};
