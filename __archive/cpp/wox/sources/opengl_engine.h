#pragma once

#include "headers.h"

#include "variable.h"
#include "ortho.h"
#include "voxel.h"
#include "input.h"
#include "pnj.h"

extern class OpenGLEngine* g_engine;

class OpenGLEngine {
public:
    OpenGLEngine(const char* wndTitle, int w, int h);
    virtual ~OpenGLEngine();
    
public:
    bool init();
    
    bool init_sdl();
    bool init_gl();

    void release();
    
public:
    virtual bool game_init();
    virtual void game_update(int time);
    
public:
    virtual bool model_init();
    virtual void model_draw();
    virtual void model_update(int ticks_frame);
    virtual void model_release();
    
public:
    virtual void info_update();
    virtual void info_feedback();

public:
    void run();
    void iteration();
    
    void input(int frame_time);
    
    void draw();
    
public:
    virtual void set_origin();
    virtual void set_up();
    virtual void set_down();

public:
    glm::mat4 m_modelView;
    glm::mat4 m_projection;
    
    GLfloat m_perspective_fovy;
    GLfloat m_perspective_aspect;
    GLfloat m_perspective_near;
    GLfloat m_perspective_far;
    
    int m_w;
    int m_h;
    
public:
    std::string m_wndTitle;
    
    SDL_Window* m_wnd;
    
    SDL_GLContext m_contextOpenGL;
    SDL_Event m_events;
    
    Pnj m_player;

    Models m_models;
    
    Input m_input;
    
    int m_nframes;
    int m_frames_delay;

    var_int m_fps;
    var_int m_frame_delay;
    
    string m_str_out;

    float m_gravity;
    
public:
    Uint32 m_ticks_frame;
    Uint32 m_ticks_second;

    int m_frame_rate;
    int m_frame_time;

    int m_fps_theoric;
    
    int m_nvertices_total;
    int m_nvertices_visible;
        
};
