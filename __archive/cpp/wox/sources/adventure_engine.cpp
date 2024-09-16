#include "headers.h"
#include "adventure_engine.h"
#include "pnj.h"

// Affichage du réticule
GLfloat reticule_vertices[] = {
    -5, 0, 0,   -1, 0, 0,
    +1, 0, 0,   +5, 0, 0,
     0,-5, 0,    0,-1, 0,
     0,+1, 0,    0,+5, 0,
};

AdventureGameEngine::AdventureGameEngine(const char* wndTitle, int w, int h) : GameEngine(wndTitle, w, h) {
}

AdventureGameEngine::~AdventureGameEngine() {
}

bool AdventureGameEngine::game_init() {
    GameEngine::game_init();
    
    reticule.m_shader = shader::get("color2d");
    reticule.m_drawMode = GL_LINES;
    reticule.m_polygonMode = GL_LINE;
    reticule.m_vertices.add(8, (GLfloat*)reticule_vertices);
    reticule.m_colors.repeat(reticule.m_vertices.get_n(), c_black);
    reticule.scale(vec3(0.01,0.01,0));
    reticule.init(this);
    
    barre_de_vie.m_shader = shader::get("color2d");
    barre_de_vie.createRect(vec3(  50, -g_engine->m_h+100, 0), 200, -40);
    barre_de_vie.createRect(vec3(g_engine->m_w-200-50, -g_engine->m_h+100, 0), 200, -40);
    barre_de_vie.transform_for_screen();
    barre_de_vie.m_colors.repeat(barre_de_vie.m_vertices.get_n(), c_red);
    barre_de_vie.init(this);
    
    skybox.m_shader = shader::get("color3d");
    skybox.createCube(origin, 1024);
    skybox.m_colors.repeat(skybox.m_vertices.get_n(), c_red, true);
    //skybox.center();
    //skybox.m_position = m_player.m_position;
    skybox.computeNormals();
    skybox.init(this);
        
    return true;
}

bool AdventureGameEngine::model_init() {
    GameEngine::model_init();

    Pnj* pnj = new Pnj();
    pnj->computeNormals();
    pnj->m_position = m_player.m_position + m_player.m_direction + vec3(0, 0, 2);
    pnj->m_direction = m_player.m_direction;
    pnj->m_vangle = vec3(10);
    pnj->m_speed.y = 5;

    m_models.push_back(pnj);
    
    return true;
}

void AdventureGameEngine::cactus_branche(int x, int y, int z, int h, int dx, int dy) {
    h = rand(h-6, h-2);
    m_map.set_material(x+dx, y+dy, z+2, ::cactus);
    for ( int i = 0; i < h; ++i) {
        m_map.set_material(x+dx+dx, y+dy+dy, z+2+i, ::cactus);
    }
}

void AdventureGameEngine::cactus(int x, int y, int z) {
    // tronc
    int h = rand(4, 8);
    for ( int i = 0; i < h; ++i) {
        m_map.set_material(x, y, z+i, ::cactus);
    }
    
    cactus_branche(x, y, z, h, +1, 0);
    cactus_branche(x, y, z, h, -1, 0);
}

void AdventureGameEngine::arbre(int x, int y, int z) {
    // tronc
    m_map.set_material(x, y, z++, bois);
    m_map.set_material(x, y, z++, bois);
    m_map.set_material(x, y, z++, bois);
    
    // feuillage
    for ( int k = 0; k < 2; k++) {
        for (int i = -2 + k; i <= 2 - k; ++i) {
            for (int j = -2 + k; j <= 2 - k; ++j) {
                m_map.set_material(x+i, y+j, z  , feuillage);
                m_map.set_material(x+i, y+j, z+1, feuillage);
            }
        }
        
        z += 2;
    }
}

void AdventureGameEngine::vegetation() {
    for ( int i = 0; i < 1000; ++i ) {
        int x = rand(10, MAP_SIZE - 10);
        int y = rand(10, MAP_SIZE - 10);
        
        int z = get_z(x, y, COMPUTE_Z);
        
        if ( m_map.get_material(x, y, z-1) == herbe ) {
            arbre(x, y, z);
        } else if ( m_map.get_material(x, y, z-1) == terre ) {
            cactus(x, y, z);
        }
    }
}

void AdventureGameEngine::pyramide(int x, int y, int z, int h) {
    z = get_z(x, y, z) - 1;

    //m_map.mise_a_niveau_du_sol(x, y, z, 2 * h + 4, 2 * h + 4);

    for ( int k = h; k >= 0; --k ) {
        for (int i = x - k; i <= x + k; ++i) {
            for (int j = y - k; j <= y + k; ++j) {
                m_map.set_material(i, j, z+h-k, beton);
            }
        }
    }
}

void AdventureGameEngine::silo(int x, int y, int z, int r, int h) {
    z = get_z(x, y, z) - 1;
    
    //m_map.mise_a_niveau_du_sol(x, y, z, 2 * r + 4, 2 * r + 4);

    for ( int i = 0; i < h; ++i ) {
        for ( float angle = 0; angle < 2 * pi; angle += 0.05f ) {
            GLfloat xs = x + 0.5f + r * cosf(angle);
            GLfloat ys = y + 0.5f + r * sinf(angle);
            
            GLfloat zs = (float)z + i;
            
            m_map.set_material(xs, ys, zs, beton);
        }
    }
}

