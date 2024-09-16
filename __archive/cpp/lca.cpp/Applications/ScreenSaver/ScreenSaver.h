#pragma once

ImplementClass(ScreenSaver) : public View {
public:
	static Timer g_timer;

	static long g_delay;

public:
	List m_refListAleaPoint;

public:
	ScreenSaver();

public:
	virtual void createUI();

public:
	virtual bool move();

public:
	virtual void draw(GdiRef gdi);

public:
	virtual bool touchBegin(int x, int y);

};
