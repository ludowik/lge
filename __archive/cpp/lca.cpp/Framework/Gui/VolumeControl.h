#pragma once

#include "GaugeControl.h"

ImplementClass(VolumeControl) : public GaugeControl {
public:
	VolumeControl();
	virtual ~VolumeControl();
	
public:
	virtual void OnChangeVal();
	
};
