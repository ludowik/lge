#pragma once

constexpr int CHUNK_SIZE( 100 );
constexpr int CHUNK_COUNT( 100 );

constexpr int CHUNK_HEIGHT( 128 );

constexpr int MAP_SIZE( CHUNK_SIZE * CHUNK_COUNT );
constexpr int MAP_HALF_SIZE( MAP_SIZE >> 1 );

constexpr int COMPUTE_Z( -1 );

typedef unsigned char byte;

struct block {
    float h;
    byte material;
    byte noise;
};

enum Material : unsigned char {
    vide = 0,
    terre = 1,
    eau,
    herbe,
    bois,
    feuillage,
    cactus,
    roche,
    beton,
    verre,
    neige,
    nuage,
    max_material,
    null_material = 0xFF
};

extern block block_null;

typedef int coord;

class Chunk {
public:
    Chunk();
    virtual ~Chunk();
    
public:
    void alloc(int size, int h);
    void release();
        
public:
    block& get_block(coord x, coord y, coord z);
    
    byte get_material(coord x, coord y, coord z);
    void set_material(coord x, coord y, coord z, byte material);

private:
	int m_size;
    int m_h;
	
    block*** blocks;
    
};
