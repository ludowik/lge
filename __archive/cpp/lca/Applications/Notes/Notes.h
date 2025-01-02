#include "System.h"
#include "View.h"

ImplementClass(ShapeControl) : public Control {
public:
	Array m_points;
	
	double rw;
	double rh;
	
public:
	ShapeControl();
	
public:
	virtual void computeSize(GdiRef gdi);
	virtual void draw(GdiRef gdi);
	
public:
	virtual bool isAction();
	
public:
	virtual bool load(File& file);
	virtual bool save(File& file);	
	
};

ImplementClass(NotesModel) : public Model {
public:
	NotesModel();
	
public:
	virtual bool load(File& file);
	virtual bool save(File& file);
		
};

ImplementClass(NotesView) : public View {
public:
	ControlRef m_notes;
	ShapeControlRef m_ctrl;
	
public:
	NotesView();
	
public:
	virtual void createUI();
	virtual void createToolBar();
	
public:
	virtual void draw(GdiRef gdi);

public:
	virtual bool touchBegin(int x, int y);
	virtual bool touchMove (int x, int y);
	virtual bool touchEnd  (int x, int y);
	
public:
	virtual bool onNew    (ObjectRef obj);
	virtual bool onUndo   (ObjectRef obj);
	virtual bool onNewLine(ObjectRef obj);

};
