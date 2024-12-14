#pragma once

#include "GaugeControl.h"

ImplementClass(BatteryControl) : public GaugeControl {
public:
	BatteryControl();
	virtual ~BatteryControl();

public:
	virtual void draw(GdiRef gdi);

};
