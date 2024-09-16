#include "System.h"
#include "TimeControl.h"

TimeControlImpl::TimeControlImpl(bool showSeconds) : StaticControl(&m_text) {
	m_layoutText = posWCenter|posHCenter;
	m_showSeconds = showSeconds;
}

TimeControlImpl::~TimeControlImpl() {
}

TimeControl::TimeControl(bool showSeconds) : TimeControlImpl(showSeconds) {
	m_class = "TimeControl";
	m_text = m_time.asString(m_showSeconds);
}

TimeControl::~TimeControl() {
}

void TimeControl::computeSize(GdiRef gdi) {
	m_text = m_time.asString(m_showSeconds);
	StaticControl::computeSize(gdi);
}

void TimeControl::draw(GdiRef gdi) {
	m_time.update();
	m_text = m_time.asString(m_showSeconds);
	StaticControl::draw(gdi);
}

TimerControl::TimerControl(bool showSeconds) : TimeControlImpl(showSeconds) {
	m_class = "TimerControl";
	m_text = m_timer.asString(m_showSeconds);
}

TimerControl::~TimerControl() {
}

void TimerControl::computeSize(GdiRef gdi) {
	m_text = m_timer.asString(m_showSeconds);
	StaticControl::computeSize(gdi);
}

void TimerControl::draw(GdiRef gdi) {
	m_text = m_timer.asString(m_showSeconds);
	StaticControl::draw(gdi);
}
