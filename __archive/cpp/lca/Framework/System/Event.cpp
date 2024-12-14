#include "System.h"
#include "Event.h"

List g_events;

bool m_eventTimer = false;
bool m_eventIdle  = false;

Event::Event() {
	m_type = eNullEvent;
	
	x = 0;
	y = 0;
	z = 0;
}

Event::Event(int type, double _x, double _y, double _z) {
	m_type = type;
	
	x = _x;
	y = _y;
	z = _z;
}

void addEvent(EventRef evt) {
	g_events.add(evt);
}

void addEventTimer() {
	m_eventTimer = true;
}

void addEventIdle() {
	m_eventIdle = true;
}

int hasEvent() {
	return g_events.getCount();
}

bool getEvent(Event& event, int type) {
	EventRef evt = getEvent(type);
	if ( evt ) {
		event = *evt;
		delete evt;
		return true;
	}
	
	event.m_type = eNullEvent;
	return false;
}

EventRef getEvent(int type) {
	if ( g_events.getCount() > 0 ) {
		if ( type ) {
			fromto(int, i, 0, g_events.getCount()) {
				EventRef event = (EventRef)g_events.get(i);
				if ( event->m_type & type ) {
						return (EventRef)g_events.remove(i);
				}
			}
			return 0;
		}
		
		return (EventRef)g_events.remove(0);
	}
	return 0;
}

bool manageEvents() {
	static bool inManageEvents = false;

	bool ret = false;
	if ( !inManageEvents ) {
		inManageEvents = true;
		ret = manageEvents(eAllEvent);
		inManageEvents = false;
	}

	return ret;
}

bool manageEvents(int type) {
	bool ret = false;
	
	ViewRef view = get_view();
	if ( !view ) {
		return false;
	}

	EventRef evt = (EventRef)getEvent(type);
	if ( evt ) {
		ret |= dispatchEvent(evt);
		delete evt;
	}
	
	if ( m_eventTimer ) {
		ret |= view->timer();
		m_eventTimer = false;
	}
	
	if ( m_eventIdle ) {
		if ( view->m_model ) {
			ret |= view->m_model->idle();
		}
		m_eventIdle = false;
	}

	while ( view &&
		    view->m_close &&
			view->m_modal == false &&
			view != get_launcher() ) {
		pop_view();
		delete view;

		view = get_view();
	}
	
	return ret;
}

bool dispatchEvent(EventRef evt) {
	ViewRef view = get_view();
	
	bool needRedraw = false;
	
	int x = (int)evt->x;
	int y = (int)evt->y;
	
	switch ( evt->m_type ) {
		case eTouchBegin: {
			needRedraw = view->touchBegin(x, y);
			break;
		}
		case eTouchMove: {
			needRedraw = view->touchMove(x, y);
			break;
		}
		case eTouchEnd: {
			needRedraw = view->touchEnd(x, y);
			break;
		}
		case eTouchDoubleTap: {
			needRedraw = view->touchDoubleTap(x, y);
			break;
		}
		case eTouchTripleTap: {
			needRedraw = view->touchTripleTap(x, y);
			break;
		}
		case eAcceleration: {
			needRedraw = view->acceleration(evt->x, evt->y, evt->z);
			break;
		}
		case eAnimate: {
			needRedraw = view->animate();
			break;
		}
		case eTimer: {
			needRedraw = view->timer();
			break;
		}
		case eIdle: {
			if ( view->m_model ) {
				needRedraw = view->m_model->idle();
			}
			break;
		}
		case eClose: {
			view->m_close = true;
			break;
		}
	}
		
	return needRedraw;
}
