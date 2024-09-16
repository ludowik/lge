#pragma once

ImplementClass(Brush) {
private:
	GdiWindowsRef m_gdi;
	
private:
	bool m_transparent;

private:
	void* m_brush;
	void* m_oldBrush;
	
public:
	Brush(GdiWindowsRef gdi, Color color);
	virtual ~Brush();

};
