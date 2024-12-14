#include "System.h"
#include "Score.h"

Score::Score() {
	m_win = false;
	m_value = 0;
	m_nCards = 52;
}

Score::Score(int win, int value) {
	m_win = win;
	m_value = value;
	m_nCards = 52;
}

Score::~Score() {
}

void Score::cardInSerie() {
	m_value += 100 * 52 / m_nCards;
}

void Score::cardOutOfSerie() {
	m_value += 20 * 52 / m_nCards;
}

void Score::gameWin() {
	m_value += 5200;
}

void Score::invalidMove() {
	m_value -= 20 * 52 / m_nCards;
}

void Score::stock() {
	m_value -= 20 * 52 / m_nCards;
}

void Score::undo() {
	m_value -= 40 * 52 / m_nCards;
}

void Score::second() {
	m_value -= 4 * 52 / m_nCards;
}
