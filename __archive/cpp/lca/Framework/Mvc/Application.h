#pragma once

#include "View.h"

ViewRef create_view(char* model, bool load=true);

ViewRef push_view(ViewRef view, bool load=true);
ViewRef pop_view(bool save=true, bool last=false);

ViewRef get_launcher();
#define get_view() g_currentView

extern ViewRef g_currentView;

IteratorRef enum_views();

void free_views(bool save=true, bool releaseApplications=true);

#define pageCardGame  1
#define pageBoardGame 2

ImplementClass(Applications) : public Singleton<Applications> , public List {	
public:
	Applications();
	virtual ~Applications();
	
};

ImplementClass(Application) : public Object {
public:
	const char* m_idTitle;
	const char* m_idRes;
	
	int m_page;
	int m_order;

public:
	Application();
	virtual ~Application();
	
public:
	virtual ViewRef create();

};

template<class V, class M> class ApplicationObject : public Application {
public:
	ApplicationObject(const char* cl, const char* idTitle, const char* idRes=0, int order=0, int page=0) : Application() {
		Applications::getInstance().add(this);
		
		m_class = cl;
		
		m_idTitle = idTitle;
		m_idRes = idRes;

		m_page = page;
		m_order = order;
	}
	
	virtual ~ApplicationObject() {
	}
	
public:
	virtual ViewRef create() {
		ViewRef view = new V();
		
		ModelRef model = new M();
		
		view->m_model = model;
		view->m_class = m_class;
		
		model->m_view = view;
		model->m_class = m_class;
		
		return view;
	}

};
