#include "headers.h"
#include "chunk.h"

block block_null = {
    vide,
    0
};

Chunk::Chunk() {
    blocks = NULL;
    
    m_size = 0;
    m_h = 0;
}

Chunk::~Chunk() {
    release();
}

void Chunk::alloc(int size, int h) {
    blocks = alloc_array3D<block>(h, size, size);
    
    m_size = size;
	m_h = h;
}

void Chunk::release() {
    release_array3D<block>(blocks, m_h, m_size, m_size);
    
	m_size = 0;
	m_h = 0;
}

block& Chunk::get_block(coord x, coord y, coord z) {
    return blocks[z][x][y];
}

byte Chunk::get_material(coord x, coord y, coord z) {
    return get_block(x, y, z).material;
}

void Chunk::set_material(coord x, coord y, coord z, byte material) {
    block& bl = get_block(x, y, z);
    
    bl.material = byte(material);
    bl.noise = byte(rand(254));
}
