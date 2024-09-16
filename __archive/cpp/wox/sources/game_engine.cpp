#include "headers.h"
#include "game_engine.h"
#include "game_input.h"

GameEngine::GameEngine(const char* wndTitle, int w, int h) :
OpenGLEngine(wndTitle, w, h),
m_nvoxels_total(0),
m_nvoxels_visible(0),
m_z(1.8f),
voxels(NULL),
voxels1(),
voxels2() {
    assert(g_engine == NULL);
    g_engine = this;
}

GameEngine::~GameEngine() {
}

bool GameEngine::game_init() {
    OpenGLEngine::game_init();
    return true;
}

void GameEngine::game_update(int time) {
    OpenGLEngine::game_update(time);
    
    // collision ?
    if ( m_player.m_testCollision ) {
        if  ( m_map.get_material(m_player.m_position.x, m_player.m_position.y, m_player.m_position.z  ) != 0 ||
             m_map.get_material(m_player.m_position.x, m_player.m_position.y, m_player.m_position.z-1) != 0 ) {
            
            // collision
            if ( m_map.get_material(m_player.m_position.x, m_player.m_position.y, m_player.m_position.z) != vide ) {
                // on peut pas monter donc on revient à la place précédente
                m_player.m_position = m_player.m_position_old;
            } else {
                // on peut monter
                if ( m_player.m_flyingMode ) {
                    m_player.m_position.z += 1;
                }
            }
        }
    }
    
    // pesanteur
    if ( !m_player.m_flyingMode ) {
        for ( int z = m_player.m_position.z; z >= 0;  --z ) {
            if ( m_map.get_material(m_player.m_position.x, m_player.m_position.y, z) != 0 || z == 0 ) {
                GLfloat h = m_player.m_position.z - ( z + 1 );
                if ( h > m_z ) {
                    // pesanteur
                    m_player.m_position.z = max(z+1+m_z, m_player.m_position.z - distance_by_frame(m_gravity, m_frame_time));
                } else if ( h < m_z ) {
                    // alignement
                    m_player.m_position.z = min(z+1+m_z, m_player.m_position.z + distance_by_frame(m_gravity, m_frame_time));
                }
                break;
            }
        }
    }
}

bool GameEngine::model_init() {
    OpenGLEngine::model_init();
    
	voxels = voxels1;
    for ( int x = 0; x < VOXEL_COUNT; ++x ) {
        for ( int y = 0; y < VOXEL_COUNT; ++y ) {
            voxels[x][y] = new Voxel();
            voxels[x][y]->init(this);
            
            m_voxels.push_back(voxels[x][y]);
        }
    }
    
    m_map.init(CHUNK_COUNT);
    
    set_origin();
    
    return true;
}

void GameEngine::model_release() {
    m_voxels.release();
    m_map.release();
}

void GameEngine::model_update(int ticks_frame) {
    m_voxels_toupdate.sort([](Voxel* v1, Voxel* v2) {
        float distance_1 = glm::distance(v1->m_position, g_engine->m_player.m_position);
        float distance_2 = glm::distance(v2->m_position, g_engine->m_player.m_position);
        
        return distance_1 < distance_2 ? true : false;
    });
    
    voxel_upload();

    voxel_refresh(ticks_frame, m_frame_time, 0) &&
    voxel_refresh(ticks_frame, m_frame_time, 1) &&
    voxel_refresh(ticks_frame, m_frame_time, 2);
}

void GameEngine::info_update() {
    OpenGLEngine::info_update();

    m_nvoxels_total = 0;
    m_nvoxels_visible = 0;

    for ( int x = 0; x < VOXEL_COUNT; ++x ) {
        for ( int y = 0; y < VOXEL_COUNT; ++y ) {
            Voxel* m = voxels[x][y];
            
            m_nvertices_total += m->m_vertices.get_n();
            m_nvoxels_total++;
            
            if ( m->is_visible(m_player.m_position, m_player.m_direction) ) {
                m_nvertices_visible += m->m_vertices.get_n();
                m_nvoxels_visible++;
            }
        }
    }
}

void GameEngine::info_feedback() {
    OpenGLEngine::info_feedback();
    
    ostringstream str_out_stream;
    str_out_stream
    << "voxels     : " << m_nvoxels_visible << " / " << m_nvoxels_total << std::endl;
    
    m_str_out += str_out_stream.str();
}

