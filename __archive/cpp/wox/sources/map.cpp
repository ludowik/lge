#include "headers.h"
#include "map.h"

Map::Map() {
}

Map::~Map() {
	release();
}

void Map::init(int size) {
    m_chunks = alloc_array2D<Chunk*>(CHUNK_COUNT, CHUNK_COUNT);
}

void Map::release() {
    release_array2D<Chunk*>(m_chunks, CHUNK_COUNT, CHUNK_COUNT, true);
}

Chunk* Map::chunk_get(int i, int j) {
    Chunk* chunk = m_chunks[i][j];
    if ( chunk == NULL ) {
        chunk = m_chunks[i][j] = chunk_alloc(i, j);
    }
    
    return chunk;
}

Chunk* Map::chunk_alloc(int i, int j) {
    Chunk* chunk = new Chunk();
    chunk->alloc(CHUNK_SIZE, 1);
    
    int x = i * CHUNK_SIZE;
    int y = j * CHUNK_SIZE;
    
    for ( int xo = 0; xo < CHUNK_SIZE; ++xo ) {
        for ( int yo = 0; yo < CHUNK_SIZE; ++yo ) {
            block& bl = chunk->get_block(xo, yo, 0);
            bl.h = height_map(x + xo, y + yo);
            bl.material = terre;
            bl.noise = rand(256);
        }
    }
    
    return chunk;
}

bool Map::validate_coord(coord x, coord y, coord z) {
    if ( x >= 0 && x < MAP_SIZE && y >= 0 && y < MAP_SIZE ) {
        return true;
    }
    
    return false;
}

block& Map::get_block(coord x, coord y, coord z) {
    if ( validate_coord(x, y, z) ) {
        int xx = x;
        int yy = y;
        
        int i = xx / CHUNK_SIZE;
        int j = yy / CHUNK_SIZE;
        
        int xo = xx % CHUNK_SIZE;
        int yo = yy % CHUNK_SIZE;
        
        Chunk* chunk = chunk_get(i, j);
        
        block& bl = chunk->get_block(xo, yo, 0);
        if ( bl.h >= z ) {
            bl.material = terre;
        } else {
            bl.material = vide;
        }
        
        return bl;
    }
    
    return block_null;
}

byte Map::get_material(coord x, coord y, coord z) {
    return get_block(x, y, z).material;
}

void Map::set_material(coord x, coord y, coord z, byte material) {
    block& bl = get_block(x, y, z);
    bl.material = material;
}

byte Map::get_z(coord x, coord y, coord z) {
    return height_map(x, y);
}

float Map::get_average_z(coord x, coord y) {
    return height_map(x, y);
}

/*
void Map::mise_a_niveau_du_sol(int x, int y, int z, int w, int h) {
    int size = MAX_SIZE;

    int material = get_material(x, y, z);
    
    w /= 2;
    h /= 2;
    
    // bornes de la matrice
    area(w);

    for ( int ix = ix1; ix <= ix2; ++ix ) {
        for ( int iy = iy1; iy <= iy2; ++iy ) {
            int iz = 0;
            for ( ; iz <= z; ++iz ) {
                if ( get_block(ix, iy, iz).material == vide ) {
                    break;
                }
            }
            for ( ; iz <= z; ++iz ) {
                set_material(ix, iy, iz, material);
            }
            for ( ; iz < MAX_Z; ++iz ) {
                if ( get_block(ix, iy, iz).material == vide ) {
                    break;
                }
                set_material(ix, iy, iz, vide);
            }
        }
    }
}

void Map::generer_nuages() {
    int z = MAX_Z - 1;
    
    int n = rand(300, 400);
    
    for ( int in = 0; in < n; ++in ) {
        int x = rand(MAX_X);
        int y = rand(MAX_Y);
        
        int m = rand(150, 250);
        
        while ( m ) {
            x += rand(3) - 1;
            y += rand(3) - 1;
            
            x = minmax(x, 0, MAX_X-1);
            y = minmax(y, 0, MAX_Y-1);
            
            // if ( get_material(x, y, z) == vide )
            {
                set_material(x, y, z, nuage);
                m--;
            }
        }
    }
}
*/

void get_color_proc(byte material, byte material_rand, GLfloat *color) {
    static GLfloat r,g,b,a;
    a = 1.;
    
    switch ( material ) {
        case vide:
            r = 0;
            g = 0;
            b = 0;
            a = 0;
            break;
            
        case eau:
            r = 0;
            g = 0;
            b = 0.5;
            a = 0.3;
            break;
            
        case verre:
            r = 1;
            g = 1;
            b = 1;
            a = 0.01;
            break;
            
        case terre:
            r = 0.8;
            g = 0.7;
            b = 0.5;
            break;
            
        case roche:
            r = 0.8;
            g = 0.8;
            b = 0.75;
            break;
            
        case cactus:
        case herbe:
            r = 0;
            g = 0.75;
            b = 0;
            break;
            
        case bois:
            r = 0.5;
            g = 0.75;
            b = 0.25;
            break;
            
        case feuillage:
            r = 0;
            g = 0.5;
            b = 0;
            break;
            
        case beton:
            r = 0.75;
            g = 0.75;
            b = 0.75;
            break;
            
        case neige:
            r = 1;
            g = 1;
            b = 1;
            a = 1;
            break;
            
        case nuage:
            r = 1;
            g = 1;
            b = 1;
            a = 1;
            break;
            
        default:
            r = 1;
            g = 0;
            b = 0;
            break;
    }
    
    color[0] = r;
    color[1] = g;
    color[2] = b;
    color[3] = a;
}

GLfloat colors[max_material][4];

void color::init() {
    for ( int i = 0; i < max_material; ++i ) {
        get_color_proc(i, 0, colors[i]);
    }
}

GLfloat* color::get(byte material, byte material_rand, float z) {
    GLfloat noise = ( material_rand % 11 - 5 ) / 255.;

    static GLfloat color[4];
    color[0] = colors[material][0] + noise;
    color[1] = colors[material][1] + noise;
    color[2] = colors[material][2] + noise;
    color[3] = colors[material][3];
    
    return (GLfloat*)&color;

    float max = 64;
    color[0] += z/max;
    color[1] += z/max;
    color[2] += z/max;

    return (GLfloat*)&color;
}
