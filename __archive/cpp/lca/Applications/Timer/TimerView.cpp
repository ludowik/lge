#include "System.h"
#include "TimerView.h"

ApplicationObject<TimerView, Model> appTimer("Timer", "Timer", "timer.png");

TimerView::TimerView() {
	m_maxTimer = 20;
	
	m_timerInc = new TimerControl();
	m_timerDec = new TimerControl();
	
	m_gaugeDec = new GaugeControl();
	
	m_listDelay = new ListControl();
	
	m_time = new TimeControl();
	m_date = new DateControl();
	m_date->m_showLongDate = true;

	m_timerInc->m_timer.set(0, 0, 0);
	
	m_timerDec->m_timer.set(0, 0, 0);
	m_timerDec->m_timer.add(m_maxTimer);
	
	m_gaugeDec->m_val =
	m_gaugeDec->m_max = m_timerDec->m_timer.get();
	
	m_listDelay->m_values.add(new String("1mn"));
	m_listDelay->m_values.add(new String("2mn"));
	m_listDelay->m_values.add(new String("5mn"));
	m_listDelay->m_values.add(new String("10mn"));
	
	m_timerInc->m_timer.m_modeChrono = true;
	m_timerDec->m_timer.m_modeChrono = false;
	
	m_timerOnInc = false;
	m_timerOnDec = false;
}

TimerView::~TimerView() {
}

void TimerView::createUI() {
	m_time->m_fontSize = fontLarge;
	m_date->m_fontSize = fontLarge;
	
	m_timerInc->m_fontSize = fontVeryLarge;
	m_timerDec->m_fontSize = fontVeryLarge;
	
	startPanel(posNextLine); {
		add(m_date, posWCenter);
		add(m_time, posWCenter|posNextLine);
	}
	endPanel();

	startPanel(0, new TabsControl()); {
		startPanel(0, new TabsPanel("Chronometre")); {
			add(m_timerInc, posNextLine|posWCenter);
			startPanel(posNextLine|posWCenter); {
				add(new ButtonControl("Play/Stop", 1))->setListener(this, (FunctionRef)&TimerView::onPlayStop);
				add(new ButtonControl("Reset", 1))->setListener(this, (FunctionRef)&TimerView::onReset);
			}
			endPanel();
		}
		endPanel();
		
		startPanel(0, new TabsPanel("Minuteur")); {
			add(m_timerDec, posNextLine|posWCenter);
			add(m_gaugeDec, posNextLine|posRightExtend);
			startPanel(posNextLine|posWCenter); {
				add(new ButtonControl("Play/Stop", 2))->setListener(this, (FunctionRef)&TimerView::onPlayStop);
				add(new ButtonControl("Reset", 2))->setListener(this, (FunctionRef)&TimerView::onReset);
			}
			add(m_listDelay, posNextLine)->setListener(this, (FunctionRef)&TimerView::onSetDelay);
			endPanel();
		}
		endPanel();
	}
	endPanel();
}

void TimerView::loadResource() {
	m_ring.load("ringin");
}

bool TimerView::timer() {
	if ( m_timerOnInc ) {
		m_timerInc->m_timer.timerUpdate();
	}	
	
	if ( m_timerOnDec ) {
		double oldPercent = m_gaugeDec->percent();
		
		m_timerDec->m_timer.timerUpdate();
		m_gaugeDec->m_val = m_timerDec->m_timer.get();
		
		double newPercent = m_gaugeDec->percent();
		
		if ( m_timerDec->m_timer.get() == 0 ) {
			m_ring.play(3);
			
			m_timerOnDec = false;
		}
		
		double firstRing = .5;
		if ( oldPercent > firstRing && newPercent <= firstRing ) {
			m_ring.play(1);
		}
		double secondRing = .2;
		if ( oldPercent > secondRing && newPercent <= secondRing ) {
			m_ring.play(2);
		}
	}
	
	m_time->m_time.update();
	m_date->m_date.update();
	
	return true;
}

bool TimerView::onPlayStop(ObjectRef obj) {
	if ( obj->m_id == 1 ) {
		m_timerOnInc = !m_timerOnInc;
		if ( m_timerOnInc ) {
			m_timerInc->m_timer.timerInit();
		}
	}
	else {
		m_timerOnDec = !m_timerOnDec;
		if ( m_timerOnDec ) {
			m_timerDec->m_timer.timerInit();
		}
	}
	return true;
}

bool TimerView::onReset(ObjectRef obj) {
	if ( obj && obj->m_id == 1 ) {
		m_timerInc->m_timer.set(0, 0, 0);
	}
	else {
		m_timerDec->m_timer.set(0, 0, 0);
		m_timerDec->m_timer.add(m_maxTimer);
		m_gaugeDec->m_val =
		m_gaugeDec->m_max = m_timerDec->m_timer.get();
	}
	
	return true;
}

bool TimerView::onSetDelay(ObjectRef obj) {
	switch ( m_listDelay->m_selectedItem ) {
		case 1:
			m_maxTimer = 60;
			break;
		case 2:
			m_maxTimer = 2*60;
			break;
		case 3:
			m_maxTimer = 5*60;
			break;
		case 4:
			m_maxTimer = 10*60;
			break;
		default:
			return false;
	}

	onReset(0);
	
	return true;
}
