#include "System.h"
#include "Application.h"
#include "Gdi.OpenGL.h"

Applications::Applications() : Singleton<Applications>(false) {
	m_delete = false;
}

Applications::~Applications() {
}

Application::Application() {
}

Application::~Application() {
}
	
ViewRef Application::create() {
	return 0;
}
	
Stack m_views;

ViewRef create_view(char* _cl, bool load) {
	String cl(_cl);
	Iterator iter = Applications::getInstance().getIterator();
	while ( iter.hasNext() ) {
		Application* appli = (Application*)iter.next();
		if ( appli && appli->m_class == cl ) {
			ViewRef view = appli->create();
			view->m_text = _cl;
			return view;
		}
	}
	
	return 0;
}

ViewRef g_currentView = 0;

ViewRef push_view(ViewRef view, bool load) {
	if ( view ) {
		m_views.push(view);
		g_currentView = view;
		
		view->init(); {
			view->createView();
			view->loadResource();
						
			if ( view->m_model ) {
				view->m_model->init();
				if ( load ) {
					view->m_model->load();
				}
			}
			
			view->loaded();
            
            view->m_needsRedraw = true;
		} 
		
		System::Event::stopWaitAnimation();
	}
	
	return view;
}

ViewRef pop_view(bool save, bool last) {
	ViewRef lastView = 0;
	if ( last == true || m_views.getCount() > 1 ) {
		lastView = (ViewRef)m_views.pop();
		
		if ( lastView ) {
			if ( lastView->m_model ) {
				if ( save ) {
					lastView->m_model->save();
				}
				lastView->m_model->release();
			}
		}
	}

	g_currentView = (ViewRef)m_views.getLast();
	
	if ( g_currentView ) {
		g_currentView->releaseGdi();
	}
	
	return lastView;
}

ViewRef get_launcher() {
	return (ViewRef)m_views.getFirst();
}

IteratorRef enum_views() {
	return Applications::getInstance().getIterator();
}

void free_views(bool save, bool releaseApplications) {
	while ( 1 ) {
		ViewRef view = (ViewRef)pop_view(save, true);
		if ( view ) {
			delete view;
		}
		else {
			break;
		}
	}

	// Libération des ressources
	g_resources.releaseAll();

	if ( releaseApplications ) {
		// Les tests de non régression
		Test::releaseInstance();

		// La gestion des logs
		Log::releaseInstance();

		// La liste des applications
		Applications::releaseInstance();		

		// Fermer tous les fichiers de manière sûre
		System::File::fileCloseAll();

		// Le GDI global
		if ( View::g_gdi ) {
			GdiOpenGL::releaseOpenGL();
			delete View::g_gdi;
		}

		// Les textures de fonte
		freeCharTextures();
	}
}
