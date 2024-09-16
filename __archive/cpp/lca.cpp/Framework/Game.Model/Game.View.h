#pragma once

#include "View.h"

ImplementClass(ViewGame) : public View {
public:
	TimerControlRef m_timer;

public:
	ViewGame();
	virtual ~ViewGame();

public:
	virtual void createView();
	virtual void loaded();

public:
	virtual bool timer();

};
