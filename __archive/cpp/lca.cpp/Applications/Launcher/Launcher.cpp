#include "System.h"
#include "Launcher.h"

ApplicationObject<LauncherView, LauncherModel> appLauncher("Launcher", "Launcher");

LauncherView::LauncherView() : View() {
	m_level = 0;
}

LauncherView::~LauncherView() {
}

void LauncherView::addApplication(TabsPanelRef page, const char* idTitle, const char* idClass, const char* idRes) {
	int size = 60;
	if ( System::Media::getMachineType() == iPad ) {
		size = 120;
	}

	BitmapButtonControl* ctrl = new BitmapButtonControl(idRes, 0, size, size);
	
    ctrl->m_fontSize = fontSemiSmall;
    
	ctrl->m_text = idTitle;
	ctrl->m_ref = idClass;

	if ( ctrl->m_text.getLen() > 8 ) {
        String text = ctrl->m_text.left(3);
        text += "...";
        text += ctrl->m_text.right(3);
        
        ctrl->m_text = text;
    }
    
   page->Control::add(ctrl);
}

ImplementClass(TabsPage) : public TabsPanel {
public:
	TabsPage(char* pageName) : TabsPanel(pageName) {
		double coefInterface = System::Media::getCoefInterface();

		m_marginEx.setwMargin(13);
		m_marginEx.sethMargin((int)( 10 * coefInterface ));

		m_marginIn.setwMargin((int)( 13 * coefInterface ));
		m_marginIn.sethMargin((int)( 10 * coefInterface ));
	}
};

void LauncherView::createUI() {
	TabsControlRef tabs = (TabsControlRef)startPanel(0, new TabsControl()); {
		int nbpage = 0;
		
		Iterator iter = enum_views();
		while ( iter.hasNext() ) {
			ApplicationRef appli = (ApplicationRef)iter.next();
			nbpage = max(nbpage, appli->m_page);
		}
		
		int i = 0;
		fromto(, i, 0, nbpage+1) {
            String pageName("unknown");
            
            switch ( i ) {
                case 0:
                    pageName = "test";
                    break;
                    
                case pageCardGame:
                    pageName = "Cards Games";
                    break;
                    
                case pageBoardGame:
                    pageName = "Board Games";
                    break;
                    
            }

			startPanel(0, new TabsPage(pageName));
			endPanel();
		}
		
		iter.begin();
		while ( iter.hasNext() ) {
			ApplicationRef appli = (ApplicationRef)iter.next();
			if ( appli && appli->m_class != m_class ) {
				TabsPageRef page = (TabsPageRef)tabs->get(appli->m_page);
				if ( page ) {
					addApplication(page, appli->m_idTitle, appli->m_class, appli->m_idRes);
				}
			}
		}
	}
	endPanel();
}

bool LauncherView::touchBegin(int x, int y) {
	ControlRef obj = (ControlRef)get_control(x, y);
	if ( obj ) {
		View* view = create_view(obj->m_ref.getBuf());
		if ( view ) {
			System::Event::startWaitAnimation();
			push_view(view);
			return true;
		}
	}
	
	if ( m_level == 1 ) {
		onLevel(0);
	}
	
	return View::touchBegin(x, y);
}

bool LauncherView::onLevel(ObjectRef obj) {
	m_level = m_level==0?1:0;
	
	releaseAll();
	createView();
	
	return true;
}
