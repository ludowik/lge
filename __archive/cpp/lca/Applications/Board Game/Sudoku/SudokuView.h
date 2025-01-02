#pragma once

#include "SudokuModel.h"

ImplementClass(SudokuView) : public BoardView {
public:
	ControlRef m_numbers;

	bool m_showPossibilities;
	
public:
	SudokuView();
	virtual ~SudokuView();
	
public:
	virtual void createUI();
	virtual void createToolBar();
		
public:
	virtual void computeSize(GdiRef gdi);

};
