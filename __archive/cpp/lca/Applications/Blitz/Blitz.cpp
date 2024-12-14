//
//  Blitz.cpp
//  Lca
//
//  Created by Ludovic MILHAU on 26/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "System.h"
#include "Blitz.h"

ApplicationObject<BlitzView, Model> appBlitz("Blitz", "Blitz", "Blitz.png");

BlitzView::BlitzView() {
    m_player = 0;
    
    m_time1.m_timer.m_modeChrono = false;
    m_time2.m_timer.m_modeChrono = false;
    
    m_time1.m_opaque = true;
    m_time2.m_opaque = true;
    
    m_time1.m_fontSize = fontVeryLarge;
    m_time2.m_fontSize = fontVeryLarge;
}

BlitzView::~BlitzView() {
}

void BlitzView::createView() {    
    add(&m_time1);
    add(&m_time2);
    
    add(new ButtonControl("INIT"), posNextLine)->setListener(this, (FunctionRef)&BlitzView::onInit);

    add(new ButtonControl("SWITCH"))->setListener(this, (FunctionRef)&BlitzView::onSwitch);
    add(new ButtonControl("PAUSE"))->setListener(this, (FunctionRef)&BlitzView::onPause);
}

bool BlitzView::timer() {
    switch (m_player) {
        case 1:
            m_time1.m_timer.timerUpdate();
            break;
        case 2:
            m_time2.m_timer.timerUpdate();
            break;

	}
    
    return true;
}

bool BlitzView::onInit(ObjectRef obj) {
    m_player = 0;
    
    m_time1.m_timer.set(0, 5, 0);
    m_time2.m_timer.set(0, 5, 0);
    
    return true;
}

bool BlitzView::onSwitch(ObjectRef obj) {
    switch (m_player) {
        case 0:
        case 2:
            m_time1.m_timer.timerInit();
            m_time1.m_bgColor = green;
            m_time2.m_bgColor = black;
            m_time1.m_border = true;
            m_time2.m_border = false;
            m_player = 1;
            break;
            
        case 1:
            m_time2.m_timer.timerInit();
            m_time2.m_bgColor = green;
            m_time1.m_bgColor = black;
            m_time1.m_border = false;
            m_time2.m_border = true;
            m_player = 2;
            break;
            
    }
    
    return true;
}

bool BlitzView::onPause(ObjectRef obj) {
    m_player = -m_player;

    switch (m_player) {
        case 1:
            m_time1.m_timer.timerInit();
            m_time1.m_bgColor = green;
            break;
            
        case 2:
            m_time2.m_timer.timerInit();
            m_time2.m_bgColor = green;
            break;

        case -1:
            m_time1.m_bgColor = red;
            break;
            
        case -2:
            m_time2.m_bgColor = red;
            break;
    }

    return true;
}
