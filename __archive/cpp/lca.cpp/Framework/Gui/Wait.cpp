#include "System.h"
#include "Wait.h"

#include "GaugeControl.h"

ImplementClass(Wait) : public View {
public:
	GaugeControlRef m_gauge;
	
public:
	Wait(int max);
	virtual ~Wait();
	
};

Wait::Wait(int max) : View() {
	m_class = "Wait";

	m_gauge = new GaugeControl(0, max);

	add(m_gauge, posWCenter|posHCenter);
}

Wait::~Wait() {
}

Wait* g_wait = 0;

void waitStart(int max, bool active) {
	if ( active ) {
		if ( !g_wait ) {
			g_wait = new Wait(max);
		}
	}
}

void waitEnd(bool active) {
	if ( active )  {
		if ( g_wait ) {
			delete g_wait;
			g_wait = 0;
		}
	}
}

void waitSetVal(int val, bool active) {
	if ( active ) {
		if ( g_wait ) {
			g_wait->m_gauge->m_val = val;
		}
	}
}
