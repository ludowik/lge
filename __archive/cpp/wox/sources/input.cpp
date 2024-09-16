#include "headers.h"
#include "input.h"

Input::Input() :
m_quit(false),
m_x(0),
m_y(0),
m_xrel(0),
m_yrel(0) {
    memset(m_keys, 0, sizeof(m_keys));
    memset(m_keys_previous, 0, sizeof(m_keys_previous));
    memset(m_buttons, 0, sizeof(m_buttons));
}

Input::~Input() {
}

void Input::captureMouse(bool bCapture) {
    SDL_SetRelativeMouseMode(bCapture ? SDL_TRUE : SDL_FALSE);
    SDL_ShowCursor(bCapture ? SDL_DISABLE : SDL_ENABLE);
}

bool Input::pollEvent() {
    for ( int i = 0; i < SDL_NUM_SCANCODES; ++i ) {
        if ( m_keys_previous[i] == false ) {
            m_keys[i] = 0;
        } else {
            m_keys[i]++;
        }
    }
    
    int nEvents = 0;
    
    m_xrel = 0;
    m_yrel = 0;
    
    SDL_Event event;
    while ( SDL_PollEvent(&event) ) {
        pollEvent(&event);
        nEvents++;
    }
    
    return nEvents > 0 ? true : false;
}

bool Input::pollEvent(SDL_Event *event) {
    switch ( event->type ) {
        case SDL_KEYDOWN:
            if ( m_keys_previous[event->key.keysym.scancode] == false ) {
                m_keys_previous[event->key.keysym.scancode] = true;
                m_keys[event->key.keysym.scancode] = 1;
            }
            
            if ( m_keys[SDL_SCANCODE_ESCAPE] ) {
                m_quit = true;
            }
            
            //cout << "key : " << event->key.keysym.scancode << " (up = " << m_keys[event->key.keysym.scancode] << ")" << endl;
            break;
            
        case SDL_KEYUP:
            m_keys_previous[event->key.keysym.scancode] = false;
            m_keys[event->key.keysym.scancode] = -1;
            
            //cout << "key : " << ""<<event->key.keysym.scancode << " (down)" << endl;
            break;
            
        case SDL_MOUSEMOTION:
            m_x = event->motion.x;
            m_y = event->motion.y;
            
            m_xrel = event->motion.xrel;
            m_yrel = event->motion.yrel;
            break;
            
        case SDL_MOUSEBUTTONDOWN:
            m_buttons[event->button.button] = true;
            break;
            
        case SDL_MOUSEBUTTONUP:
            m_buttons[event->button.button] = false;
            break;
            
        case SDL_WINDOWEVENT:
            if ( event->window.event == SDL_WINDOWEVENT_CLOSE ) {
                m_quit = true;
            }
            break;
            
        default:
            return false;
    
    }
    
    return true;
}