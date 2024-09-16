#pragma once

ImplementClass(ListControl) : public Control {
public:
	List m_values;
	int m_selectedItem;
	
public:
	ListControl();
	virtual ~ListControl();

public:
	virtual void computeSize(GdiRef gdi);  
	virtual void draw(GdiRef gdi);
		
public:
	virtual bool touchBegin(int x, int y);
	virtual bool touchMove (int x, int y);
	virtual bool touchEnd  (int x, int y);

};
