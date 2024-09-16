#include "headers.h"
#include "chunk.h"
#include "voxel.h"
#include "game_engine.h"

GLfloat cube_vertices6[] = {
    a1, d1, b1, b1, d1, c1, // dessous
    d2, a2, c2, c2, a2, b2, // dessus
    b2, b1, c2, c2, b1, c1, // droite
    d2, d1, a2, a2, d1, a1, // gauche
    a2, a1, b2, b2, a1, b1, // devant
    c2, c1, d2, d2, c1, d1, // derrière
};

GLfloat cube_vertices4[] = {
    a1, d1, b1, c1, // dessous
    d2, a2, c2, b2, // dessus
    b2, b1, c2, c1, // droite
    d2, d1, a2, a1, // gauche
    a2, a1, b2, b1, // devant
    c2, c1, d2, d1, // derrière
};

GLushort cube_indices4[] = {
    0, 1, 2, 2, 1, 3
};

GLfloat cube_normals6[] = {
    down,down,down,down,down,down, // dessous
    up,up,up,up,up,up, // dessus
    right,right,right,right,right,right, // droite
    left,left,left,left,left,left, // gauche
    straight,straight,straight,straight,straight,straight, // devant
    back,back,back,back,back,back, // derrière
};

Voxel::Voxel() :
m_detail_level_current(-1),
m_detail_level_next(4) {
    m_shader = NULL;
}

Voxel::~Voxel() {
}

void Voxel::init(OpenGLEngine* engine) {
    Model::init(engine);
    m_shader = shader::get("color3d");
}

void Voxel::upload(Map* map, int px, int py) {
    m_vertices.set_n(0);
    m_indices .set_n(0);
	m_normals .set_n(0);
	m_colors  .set_n(0);
    
    int px_max = px + VOXEL_SIZE;
    int py_max = py + VOXEL_SIZE;
    
    int p = pow(2., m_detail_level_current); // une puissance de 2

    for ( int x = px; x < px_max; x += p ) {
        for ( int y = py; y < py_max;  y += p ) {
            add_block(map, x, y, p);
        }
    }
}

void Voxel::add_block(Map* map, int x , int y, int w) {
    float z = map->get_average_z(x, y);
    
    vec3 a(x  , y  , map->get_average_z(x  , y  ));
    vec3 b(x+w, y  , map->get_average_z(x+w, y  ));
    vec3 c(x+w, y+w, map->get_average_z(x+w, y+w));
    vec3 d(x  , y+w, map->get_average_z(x  , y+w));
    
    m_vertices.add(1, (GLfloat*)&d);
    m_vertices.add(1, (GLfloat*)&a);
    m_vertices.add(1, (GLfloat*)&c);
    m_vertices.add(1, (GLfloat*)&c);
    m_vertices.add(1, (GLfloat*)&a);
    m_vertices.add(1, (GLfloat*)&b);
    
    block bl_a = map->get_block(x  , y  , a.z);
    block bl_b = map->get_block(x+w, y  , b.z);
    block bl_c = map->get_block(x+w, y+w, c.z);
    block bl_d = map->get_block(x  , y+w, d.z);
    
    computeNormals(6);

    if ( prop_with_noise ) {
        int n = m_vertices.get_n();
        translate(noise3(vec3(bl_d.noise)), 1, &m_vertices[(n-6)*3]);
        translate(noise3(vec3(bl_a.noise)), 1, &m_vertices[(n-5)*3]);
        translate(noise3(vec3(bl_c.noise)), 1, &m_vertices[(n-4)*3]);
        translate(noise3(vec3(bl_c.noise)), 1, &m_vertices[(n-3)*3]);
        translate(noise3(vec3(bl_a.noise)), 1, &m_vertices[(n-2)*3]);
        translate(noise3(vec3(bl_b.noise)), 1, &m_vertices[(n-1)*3]);
        
        m_colors.add(1, color::get(bl_d.material, bl_d.noise, z));
        m_colors.add(1, color::get(bl_a.material, bl_a.noise, z));
        m_colors.add(1, color::get(bl_c.material, bl_c.noise, z));
        m_colors.add(1, color::get(bl_c.material, bl_c.noise, z));
        m_colors.add(1, color::get(bl_a.material, bl_a.noise, z));
        m_colors.add(1, color::get(bl_b.material, bl_b.noise, z));
    } else {
        m_colors.add(1, color::get(bl_d.material, 0, z));
        m_colors.add(1, color::get(bl_a.material, 0, z));
        m_colors.add(1, color::get(bl_c.material, 0, z));
        m_colors.add(1, color::get(bl_c.material, 0, z));
        m_colors.add(1, color::get(bl_a.material, 0, z));
        m_colors.add(1, color::get(bl_b.material, 0, z));
    }

    m_needRefresh = true;
}

