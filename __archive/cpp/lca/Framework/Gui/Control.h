#pragma once

#include "Collection.h"

#define posRight        ((LayoutType)0x00000001)
#define posLeft         ((LayoutType)0x00000002)
#define posAbove        ((LayoutType)0x00000004)
#define posBelow        ((LayoutType)0x00000008)
#define posOver         ((LayoutType)0x00000010)

#define posLeftAlign    ((LayoutType)0x00000020)
#define posRightAlign   ((LayoutType)0x00000040)
#define posBottomAlign  ((LayoutType)0x00000080)
#define posTopAlign     ((LayoutType)0x00000100)

#define posWCenter      ((LayoutType)0x00000200) // peut être mixer avec posLeftAlign ou posRightAlign
#define posHCenter      ((LayoutType)0x00000400) // peut être mixer avec posTopAlign ou posBottomAlign

#define posNextLine     ((LayoutType)0x00000800)
#define posNextCol      ((LayoutType)0x00001000)

#define posRightExtend  ((LayoutType)0x00002000)
#define posBottomExtend ((LayoutType)0x00004000)

#define posDefaultSize  ((LayoutType)0x00008000)

typedef bool (Object::*FunctionRef)(ObjectRef obj);

ImplementClass(Margin) : public Object {
public:
	int left;
	int right;
	int top;
	int bottom;
	
public:
	inline void setMargin(int val) {
		left = right = top = bottom = val;
	}
	
	inline void setwMargin(int val) {
		left = right = val;
	}
	
	inline void sethMargin(int val) {
		top = bottom = val;
	}
	
	inline int w() {
		return left + right;
	}
	
	inline int h() {
		return top + bottom;
	}
	
};

ImplementClass(Control) : public Collection, public Font {
public:
	Color m_selectColor;
	Color m_fgColor;
	Color m_bgColor;
	Color m_textColor;
	
	LayoutType m_layout;
	LayoutType m_layoutText;
	
	bool m_readOnly;

	bool m_visible;
	bool m_opaque;

	bool m_border;
	
	bool m_selected;
	bool m_checked;
	
	Rect m_rect;
	
	int m_xOrigin;
	int m_yOrigin;

	int m_wText;
	int m_hText;
	
	Margin m_marginIn;
	Margin m_marginEx;
	
	double m_wpercent;
	double m_hpercent;
	
	Stack m_containers;
	
	ControlRef m_parent;
	ControlRef m_view;

public:
	ObjectRef m_notifyTo;
	FunctionRef m_notifyFunction;
	
public:
	String m_text;
	String m_ref;
	
public:
	Control(int id=-1);
	virtual ~Control();
	
public:
	virtual void computeSize(GdiRef gdi);
	virtual void computeSize(GdiRef gdi, const char* text);

	virtual void computeSizeText(GdiRef gdi, const char* text);
	
	virtual void set_xy(int x, int y);
	virtual void set_wh(int w, int h);
	
	virtual void draw(GdiRef gdi);
	virtual void draw(GdiRef gdi, ControlRef ctrl);
	
	virtual void erase(GdiRef gdi);

public:
	int xLayoutText();
	int yLayoutText();
	
	int xLayout(LayoutType layout, int w);
	int yLayout(LayoutType layout, int h);

public:
	void unselect();
	
	virtual bool onDrag(int x, int y, bool init);
	virtual bool onDrop(int x, int y);
    
    virtual bool touchNotify();

	virtual bool touchBegin(int x, int y);
	virtual bool touchMove (int x, int y);
	virtual bool touchEnd  (int x, int y);

	virtual bool touchDoubleTap(int x, int y);
	virtual bool touchTripleTap(int x, int y);
	
public:
	ControlRef add(ControlRef ctrl, LayoutType layout=0);
	ControlRef insert(ControlRef ctrl, int pos, LayoutType layout=0);
	
	ControlRef startPanel(LayoutType layout=0, ControlRef ctrl=0, int wpercent=-1, int hpercent=-1);
	ControlRef currentPanel();
	ControlRef endPanel();
	
	void setListener(ObjectRef notifyTo, FunctionRef notifyFunction);

public:
	virtual ControlRef get_control(int x, int y);

};