#pragma once

class Input {
public:
    Input();
    virtual ~Input();
    
public:
    bool pollEvent();
    bool pollEvent(SDL_Event *event);
    
    void captureMouse(bool bCapture);
    
public:
    int m_keys[SDL_NUM_SCANCODES];
    bool m_keys_previous[SDL_NUM_SCANCODES];
    
    bool m_buttons[8];
    
    int m_x;
    int m_y;
    
    int m_xrel;
    int m_yrel;
    
    bool m_quit;
    
};
