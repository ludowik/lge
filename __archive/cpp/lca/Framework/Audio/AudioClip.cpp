#include "System.h"
#include "AudioClip.h"

AudioClip::AudioClip(const char* resId) : Object() {
	m_class = "AudioClip";
	m_resId = 0;
	m_resHandle = 0;
	
	load(resId);
}

AudioClip::~AudioClip() {
	release();
}

void AudioClip::load(const char* resId) {
	release();
	
	m_resId = resId;
	if ( m_resId ) {
		m_resHandle = System::Media::loadSound(m_resId);
	}
}

void AudioClip::release() {
	if ( m_resHandle ) {
		System::Media::releaseSound(m_resHandle);
		m_resHandle = 0;
	}
}

void AudioClip::play(int nb) {
	if ( m_resHandle ) {
		System::Media::playSound(m_resHandle, nb);
	}
}