void AdventureGameEngine::sphere(int x, int y, int z, int r) {
    z = get_z(x, y, z);
    
    for ( float theta= 0; theta < 2 * pi; theta += 0.05f ) {
        for ( float phi= 0; phi < 2 * pi; phi += 0.05f ) {
            GLfloat xs = x + 0.5f + r * cosf(phi) * sinf(theta);
            GLfloat ys = y + 0.5f + r * cosf(phi) * cosf(theta);
            
            GLfloat zs = (float)z + r * sinf(phi);
            
            m_map.set_material(xs, ys, zs, beton);
        }
    }
}

void AdventureGameEngine::escalier(int x, int y, int z, int h, int dx, int dy) {
    for ( int i = 0; i < h; ++i) {
        m_map.set_material(x, y, z+i, bois);
        
        // contrainte physique pour pouvoir utiliser l'escalier
        m_map.set_material(x, y, z+i+1, vide);
        m_map.set_material(x, y, z+i+2, vide);
        m_map.set_material(x, y, z+i+3, vide);
        
        x += dx;
        y += dy;
    }
}

void AdventureGameEngine::colimacon(int x, int y, int z, int h) {
    for ( int i = 0; i < h; ++i) {
        m_map.set_material(x, y, z+i, beton);
        
        switch ( i % 4) {
            case 0:
                y++;
                break;
            case 1:
                x--;
                break;
            case 2:
                y--;
                break;
            case 3:
                x++;
                break;
        }
    }
}

void AdventureGameEngine::mur(int x, int y, int z, int w, int h, int dx, int dy) {
    mur(x, y, z, w, h, dx, dy, beton);
}

void AdventureGameEngine::mur(int x, int y, int z, int w, int h, int dx, int dy, byte material, byte material2) {
    for ( int i = 0; i < w; ++i ) {
        for ( int j = 0; j < h; ++j ) {
            if ( material2 == null_material || i % 2 == 0 ) {
                m_map.set_material(x + dx * i, y + dy * i, z + j, material);
            } else {
                m_map.set_material(x + dx * i, y + dy * i, z + j, material2);
            }
        }
    }
}

void AdventureGameEngine::plancher(int x, int y, int z, int w, int h, byte material) {
    for ( int i = 0; i < w; ++i ) {
        for ( int j = 0; j < h; ++j ) {
            m_map.set_material(x + i, y + j, z, material);
        }
    }
}

void AdventureGameEngine::plancher(int x, int y, int z, int w, int h) {
    plancher(x, y, z, w, h, bois);
}

void AdventureGameEngine::tour(int x, int y, int z, int w, int h) {
    byte base_material = beton;
    
    z = get_z(x, y, z) - 1;
    
    w += ( w + 1 ) % 2;

    //m_map.mise_a_niveau_du_sol(x, y, z, w + 4, w + 4);
    
    x -= w / 2;
    y -= w / 2;
    
    plancher(x, y, z, w, w, base_material);
    
    z++;
    
    mur(x, y, z, w, h, 1, 0);
    mur(x+w/2-1, y, z, 2, 2, 1, 0, vide);
    mur(x, y, z, w, h, 0, 1);
    mur(x, y+w-1, z, w, h, 1, 0);
    mur(x+w-1, y, z, w, h, 0, 1);
    
    plancher(x+1, y+1, z+h-1, w-2, w-2, bois);

    int dh;
    int dz = z;
    
    dh = ( w / 2 ) - 1;
    escalier(x+w-2, y+w/2, dz, dh, 0, 1);
    dz += dh - 1;

    int cote = 0;
    while ( dz < z + h -1 ) {
        dh = min(w - 2, z + h - dz);
        
        switch ( cote++ ) {
            case 0:
                escalier(x+w-2, y+w-2, dz, dh, -1,  0);
                break;
            case 1:
                escalier(x+1  , y+w-2, dz, dh,  0, -1);
                break;
            case 2:
                escalier(x+1  , y+1  , dz, dh,  1,  0);
                break;
            case 3:
                escalier(x+w-2, y+1  , dz, dh,  0,  1);
                cote = 0;
                break;
        }
        
        dz += dh - 1;
    }
    
    x--;
    y--;
    
    w += 2;
    h = 1;
    
    z = dz + 1;
    mur(x, y, z, w, 1, 1, 0, base_material);
    mur(x, y, z, w, h, 0, 1, base_material);
    mur(x, y+w-1, z, w, h, 1, 0, base_material);
    mur(x+w-1, y, z, w, h, 0, 1, base_material);

    z++;
    mur(x, y, z, w, 1, 1, 0, base_material, vide);
    mur(x, y, z, w, h, 0, 1, base_material, vide);
    mur(x, y+w-1, z, w, h, 1, 0, base_material, vide);
    mur(x+w-1, y, z, w, h, 0, 1, base_material, vide);
}

void AdventureGameEngine::model_draw() {
    skybox.draw(this);
    
    GameEngine::model_draw();
    
    reticule.draw(this);
    barre_de_vie.draw(this);
}
