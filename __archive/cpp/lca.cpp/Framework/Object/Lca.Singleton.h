#pragma once

template<class cl> class Singleton {
protected:
	static cl* singleton;
	static bool autorelease;
	
public:
	Singleton(bool _autorelease=false) {
		singleton = 0;
		autorelease = _autorelease;
	}
	
	virtual ~Singleton() {
		if ( autorelease ) {
			delete singleton;
			singleton = 0;
		}
	}
	
public:
	static cl& getInstance();
	static void releaseInstance(); 

public:
	void initInstance();
	
};

template<class cl> bool Singleton<cl>::autorelease = false;

template<class cl> cl* Singleton<cl>::singleton = 0;
template<class cl> cl& Singleton<cl>::getInstance() {
	if ( !singleton ) {
		singleton = new cl();
	}
	return *singleton;
}

template<class cl> void Singleton<cl>::releaseInstance() {
	if ( singleton ) {
		delete singleton;
		singleton = 0;
	}
}
