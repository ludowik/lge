#include "System.h"

class LampeDePoche : public View {
public:
	int m_mode;
	
	int m_from;
	int m_to;
	
	int m_v;
	
	int m_r;
	int m_g;
	int m_b;
	
public:
	virtual void createUI();
	
public:
	virtual void draw(GdiRef gdi);
	
public:
	virtual bool touchBegin(int x, int y);
	virtual bool touchMove(int x, int y);
	virtual bool touchDoubleTap(int x, int y);
	
};
