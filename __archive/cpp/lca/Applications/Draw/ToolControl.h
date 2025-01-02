#pragma once

ImplementClass(ToolControl) : public Control {
public:
	bool bSize;
	bool bPen;
	bool bAdjust;
	
	DrawInfo drawInfo;
	
public:
	ToolControl(int size, int pen, int adjust);
	
public:
	virtual void computeSize(GdiRef gdi);
	virtual void draw(GdiRef gdi);
	
public:
	virtual bool touchBegin(int x, int y);
	
};

ImplementClass(ChooseToolControl) : public ToolControl {
public:
	ChooseToolControl(int size, int type, int adjust);
	
public:
	virtual bool touchBegin(int x, int y);
	
};