void Voxel::upload(Map* map, int px, int py, int pz) {
    m_vertices.set_n(0);
    m_indices .set_n(0);
	m_normals .set_n(0);
	m_colors  .set_n(0);
    
    int px_max = px + VOXEL_SIZE;
    int py_max = py + VOXEL_SIZE;
    
    int pz_max = pz + CHUNK_HEIGHT;
    pz = 0;
    
    int p = pow(2., m_detail_level_current); // une puissance de 2
    
    for ( int x = px; x < px_max; x += p ) {
        for ( int y = py; y < py_max;  y += p ) {
            for ( int z = pz; z < pz_max; ++z ) {
                block bl = map->get_block(x, y, z);
                if ( bl.material == vide ) {
                    break;
                }
                
                int material = bl.material;
                
                if ( material != 0 ) {
                    static block blocks[6];
                    blocks[0] = map->get_block(x  , y  , z-1);
                    blocks[1] = map->get_block(x  , y  , z+1);
                    blocks[2] = map->get_block(x+p, y  , z  );
                    blocks[3] = map->get_block(x-p, y  , z  );
                    blocks[4] = map->get_block(x  , y-p, z  );
                    blocks[5] = map->get_block(x  , y+p, z  );
                    
                    if (
                        (material != eau && (
                                             blocks[0].material == vide ||
                                             blocks[1].material == vide ||
                                             blocks[2].material == vide ||
                                             blocks[3].material == vide ||
                                             blocks[4].material == vide ||
                                             blocks[5].material == vide ||
                                             
                                             blocks[0].material == eau ||
                                             blocks[1].material == eau ||
                                             blocks[2].material == eau ||
                                             blocks[3].material == eau ||
                                             blocks[4].material == eau ||
                                             blocks[5].material == eau ))
                        
                        ||
                        
                        (material == eau && (
                                             blocks[0].material != eau ||
                                             blocks[1].material != eau ||
                                             blocks[2].material != eau ||
                                             blocks[3].material != eau ||
                                             blocks[4].material != eau ||
                                             blocks[5].material != eau ))
                        ) {
                        if ( prop_mode_indices == true ) {
                            add_block2(map, x, y, z, p, bl, blocks);
                        } else {
                            add_block1(map, x, y, z, p, bl, blocks);
                        }
                    }
                }
            }
        }
    }
}

void Voxel::add_block1(Map* map, int x, int y, int z, int w, block bl, block* blocks) {
	static const int nvertices = 6;
    
    vec3 position(x,y,z);
    
    for ( int i = 0; i < 6; ++i ) {
        if ( blocks[i].material != vide ) {
            continue;
        }
        
		int n = m_vertices.get_n();
        
        int dec1 = 3 * n;
        int dec2 = 3 * nvertices * i;
        
        m_vertices.add(nvertices, &cube_vertices6[dec2]);
        scale(vec3(w, w, 1), nvertices, &m_vertices[dec1]);
        translate(position, nvertices, &m_vertices[dec1]);
        
        computeNormals(nvertices);

        GLfloat* color1 = color::get(bl.material, 0, z);
        for ( int j = 0; j < nvertices; ++j) {
            if ( prop_with_noise ) {
                block bl2 = map->get_block(x + cube_vertices6[dec2 + 0] * w,
                                           y + cube_vertices6[dec2 + 1] * w,
                                           z + cube_vertices6[dec2 + 2]);
                
                translate(noise3(vec3(bl2.noise)), 1, &m_vertices[dec1]);
                
                color1 = color::get(bl.material, bl2.noise, z);
            }
            
            m_colors.add(1, color1);
            
            dec1 += 3;
            dec2 += 3;
        }
    }
    
    m_needRefresh = true;
}

