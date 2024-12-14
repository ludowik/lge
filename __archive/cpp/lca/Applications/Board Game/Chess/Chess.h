#pragma once

ImplementClass(ChessModel) : public GameBoardModel {
public:
	ChessModel();
	
};

ImplementClass(ChessView) : public BoardView {
public:
	ChessView();

public:
	virtual void loadResource();

};
