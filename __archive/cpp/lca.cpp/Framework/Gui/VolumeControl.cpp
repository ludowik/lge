#include "System.h"
#include "VolumeControl.h"

VolumeControl::VolumeControl() : GaugeControl(0, 100) {
	m_class = "VolumeControl";

	m_val = System::Media::getSoundVolume();
	m_readOnly = false;
}

VolumeControl::~VolumeControl() {
}

void VolumeControl::OnChangeVal() {
	System::Media::setSoundVolume(m_val);
}