#pragma once

#include "model.h"
#include "map.h"

constexpr int VOXEL_SIZE( 64 );
constexpr int VOXEL_COUNT( 64 );

constexpr int CLIP_SIZE( VOXEL_SIZE * VOXEL_COUNT );
constexpr int CLIP_HALF_SIZE( CLIP_SIZE / 2 );

constexpr int VOXEL_HALF_COUNT( VOXEL_COUNT / 2 );

#define a1 0.0, 0.0, 0.0
#define b1 1.0, 0.0, 0.0
#define c1 1.0, 1.0, 0.0
#define d1 0.0, 1.0, 0.0

#define a2 0.0, 0.0, 1.0
#define b2 1.0, 0.0, 1.0
#define c2 1.0, 1.0, 1.0
#define d2 0.0, 1.0, 1.0

#define down      0.0,  0.0, -1.0
#define up        0.0,  0.0,  1.0
#define right     1.0,  0.0,  0.0
#define left     -1.0,  0.0,  0.0
#define straight  0.0, -1.0,  0.0
#define back      0.0,  1.0,  0.0

extern GLfloat cube_vertices6[];
extern GLfloat cube_normals6[];

extern GLfloat cube_vertices4[];
extern GLushort cube_indices4[];

class Voxel : public Model {
public:
    Voxel();
    virtual ~Voxel();
    
public:
    virtual void init(OpenGLEngine* engine);

    virtual bool is_visible(const vec3& position, const vec3& direction);
    virtual bool is_visible(vec3 point, vec3 position, vec3 direction);

public:
    void upload(Map* map, int x, int y);
    void upload(Map* map, int x, int y, int z);

    void refresh(Map* map);
    
    bool need_refresh();
    bool need_refresh_level();

protected:
    void add_block(Map* map, int x, int y, int w);
    
    void add_block1(Map* map, int x, int y, int z, int w, block bl, block* blocks);
    void add_block2(Map* map, int x, int y, int z, int w, block bl, block* blocks);
    
    virtual void draw(OpenGLEngine* engine);
    
public:
    int m_detail_level_current;
    int m_detail_level_next;
    
};
