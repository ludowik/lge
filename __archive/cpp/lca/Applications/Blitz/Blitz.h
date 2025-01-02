//
//  Blitz.h
//  Lca
//
//  Created by Ludovic MILHAU on 26/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "TimeControl.h"
#include "Time.h"

class BlitzView : public View {
public:
    TimerControl m_time1;
    TimerControl m_time2;
    
    int m_player;
    
public:
    BlitzView();
    virtual ~BlitzView();
    
public:
    virtual void createView();
    
    virtual bool timer();

public:
    bool onInit(ObjectRef obj);
    bool onSwitch(ObjectRef obj);
    bool onPause(ObjectRef obj);
    
};
