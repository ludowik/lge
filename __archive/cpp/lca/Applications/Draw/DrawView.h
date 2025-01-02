#pragma once

#define DISTANCE_MAX 10

struct DrawInfo {
	Color rgb;
	
	int size;
	int pen;
	
	int adjust;
	
	int mode;

	double** percents;
};

ImplementClass(DrawControl) : public Control {
public:
	GdiWindows m_gdi;
	
public:
	DrawControl();
	virtual ~DrawControl();
	
public:
	virtual void draw(GdiRef gdi);
	
public:
	virtual bool touchBegin(int x, int y);
	virtual bool touchMove (int x, int y);

	bool touch(int x, int y, bool move);
	
public:
	void init(int firstX, int firstY);

	bool onGomme (int firstX, int firstY, bool move);
	bool onPoint (int firstX, int firstY, bool move);
	bool onLine  (int firstX, int firstY, bool move);
	bool onRect  (int firstX, int firstY, bool move);
	bool onCircle(int firstX, int firstY, bool move);
	bool onFill  (int firstX, int firstY, bool move);
	
public:
	virtual bool save(File& file);
	virtual bool load(File& file);
	
};

enum {
	modeGomme,
	modePoint,
	modeLine,
	modeRect,
	modeCircle,
	modeFill
};

ImplementClass(DrawView) : public View {
public:
	static DrawInfo m_drawInfo;
	
public:
	DrawControlRef m_drawControl;
	
public:
	DrawView();
	virtual ~DrawView();
	
public:
	virtual void createUI();
	virtual void createToolBar();
	
	virtual bool onNew   (ObjectRef obj);
	virtual bool onTest  (ObjectRef obj);
	
	virtual bool onPixelisation   (ObjectRef obj);
	virtual bool onFilter         (ObjectRef obj);
	virtual bool onChangeColor    (ObjectRef obj);
	virtual bool onGrayScale      (ObjectRef obj);
	virtual bool onLuminosity     (ObjectRef obj);
	virtual bool onBinarisation   (ObjectRef obj);
	virtual bool onSquelettisation(ObjectRef obj);
	virtual bool onDilatation     (ObjectRef obj);
	
	virtual bool save(File& file);
	virtual bool load(File& file);

public:
	void drawPattern(GdiRef gdi, int newX, int newY, DrawInfo* pDrawInfo);

};
