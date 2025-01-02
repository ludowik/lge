#pragma once

ImplementClass(Score) : public Object {
public:
	int m_win;
	int m_value;
	
	int m_nCards;
	
public:
	Score();
	Score(int win, int value);
	virtual ~Score();
	
public:
	void cardInSerie();
	void cardOutOfSerie();
	
	void gameWin();
	
	void invalidMove();
	
	void stock();
	void undo();
	
	void second();
	
};
