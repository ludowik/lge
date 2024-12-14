#pragma once

#include "View.h"

ImplementClass(ColorView) : public View {
public:
	GaugeControlRef m_rGauge;
    GaugeControlRef m_gGauge;
	GaugeControlRef m_bGauge;
	
	GaugeControlRef m_hGauge;
	GaugeControlRef m_sGauge;
	GaugeControlRef m_lGauge;
	
	Color m_color;
	
	ColorControlRef m_colorCtrl;
    
    String m_hex;
	
public:
	ColorView(Color color=randomColor());
	virtual ~ColorView();
	
public:
	virtual void createUI();
	
	virtual bool onCopy(Object* obj);
    virtual bool onMail(Object* obj);
    
    virtual bool onDefineColor(Object* obj);
	
	virtual bool onRGBColor(Object* obj);
	virtual bool onHSLColor(Object* obj);

	virtual bool onReverse(Object* obj);
	
public:
	void setRGBColor(int R, int G, int B);
	void setHSLColor(int H, int S, int L);
	
};

Color selectColor(Color color);
