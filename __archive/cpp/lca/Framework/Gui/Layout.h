#pragma once

ImplementClass(Layout) : public Object {
public:
	Layout();
	virtual ~Layout();
	
public:
	void computeDisposition(GdiRef gdi, ControlRef view);
	
private:
	void computeLayoutView(GdiRef gdi, ControlRef view);
	
	void computeSize(GdiRef gdi, ControlRef ctrl, ControlRef parent);

	void computePosition1(ControlRef ctrl, ControlRef previous, ControlRef parent);
	void computePosition2(ControlRef ctrl, ControlRef parent);

	void adjustPosition(ControlRef ctrl, int x, int y);

};
