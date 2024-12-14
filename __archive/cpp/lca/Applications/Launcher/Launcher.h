#pragma once

ImplementClass(LauncherView) : public View {
public:
	int m_level;
	
public:
	LauncherView();
	virtual ~LauncherView();
	
public:
	void addApplication(TabsPanelRef page, const char* idTitle, const char* idClass, const char* idRes=0);
	
public:
	virtual void createUI();
	
public:
	virtual bool touchBegin(int x, int y);

	virtual bool onLevel(ObjectRef obj);
	
};

ImplementClass(LauncherModel) : public Model {
public:
	String m_cl;

public:
	LauncherModel();
	virtual ~LauncherModel();
	
public:
	virtual bool save(File& file);
	virtual bool load(File& file);
		
};
