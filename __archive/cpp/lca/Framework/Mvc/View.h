#pragma once

#include "StatusBarControl.h"
#include "ToolBarControl.h"
#include "Animation.h"

DeclareClass(Model);
DeclareClass(Gdi);
DeclareClass(Control);

ImplementClass(View) : public Control {
public:
	int g_nDrawing;
	
	int g_frameRateReal;
	int g_frameRateCapacity;
	
	Timer g_timerRunning;
	Timer g_timerDrawing;

public:
	static GdiRef g_gdi;

public:
	bool m_shouldRotateToLandscape;
	bool m_shouldRotateToPortrait;

	BitmapList m_resources;

public:
	ModelRef m_model;
	
	bool m_modal;
	bool m_close;
	bool m_compute;

	bool m_needsRedraw;
	bool m_needsRedrawAutomatic;

	bool m_right2left;
		
	int m_lastId;
	
	GdiRef m_bgImage;

	AnimationRef m_animation;

	StatusBarControlRef m_statusbar;
	ControlRef m_area;
	ToolBarControlRef m_toolbar;
    
    ControlRef m_touchCtrl;

public:
	View();
	virtual ~View();
	
public:
	bool shouldAutorotateToInterfaceOrientation(int orientation);
	
public:
	virtual void init(); // Initialiation des donnees internes de la vue
	virtual void releaseGdi(); // Liberation du Gdi
	
	virtual void createView(); // Creation de la vue
	virtual void createUI(); // Creation de l'interface utilisateur
	virtual void createToolBar(); // Creation de la toolbar
	
	virtual void loadResource(); // Chargement des ressources graphiques
	virtual void loaded(); // Preparation de la vue terminee !
	
public:
	virtual void draw(RectRef rect);
	virtual void draw(GdiRef gdi);
	
	void erase(GdiRef gdi);
	
public:
	virtual void computeSize(GdiRef gdi);
	
public:
    virtual bool touchNotify(ControlRef ctrl);

	virtual bool touchBegin(int x, int y);
	virtual bool touchMove (int x, int y);
	virtual bool touchEnd  (int x, int y);

	virtual bool touchDoubleTap(int x, int y);
	virtual bool touchTripleTap(int x, int y);
	
public:
	virtual bool acceleration(double x, double y, double z);
	
public:
	virtual bool timer();

public:
	virtual bool onClose  (ObjectRef obj);
	virtual bool onFlip   (ObjectRef obj);
	virtual bool onModeGdi(ObjectRef obj);
	
public:
	virtual int run();

public:
	virtual bool animate();

};
