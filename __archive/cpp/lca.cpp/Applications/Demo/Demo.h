#pragma once

#include "View.h"
#include "GraphControl.h"

ImplementClass(Demo) : public View {	
public:
	StaticControlRef m_fontCtrl;
	
	FloatControlRef m_accx;
	FloatControlRef m_accy;
	FloatControlRef m_accz;
	
	GraphSeries m_series;
	
	List m_fontNames;

public:
	Demo();
	
public:
	virtual void createUI();
	virtual void createToolBar();
	
public:
	virtual bool acceleration(double x, double y, double z);
    
public:
    bool launchTest       (ObjectRef obj);
    bool launchAppStore   (ObjectRef obj);
    bool launchiTunesStore(ObjectRef obj);
    bool launchGoogleMaps1(ObjectRef obj);
    bool launchGoogleMaps2(ObjectRef obj);
    bool launchCall       (ObjectRef obj);
    bool launchMail       (ObjectRef obj);
    bool launchSMS        (ObjectRef obj);
    bool launchSafari     (ObjectRef obj);
    bool launchYouTube    (ObjectRef obj);
    bool launchFaceBook   (ObjectRef obj);
	
};
