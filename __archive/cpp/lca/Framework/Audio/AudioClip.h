#pragma once

ImplementClass(AudioClip) : public Object {
public:
	const char* m_resId;
	int m_resHandle;
	
public:
	AudioClip(const char* resId=0);
	virtual ~AudioClip();
	
public:
	void load(const char* resId);
	void release();
	
public:	
	void play(int nb=1);
	
};
