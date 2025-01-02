#include "System.h"
#include "View.h"
#include "Gdi.h"

GdiRef View::g_gdi = 0;

View::View() : Control() {
	m_class = "View";
	
	g_nDrawing = 0;

	g_frameRateReal = 0;
	g_frameRateCapacity = 0;

	m_shouldRotateToLandscape = true;
	m_shouldRotateToPortrait = true;

	m_model = 0;

	if ( g_gdi == 0 ) {
		g_gdi = createGdi();
		g_gdi->setFont(m_fontName, m_fontSize, m_fontAngle);
	}
	
	m_right2left = false;
	
	m_close = false;
	m_modal = false;
	
	m_opaque = true;

	m_compute = true;

	m_needsRedraw = true;
	m_needsRedrawAutomatic = true;
	
	m_bgImage = 0;
	
	m_lastId = 0;
	
	m_marginEx.setMargin(2);
	m_marginIn.setMargin(3);
	
	m_animation = 0;

	m_statusbar = NULL;
	m_area = new Control();
	m_toolbar = NULL;
    
    m_touchCtrl = NULL;
	
	m_bgColor = black;
}

View::~View() {
	if ( m_model ) {
		delete m_model;
	}
}

bool View::shouldAutorotateToInterfaceOrientation(int orientation) {
	switch ( orientation ) {
		case orientationLandscape:
			return m_shouldRotateToLandscape;
		case orientationPortrait:
			return m_shouldRotateToPortrait;
	}
	
	return true;
}

void View::createView() {
	m_statusbar = (StatusBarControlRef)add(new StatusBarControl());
	m_area = startPanel(0, m_area); {
		createUI();
	}
	endPanel();
	
	add(new IntegerControl(&g_frameRateReal), posNextLine);
	add(new IntegerControl(&g_frameRateCapacity), posNextLine);

	createToolBar();
}

void View::createUI() {
}

void View::createToolBar() {
}

void View::loadResource() {
}

void View::loaded() {
	g_nDrawing = 0;
}

void View::init() {
}

void View::releaseGdi() {
	g_gdi->release();
	m_resources.releaseAll();
	
	loadResource();
	
	m_compute = true;
	g_nDrawing = 0;
}

void View::computeSize(GdiRef gdi) {
	m_rect = System::Media::getWindowsSize();

	Layout().computeDisposition(gdi, this);

	m_compute = false;
}

void View::erase(GdiRef gdi) {
	if ( m_bgImage ) {
		gdi->copy(m_bgImage);
	}
	else {
		Control::erase(gdi);
	}
}

void View::draw(RectRef rect) {
	if ( g_nDrawing == 0 ) {
		g_timerRunning.timerInit();
	}
	g_timerDrawing.timerInit();

	g_gdi->initWithCurrentContext();
	
	if ( rect ) {
		g_gdi->m_redrawRect = *rect;
	}
	
	g_gdi->begin(); {
		g_gdi->erase(m_bgColor);

		if ( m_compute ) {
			computeSize(g_gdi);
		}

		draw(g_gdi);

		Control::draw(g_gdi);
	}
	g_gdi->end();

	m_needsRedraw = false;

	// calcul du FrameRate réel
	double frameDelayRunning = (double)g_timerRunning.timerDelay() / (double)g_nDrawing;
	g_frameRateReal = (int)( 1000. / (double)frameDelayRunning );

	// calcul du FrameRate possible
	double frameDelayDrawing = (double)g_timerDrawing.m_ellapsedTimeMilliseconds / (double)g_nDrawing;
	g_frameRateCapacity = (int)( 1000. / (double)frameDelayDrawing );

	g_timerDrawing.timerUpdate();	
	g_nDrawing++;	
}

void View::draw(GdiRef gdi) {
}

bool View::touchNotify(ControlRef ctrl) {
    bool ret = false;
    if ( ctrl ) {
        if ( ctrl->m_notifyFunction ) {
            if ( ctrl->m_notifyTo ) {
                ret = (ctrl->m_notifyTo->*ctrl->m_notifyFunction)(ctrl);
            } else {
                ret = (this->*ctrl->m_notifyFunction)(ctrl);
            }
        }
    }
    return false;
}

bool View::touchBegin(int x, int y) {
	bool ret = false;
	
	m_touchCtrl = get_control(x, y);
	if ( m_touchCtrl ) {
		m_lastId = m_touchCtrl->m_id;
		
        if ( m_touchCtrl->touchBegin(x, y) ) {
			ret = true;
		}
		
		if ( m_touchCtrl->m_notifyFunction ) {
            ret = touchNotify(m_touchCtrl);
		}
	}
	
	return ret;
}

bool View::touchMove(int x, int y) {
	if ( m_touchCtrl ) {
		if ( m_touchCtrl->touchMove(x, y) ) {
			return true;
		}
	}
	
	return false;
}

bool View::touchEnd(int x, int y) {
	if ( m_touchCtrl ) {
		if ( m_touchCtrl->touchEnd(x, y) ) {
			return true;
		}
	}
	
	return false;
}

bool View::touchDoubleTap(int x, int y) {
	ControlRef ctrl = get_control(x, y);
	if ( ctrl ) {
		if ( ctrl->touchDoubleTap(x, y) ) {
			return true;
		}
	}
	
	return false;
}

bool View::touchTripleTap(int x, int y) {
	ControlRef ctrl = get_control(x, y);
	if ( ctrl ) {
		if ( ctrl->touchTripleTap(x, y) ) {
			return true;
		}
	}
	
	return false;
}

bool View::acceleration(double x, double y, double z) {
	return false;
}

bool View::timer() {
	return false;
}

bool View::onClose(ObjectRef obj) {
	m_close = true;
	return true;
}

bool View::onFlip(ObjectRef obj) {
	m_right2left = !m_right2left;
	return true;
}

int View::run() {
	m_modal = true;
	
	push_view(this);
	
	while ( m_close == false ) {
		System::Event::waitEvent();
		if ( manageEvents(eAllEvent) ) {
			System::Media::redraw();
		}
	}
	
	pop_view();
	
	return m_lastId;
}

bool View::onModeGdi(ObjectRef obj) {
	delete g_gdi;
	
	g_gdi = createGdi();
	g_gdi->setFont(m_fontName, m_fontSize, m_fontAngle);
	
	return true;
}

bool View::animate() {
	if ( m_animation ) {
		bool ret = m_animation->iterAnimation();
		if ( ret ) {
			//addEvent(new Event(eAnimate));
			return true;
		}
		else {
			m_animation->finishAnimation();
			delete m_animation;
			m_animation = 0;
			return false;
		}
	}
	
	return false;
}

void releaseGdi() {
}
