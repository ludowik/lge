#include "headers.h"
#include "game_input.h"
#include "game_engine.h"
#include "map.h"

int key_straight     = SDL_SCANCODE_E;
int key_back         = SDL_SCANCODE_X;
int key_left         = SDL_SCANCODE_S;
int key_right        = SDL_SCANCODE_D;
int key_up           = SDL_SCANCODE_UP;
int key_down         = SDL_SCANCODE_DOWN;
int key_half_turn    = SDL_SCANCODE_F;
int key_look_left    = SDL_SCANCODE_W;
int key_look_right   = SDL_SCANCODE_R;
int key_mode_indices = SDL_SCANCODE_I;
int key_voxel_mode   = SDL_SCANCODE_V;
int key_origin       = SDL_SCANCODE_O;
int key_with_noise   = SDL_SCANCODE_N;
int key_with_light   = SDL_SCANCODE_L;
int key_reload       = SDL_SCANCODE_U;

int key_accelerate = SDL_SCANCODE_LGUI;
int key_l_ctrl     = SDL_SCANCODE_LCTRL;
int key_r_ctrl     = SDL_SCANCODE_RCTRL;
int key_gravity    = SDL_SCANCODE_G;
int key_collision  = SDL_SCANCODE_K;
int key_zoom       = SDL_SCANCODE_EQUALS;

void OpenGLEngine::input(int frame_time) {
    m_input.pollEvent();

    // vitesse
    float vitesse = m_player.m_flyingMode ? 200 : 25; // la marche en kmh
    float multiplicator = 1;
    
    if ( m_input.m_keys[key_accelerate] > 0 ) {
        multiplicator = 10;
    }
    
    vitesse *= multiplicator;
    
    // avec ou sans pesanteur
    if ( m_input.m_keys[key_gravity] == 1 ) {
        m_player.m_flyingMode = !m_player.m_flyingMode;
    }
    
    // avec ou sans collison
    if ( m_input.m_keys[key_collision] == 1 ) {
        m_player.m_testCollision = !m_player.m_testCollision;
    }
    
    // straight
    if ( m_input.m_keys[key_straight] > 0 ) {
        m_player.m_speed.y = vitesse;
    } else if ( m_input.m_keys[key_straight] == -1 ) {
        m_player.m_speed.y = 0;
    }
    
    // back
    if ( m_input.m_keys[key_back] > 0 ) {
        m_player.m_speed.y = -vitesse;
    } else if ( m_input.m_keys[key_back] == -1 ) {
        m_player.m_speed.y = 0;
    }

    // left
    if ( m_input.m_keys[key_left] > 0 ) {
        m_player.m_speed.x = vitesse;
    } else if ( m_input.m_keys[key_left] == -1 ) {
        m_player.m_speed.x = 0;
    }
    
    // right
    if ( m_input.m_keys[key_right] > 0 ) {
        m_player.m_speed.x = -vitesse;
    } else if ( m_input.m_keys[key_right] == -1 ) {
        m_player.m_speed.x = 0;
    }
    
    // top / up
    if ( m_input.m_keys[key_up] > 0 ) {
        // top
        if ( m_input.m_keys[key_l_ctrl] > 0 ) {
            m_player.m_flyingMode = true;
            set_up();
        }
        // up
        else {
            m_player.m_speed.z = +0.5 * multiplicator;
            m_player.m_flyingMode = true;
        }
    } else if ( m_input.m_keys[key_up] == -1 ) {
        m_player.m_speed.z = 0;
    }
    
    // down / bottom
    if ( m_input.m_keys[key_down] > 0 ) {
        // bottom
        if ( m_input.m_keys[key_l_ctrl] > 0 ) {
            m_player.m_flyingMode = false;
            set_down();
        }
        // down
        else {
            m_player.m_speed.z = -0.5 * multiplicator;
        }
    } else if ( m_input.m_keys[key_down] == -1 ) {
        m_player.m_speed.z = 0;
    }
    
    // origin
    if ( m_input.m_keys[key_origin] == 1 ) {
        set_origin();
    }
    
    // half turn
    if ( m_input.m_keys[key_half_turn] == 1 ) {
        m_input.m_keys[key_half_turn]++;
        m_player.m_theta += pi;
    }
    
    // turning the head on the left
    if ( m_input.m_keys[key_look_left] > 0 ) {
        m_player.m_dtheta -= pi/20.;
        m_player.m_dtheta = max(m_player.m_dtheta, -pi/2.);
    } else if ( m_input.m_keys[key_look_left] == -1 ) {
        m_player.m_dtheta = 0;
    }
    
    // turning the head on the right
    if ( m_input.m_keys[key_look_right] > 0 ) {
        m_player.m_dtheta += pi/20.;
        m_player.m_dtheta = min(m_player.m_dtheta, +pi/2.);
    } else if ( m_input.m_keys[key_look_right] == -1 ) {
        m_player.m_dtheta = 0;
    }
    
    // horizontal look
    if ( m_input.m_xrel != 0 ) {
        m_player.m_theta += 0.005 * m_input.m_xrel;
    }
    
    // vertical look
    if ( m_input.m_yrel != 0 ) {
        m_player.m_phi -= 0.005 * m_input.m_yrel;
        m_player.m_phi = minmax(m_player.m_phi, -pi*0.45, pi*0.45);
    }
    
    // changement de perspective
    if ( m_input.m_keys[key_zoom] > 0 ) {
        if ( m_input.m_keys[SDL_SCANCODE_RSHIFT] > 0 ) {
            m_perspective_fovy += 1;
        } else {
            m_perspective_fovy -= 1;
        }
    }
    
    // vertices / indices
    if ( m_input.m_keys[key_mode_indices] == 1 ) {
        prop_mode_indices = !prop_mode_indices;
        ((GameEngine*)g_engine)->voxel_upload(true);
    }
    
    // voxel mode
    if ( m_input.m_keys[key_voxel_mode] == 1 ) {
        prop_voxel_mode = !prop_voxel_mode;
        ((GameEngine*)g_engine)->voxel_upload(true);
    }
    
    // with or without noise
    if ( m_input.m_keys[key_with_noise] == 1 ) {
        prop_with_noise = !prop_with_noise;
        ((GameEngine*)g_engine)->voxel_upload(true);
    }
    
    // with or without light
    if ( m_input.m_keys[key_with_light] == 1 ) {
        prop_with_light = !prop_with_light;
    }
    
    // reload
    if ( m_input.m_keys[key_reload] == 1 ) {
        ((GameEngine*)g_engine)->voxel_upload(true);
    }
    
}
