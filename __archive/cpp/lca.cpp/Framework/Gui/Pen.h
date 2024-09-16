#pragma once

ImplementClass(Pen) {
private:
	GdiWindowsRef m_gdi;
	
private:
	bool m_transparent;

private:
	void* m_pen;
	void* m_oldPen;
	
public:
	Pen(GdiWindowsRef gdi, Color color, int size);
	virtual ~Pen();

};
