#pragma once

#include "chunk.h"

class Map {
public:
    Map();
    virtual ~Map();
    
public:
    void init(int size);
	void release();
    
private:
    Chunk* chunk_get  (int i, int j);
    Chunk* chunk_alloc(int i, int j);

public:
    bool validate_coord(coord x, coord y, coord z);
    bool convert_coord(coord x, coord y, coord z, int& ix, int& iy, int& iz);
    
    block& get_block(coord x, coord y, coord z);
    
    byte get_material(coord x, coord y, coord z);
    void set_material(coord x, coord y, coord z, byte material);
    
    byte get_z(coord x, coord y, coord z = CHUNK_HEIGHT - 1);
    float get_average_z(coord x, coord y);
        
private:
    Chunk*** m_chunks;

};

namespace color {
    void init();
    GLfloat* get(byte material, byte material_rand, float z);
    
};
