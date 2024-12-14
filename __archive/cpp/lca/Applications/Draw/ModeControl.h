#pragma once

ImplementClass(ModeControl) : public Control {
public:
	int m_mode;
	
public:
	ModeControl(int iMode);
	
public:
	virtual void computeSize(GdiRef gdi);
	virtual void draw(GdiRef gdi);
	
	virtual bool touchBegin(int x, int y);
	
};

ImplementClass(ChooseModeControl) : public ModeControl {
public:
	ChooseModeControl(int iMode);
	
public:
	virtual bool touchBegin(int x, int y);
	
};
