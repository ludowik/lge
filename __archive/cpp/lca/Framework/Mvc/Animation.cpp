#include "System.h"
#include "Animation.h"
#include "View.h"

Animation::Animation(ViewRef view) {
	m_view = view;
	//addEvent(new Event(eAnimate));
}

Animation::~Animation() {
}

bool Animation::initAnimation() {
	if ( m_view ) {
		m_view->m_needsRedrawAutomatic = false;
	}
	return false;
}

bool Animation::iterAnimation() {
	return false;
}

bool Animation::finishAnimation() {
	if ( m_view ) {
		m_view->m_needsRedrawAutomatic = true;
	}
	return false;
}

bool Animation::resetAnimation() {
	if ( m_view ) {
		m_view->m_needsRedrawAutomatic = true;
	}
	return false;
}