void Voxel::add_block2(Map* map, int x, int y, int z, int w, block bl, block* blocks) {
	static const int nvertices = 4;
	static const int nindices = 6;
    
    vec3 position(x,y,z);
    
    for ( int i = 0; i < 6; ++i ) {
        if ( blocks[i].material != vide ) {
            continue;
        }
        
		int n = m_vertices.get_n();
        
        int dec1 = 3 * n;
        int dec2 = 3 * nvertices * i;
        
        m_vertices.add(nvertices, &cube_vertices4[dec2]);
        scale(vec3(w, w, 1), nvertices, &m_vertices[dec1]);
        translate(position, nvertices, &m_vertices[dec1]);
        
		int m = m_indices.get_n();
        
        m_indices.add(nindices, cube_indices4);
        translate(n, nindices, &m_indices[m]);
        
        computeNormals(nvertices);

        GLfloat* color1 = color::get(bl.material, 0, z);
        for ( int j = 0; j < nvertices; ++j) {
            if ( prop_with_noise ) {
                block bl2 = map->get_block(x + cube_vertices4[dec2 + 0] * w,
                                           y + cube_vertices4[dec2 + 1] * w,
                                           z + cube_vertices4[dec2 + 2]);
                
                translate(noise3(vec3(bl2.noise)), 1, &m_vertices[dec1]);
                
                color1 = color::get(bl.material, bl2.noise, z);
            }
            
            m_colors.add(1, color1);
            
            dec1 += 3;
            dec2 += 3;
        }
    }
    
    m_needRefresh = true;
}

bool Voxel::need_refresh() {
    return m_needRefresh;
}

bool Voxel::need_refresh_level() {
    return m_detail_level_current != m_detail_level_next ? true : false;
}

void Voxel::refresh(Map* map) {
    if ( need_refresh() || need_refresh_level() ) {
        m_detail_level_current = m_detail_level_next;
        
        if ( prop_voxel_mode ) {
            upload(map, m_position.x, m_position.y, m_position.z);
        } else {
            upload(map, m_position.x, m_position.y);
        }
        
        initVBO();
        initVAO();
        
        m_needRefresh = false;
    }
}

bool Voxel::is_visible(const vec3& position, const vec3& direction) {
    vec3 dir = normalize(direction);
    
    if (is_visible(m_position + vec3(         0,          0,            0), position, dir) ||
        is_visible(m_position + vec3(VOXEL_SIZE,          0,            0), position, dir) ||
        is_visible(m_position + vec3(VOXEL_SIZE, VOXEL_SIZE,            0), position, dir) ||
        is_visible(m_position + vec3(         0, VOXEL_SIZE,            0), position, dir) ||
        is_visible(m_position + vec3(         0,          0, CHUNK_HEIGHT), position, dir) ||
        is_visible(m_position + vec3(VOXEL_SIZE,          0, CHUNK_HEIGHT), position, dir) ||
        is_visible(m_position + vec3(VOXEL_SIZE, VOXEL_SIZE, CHUNK_HEIGHT), position, dir) ||
        is_visible(m_position + vec3(         0, VOXEL_SIZE, CHUNK_HEIGHT), position, dir) ) {
        return true;
    }
    
    return false;
}

bool Voxel::is_visible(vec3 point, vec3 position, vec3 dir) {
    static float view_angle = pi * 1.0 / 2.;
    
    vec3 pos = normalize(point - position);
    
    float angle = acos(dot(pos, dir));
    
    if ( angle >= -view_angle && angle <= +view_angle ) {
        return true;
    }
    
    return false;
}

void Voxel::draw(OpenGLEngine* engine) {
    if ( m_needRefresh ) {
        return;
    }
        
    bool check_distance = false;
    
    int distance = glm::length(vec2(m_position - engine->m_player.m_position) + vec2(VOXEL_SIZE / 2, VOXEL_SIZE / 2));
    if ( check_distance == false || distance <= 10 * VOXEL_SIZE ) {
        draw_proc(engine, m_shader, m_texture, m_drawMode, m_polygonMode);
    }
    
    if ( check_distance || distance <= 2 * VOXEL_SIZE ) {
        draw_proc(engine, shader::get("default3d"), NULL, GL_LINES, GL_LINE);
    }
}
