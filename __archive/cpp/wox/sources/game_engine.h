#pragma once

#include "headers.h"

#include "variable.h"
#include "opengl_engine.h"
#include "input.h"
#include "ortho.h"
#include "voxel.h"
#include "pnj.h"

class GameEngine : public OpenGLEngine {
public:
    GameEngine(const char* wndTitle, int w, int h);
    virtual ~GameEngine();
    
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
    void voxel_upload(bool init = false);
    void voxel_set_level(Voxel* v, int xv, int yv);
    bool voxel_refresh(int ticks, int delay, int level);
    
public:
    virtual void set_origin();
    virtual void set_up();
    virtual void set_down();

    int get_z(int x, int y, int z);

public:
    Map m_map;
    
    GLfloat m_z;
    
    Models m_voxels;

    list<Voxel*> m_voxels_toupdate;

    Voxel* (*voxels)[VOXEL_COUNT];
    
    Voxel* voxels1[VOXEL_COUNT][VOXEL_COUNT];
    Voxel* voxels2[VOXEL_COUNT][VOXEL_COUNT];

private:
    int m_nvoxels_total;
    int m_nvoxels_visible;

};
