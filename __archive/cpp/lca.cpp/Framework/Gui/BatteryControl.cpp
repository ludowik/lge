#include "System.h"
#include "BatteryControl.h"

BatteryControl::BatteryControl() : GaugeControl(0) {  
	m_class = "BatteryControl";
	m_layoutText = posRightAlign|posHCenter;

	m_val = (int)System::Battery::getPercent();  
}

BatteryControl::~BatteryControl() {
}

void BatteryControl::draw(GdiRef gdi) {
	m_val = (int)System::Battery::getPercent();
	GaugeControl::draw(gdi);
}