void GameEngine::voxel_upload(bool init) {
    static const int px_ref = CLIP_HALF_SIZE;
    static const int py_ref = CLIP_HALF_SIZE;
    
    int fx = int(m_player.m_position.x) / VOXEL_SIZE;
    int fy = int(m_player.m_position.y) / VOXEL_SIZE;

    if ( init ) {
        m_voxels_toupdate.clear();
        
        assert(m_voxels_toupdate.size()==0);
        
        for ( int x = 0; x < VOXEL_COUNT; ++x ) {
            for ( int y = 0; y < VOXEL_COUNT; ++y ) {
                int px = ( ( fx + x ) * VOXEL_SIZE ) - px_ref;
                int py = ( ( fy + y ) * VOXEL_SIZE ) - py_ref;
                
                auto v = voxels[x][y];
                m_voxels_toupdate.push_back(v);
                
                voxel_set_level(v, x, y);
                
                v->m_needRefresh = true;
                v->m_position = vec3(px, py, 0);
            }
        }
        m_player.m_position_previous = m_player.m_position;
    }
    else if ( m_player.m_position != m_player.m_position_previous ) {
        int dx = fx - ( int(m_player.m_position_previous.x) / VOXEL_SIZE );
        int dy = fy - ( int(m_player.m_position_previous.y) / VOXEL_SIZE );
        
        if ( dx || dy ) {
            if ( dx <= -VOXEL_COUNT || dx >= VOXEL_COUNT || dy <= -VOXEL_COUNT || dy >= VOXEL_COUNT ) {
                voxel_upload(true);
            } else {
                auto voxels_temp = voxels == voxels1 ? voxels2 : voxels1;
                
                for ( int x = 0; x < VOXEL_COUNT; ++x ) {
                    int xs = ( x + VOXEL_COUNT - dx ) % VOXEL_COUNT;
                    int px = ( fx + xs ) * VOXEL_SIZE - px_ref;
                    
                    for ( int y = 0; y < VOXEL_COUNT; ++y ) {
                        int ys = ( y + VOXEL_COUNT - dy ) % VOXEL_COUNT;
                        int py = ( fy + ys ) * VOXEL_SIZE - py_ref;
                        
                        Voxel* v = voxels[x][y];
                        assert(v);
                        
                        assert( xs >= 0 && xs < VOXEL_COUNT );
                        assert( ys >= 0 && ys < VOXEL_COUNT );
                        
                        voxels_temp[xs][ys] = v;
                        
                        voxel_set_level(v, x, y);
                        
                        if ( xs != x - dx || ys != y - dy ) {
                            m_voxels_toupdate.push_back(v);
                            v->m_needRefresh = true;
                        } else if ( v->need_refresh_level() ) {
                            m_voxels_toupdate.push_back(v);
                        }
                        
                        v->m_position = vec3(px, py, 0);
                    }
                }
                voxels = voxels == voxels1 ? voxels2 : voxels1;
                
                m_player.m_position_previous = m_player.m_position;
            }
        }
    }
}

void GameEngine::voxel_set_level(Voxel* v, int xv, int yv) {
    float distance = sqrtf(
        pow(VOXEL_HALF_COUNT - xv, 2.) +
        pow(VOXEL_HALF_COUNT - yv, 2.)
    );
    
    v->m_detail_level_next = 0;

    if ( distance < 2 ) {
        v->m_detail_level_next = 0;
    } else if ( distance < 4 ) {
        v->m_detail_level_next = 1;
    } else if ( distance < 6 ) {
        v->m_detail_level_next = 2;
    } else if ( distance < 8 ) {
        v->m_detail_level_next = 3;
    } else if ( distance < 10 ) {
        v->m_detail_level_next = 4;
    } else {
        v->m_detail_level_next = 5;
    }
}

bool GameEngine::voxel_refresh(int ticks, int delay, int level) {
    float rdelay = 0.90;
    
    if ( m_voxels_toupdate.size() > 0 ) {
        foreach(Voxel, voxel, list<Voxel*>, m_voxels_toupdate) {
            bool is_visible = voxel->is_visible(m_player.m_position, m_player.m_direction);
            
            bool need_refresh = voxel->need_refresh();
            bool need_refresh_level = voxel->need_refresh_level();
            
            if ( ( level == 0 && is_visible == true  && need_refresh ) ||
                 ( level == 1 && is_visible == true  && need_refresh_level ) ||
                 ( level == 2 && is_visible == false && ( need_refresh || need_refresh_level ) ) ) {
                it = m_voxels_toupdate.erase(it);
                voxel->refresh(&m_map);
                if ( get_delay(ticks) >= (float)delay * rdelay ) {
                    return false;
                }
            }
            else if ( voxel->need_refresh() == false && voxel->need_refresh_level() == false ) {
                it = m_voxels_toupdate.erase(it);
            }
        }
    }
    
    return true;
}

void GameEngine::model_draw() {
    OpenGLEngine::model_draw();
    
    // La scène
    m_voxels.draw(this);
}

void GameEngine::set_origin() {
    int pos = MAP_HALF_SIZE;
    m_player.m_position = vec3(pos, pos, 1000); // get_z(pos, pos, CHUNK_HEIGHT) + 1);
}

void GameEngine::set_up() {
    m_player.m_position.z = CHUNK_HEIGHT - 1;
}

void GameEngine::set_down() {
    m_player.m_position.z = get_z(m_player.m_position.x, m_player.m_position.y, COMPUTE_Z) + 1;
}

int GameEngine::get_z(int x, int y, int z) {
    return z == COMPUTE_Z ? m_map.get_z(x, y) : z;
}
