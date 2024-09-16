#include "headers.h"
#include "model.h"
#include "opengl_engine.h"
#include "game_engine.h"
#include "game_input.h"

Model::Model() :
m_position(0),
m_alignment(0),
m_scale(1),
m_angle(0),
m_vangle(0),
m_lineWidth(1),
m_drawMode(GL_TRIANGLES),
m_polygonMode(GL_FILL),
m_shader(NULL),
m_texture(NULL),
m_needRefresh(true),
m_drawBorder(false),
m_ibo(GL_ELEMENT_ARRAY_BUFFER) {
}

Model::~Model() {
    release();
}

vec3 center(vec3 a, vec3 b) {
    vec3 c = a + b;
    c /= 2;
    return c;
}

void divideTriangle(vec3 * vertices, int &n, vec3 a, vec3 b, vec3 c) {
    vec3 d = center(a, b);
    
    vertices[n++] = a;
    vertices[n++] = d;
    vertices[n++] = c;
    
    vertices[n++] = d;
    vertices[n++] = b;
    vertices[n++] = c;
}

void Model::createRect(vec3 o, GLfloat w, GLfloat h) {
    createSurface1(o, w, h, 1);
}

void Model::createCube(vec3 o, GLfloat w) {
    m_vertices.add(36, cube_vertices6);
    
    scale(vec3(w), 36, m_vertices);
    translate(o, 36, m_vertices);
    
    m_colors.repeat(36, c_red);
}

void Model::createParallelepipede(vec3 o, GLfloat w, GLfloat l, GLfloat h) {
    m_vertices.add(36, cube_vertices6);
    
    scale(vec3(w, l, h), 36, m_vertices);
    translate(o, 36, m_vertices);

    m_colors.repeat(36, c_black);
}

void Model::createSurface1(vec3 o, GLfloat w, GLfloat h, int nIter) {
    o.x += w < 0 ? w : 0;
    o.y += h < 0 ? h : 0;
    
    w = abs(w);
    h = abs(h);
    
    vec3 *vertices = new vec3[6];

    int n = 0;
    
    vertices[n++] = o + vec3(0, h, o.z);
    vertices[n++] = o;
    vertices[n++] = o + vec3(w, h, o.z);
    
    vertices[n++] = o + vec3(w, h, o.z);
    vertices[n++] = o;
    vertices[n++] = o + vec3(w, 0, o.z);
    
    int nvertices = n;
    
    for ( int i = 0; i < nIter; ++i ) {
        vec3 *vertices2 = new vec3[2 * nvertices];
        
        int nTriangles = nvertices / 3;
        
        n = 0;
        for ( int t = 0; t < nTriangles; ++t ) {
            vec3 a = vertices[t * 3 + 0];
            vec3 b = vertices[t * 3 + 1];
            vec3 c = vertices[t * 3 + 2];
            
            float d_ab = glm::distance(a, b);
            float d_bc = glm::distance(b, c);
            float d_ca = glm::distance(c, a);
            
            if ( d_ab > d_bc && d_ab > d_ca ) {
                divideTriangle(vertices2, n, a, b, c);
            } else if ( d_bc > d_ab && d_bc > d_ca ) {
                divideTriangle(vertices2, n, b, c, a);
            } else {
                divideTriangle(vertices2, n, c, a, b);
            }
        }
    
        delete []vertices;
        
        nvertices = n;
        vertices = vertices2;
    }
    
    m_vertices.add(nvertices, (GLfloat*)vertices);
    
    delete []vertices;
}

void divideTriangle(vec3* vertices, int &n, vec3 a, vec3 b, vec3 c, vec3 d) {
    vertices[n++] = d;
    vertices[n++] = a;
    vertices[n++] = c;
    
    vertices[n++] = c;
    vertices[n++] = a;
    vertices[n++] = b;
}

void divideQuads(vec3* vertices, int &n, vec3 a, vec3 b, vec3 c, vec3 d) {
    vec3 ab = center(a, b);
    vec3 bc = center(b, c);
    vec3 cd = center(c, d);
    vec3 da = center(d, a);
    vec3 ac = center(a, c);
    
    vertices[n++] = a;
    vertices[n++] = ab;
    vertices[n++] = ac;
    vertices[n++] = da;
    
    vertices[n++] = ab;
    vertices[n++] = b;
    vertices[n++] = bc;
    vertices[n++] = ac;

    vertices[n++] = ac;
    vertices[n++] = bc;
    vertices[n++] = c;
    vertices[n++] = cd;

    vertices[n++] = da;
    vertices[n++] = ac;
    vertices[n++] = cd;
    vertices[n++] = d;
}

void Model::createSurface2(vec3 o, GLfloat w, GLfloat h, int nIter) {
    vec3* vertices = new vec3[4];
    
    int n = 0;
    
    vertices[n++] = o;
    vertices[n++] = o + vec3(w, 0, o.z);
    vertices[n++] = o + vec3(w, h, o.z);
    vertices[n++] = o + vec3(0, h, o.z);
    
    int nvertices = n;
    
    for ( int i = 0; i < nIter; ++i ) {
        vec3* vertices2;
        if ( i == nIter-1 ) {
            vertices2 = new vec3[2 * nvertices];
        } else {
            vertices2 = new vec3[4 * nvertices];
        }
        
        int nQuads = nvertices / 4;
        
        n = 0;
        for ( int t = 0; t < nQuads; ++t ) {
            vec3 a = vertices[t * 4 + 0];
            vec3 b = vertices[t * 4 + 1];
            vec3 c = vertices[t * 4 + 2];
            vec3 d = vertices[t * 4 + 3];
            
            if ( i == nIter-1 ) {
                divideTriangle(vertices2, n, a, b, c, d);
            } else {
                divideQuads(vertices2, n, a, b, c, d);
            }
        }
        
        delete []vertices;
        
        nvertices = n;
        vertices = vertices2;
    }
    
    m_vertices.add(nvertices, (GLfloat*)vertices);
    
    delete []vertices;
}

void computeNormal(GLfloat* vertices, GLfloat* normals) {
    vec3 a = vec3(vertices[0], vertices[1], vertices[2]);
    vec3 b = vec3(vertices[3], vertices[4], vertices[5]);
    vec3 c = vec3(vertices[6], vertices[7], vertices[8]);
    
    vec3 ab = b - a;
    vec3 bc = c - b;
    vec3 ca = a - c;
    
    vec3 na = glm::normalize(glm::cross(ca, ab));
    vec3 nb = glm::normalize(glm::cross(ab, bc));
    vec3 nc = glm::normalize(glm::cross(bc, ca));
        
    int i = 0;
    normals[i++] = na.x;
    normals[i++] = na.y;
    normals[i++] = na.z;
    
    normals[i++] = nb.x;
    normals[i++] = nb.y;
    normals[i++] = nb.z;
    
    normals[i++] = nc.x;
    normals[i++] = nc.y;
    normals[i++] = nc.z;
}

void computeNormal(GLfloat* va, GLfloat* vb, GLfloat* vc, GLfloat* normals) {
    vec3 a = vec3(va[0], va[1], va[2]);
    vec3 b = vec3(vb[0], vb[1], vb[2]);
    vec3 c = vec3(vc[0], vc[1], vc[2]);

    vec3 ab = b - a;
    vec3 bc = c - b;
    
    vec3 nb = glm::normalize(glm::cross(ab, bc));
    
    normals[0] = nb.x;
    normals[1] = nb.y;
    normals[2] = nb.z;
}

void Model::computeNormals() {
    computeNormals(m_vertices.get_n());
}

void Model::computeNormals(int nvertices) {
    if ( m_indices ) {
        m_normals.add_n(nvertices);
    
        int n_quads = nvertices / 4;
    
        for ( int i = 0; i < n_quads; ++i ) {
            GLfloat* vd = &m_vertices[12 * i + 3 * ( m_vertices.get_n() - nvertices + 0 )];
            GLfloat* va = &m_vertices[12 * i + 3 * ( m_vertices.get_n() - nvertices + 1 )];
            GLfloat* vc = &m_vertices[12 * i + 3 * ( m_vertices.get_n() - nvertices + 2 )];
            GLfloat* vb = &m_vertices[12 * i + 3 * ( m_vertices.get_n() - nvertices + 3 )];
            
            GLfloat* nd = &m_normals[12 * i + 3 * ( m_normals .get_n() - nvertices + 0 )];
            GLfloat* na = &m_normals[12 * i + 3 * ( m_normals .get_n() - nvertices + 1 )];
            GLfloat* nc = &m_normals[12 * i + 3 * ( m_normals .get_n() - nvertices + 2 )];
            GLfloat* nb = &m_normals[12 * i + 3 * ( m_normals .get_n() - nvertices + 3 )];
            
            computeNormal(vc, vd, va, nd);
            computeNormal(vd, va, vc, na);
            computeNormal(va, vc, vd, nc);
            computeNormal(va, vb, vc, nb);
        }
    } else {
        m_normals.add_n(nvertices);
        
        int nTriangles = nvertices / 3;
        
        for ( int i = 0; i < nTriangles; ++i ) {
            computeNormal(&m_vertices[9 * i + 3 * ( m_vertices.get_n() - nvertices )],
                          &m_normals [9 * i + 3 * ( m_normals .get_n() - nvertices )]);
        }
    }
}

// Coordonnées standard de texture
float texture_coord[] = {
    0, 1,   0, 0,   1, 1,
    1, 1,   0, 0,   1, 0
};

float texture_coord2[12];

void Model::setRepeatTextures(int n) {
    for ( int i = 0; i < 12; ++ i) {
        texture_coord2[i] = int( (float)texture_coord[i] * n - 0.1 );
    }
    
    setTextures(m_vertices.get_n(), texture_coord2);
}

void Model::setTextures(GLfloat x, GLfloat y, GLfloat w, GLfloat h) {
    for ( int i = 0; i < 6; ++ i) {
        texture_coord2[2*i+0] = x + texture_coord[2*i+0] * w;
        texture_coord2[2*i+1] = y + texture_coord[2*i+1] * h;
    }
    
    setTextures(m_vertices.get_n(), texture_coord2);
}

void Model::addTextures(GLfloat x, GLfloat y, GLfloat w, GLfloat h) {
    for ( int i = 0; i < 6; ++ i) {
        texture_coord2[2*i+0] = x + texture_coord[2*i+0] * w;
        texture_coord2[2*i+1] = y + texture_coord[2*i+1] * h;
    }
    
    addTextures(6, texture_coord2);
}

void Model::setTextures() {
    setTextures(m_vertices.get_n(), texture_coord);
}

void Model::setTextures(int nvertices) {
    setTextures(nvertices, texture_coord);
}

void Model::setTextures(int nvertices, GLfloat* textures) {
	m_textures.set_n(0);
    addTextures(nvertices, textures);
}

void Model::addTextures(int nvertices, GLfloat* textures) {
	m_textures.add_n(nvertices);

    int nQuads = nvertices / 6;
    
    for ( int i = 0; i < nQuads; ++i ) {
        memcpy(&m_textures[2 * ( m_textures.get_n() - nvertices ) + i * 6 * 2], textures, 6 * m_textures.get_size_vec());
    }
}

void Model::translate(vec3 v) {
    translate(v, m_vertices.get_n(), m_vertices);
}

void Model::translate(vec3 v, int nvertices, GLfloat* vertices) {
    for ( int i = 0; i < nvertices; ++i ) {
        vertices[3 * i + 0] += v.x;
        vertices[3 * i + 1] += v.y;
        vertices[3 * i + 2] += v.z;
    }
}

void Model::scale(vec3 v) {
    scale(v, m_vertices.get_n(), m_vertices);
}

void Model::scale(vec3 v, int nvertices, GLfloat* vertices) {
    for ( int i = 0; i < nvertices; ++i ) {
        vertices[3 * i + 0] *= v.x;
        vertices[3 * i + 1] *= v.y;
        vertices[3 * i + 2] *= v.z;
    }
}

void Model::translate(int n, int nindices, GLushort* indices) {
    for ( int i = 0; i < nindices; ++i ) {
        indices[i] += (GLushort)n;
    }
}

void Model::transform_for_screen() {
    int w_screen = g_engine->m_w / 2.;
    int h_screen = g_engine->m_h / 2.;
    
    translate(vec3(-w_screen, +h_screen, 0));
    scale(vec3(1./w_screen, 1./h_screen, 0));
}

void Model::release() {
	m_vertices.set_n(0);
    m_indices.set_n(0);
	m_normals.set_n(0);
	m_colors.set_n(0);
	m_textures.set_n(0);
    
	m_vbo.release();
    m_ibo.release();
    m_vao.release();
}

void Model::init(OpenGLEngine* engine) {
    if ( m_shader == NULL ) {
        m_shader = shader::get("default3d");
    }
    
    if ( m_shader && m_shader->getProgramID() == 0 ) {
        m_shader->load(engine);
    }
    
    initVBO();
    initVAO();

    m_needRefresh = false;
}

void Model::initVBO() {
    GLuint m_sizeVertices = m_vertices.get_size();
    GLuint m_sizeNormals  = m_normals .get_size();
    GLuint m_sizeColors   = m_colors  .get_size();
    GLuint m_sizeTextures = m_textures.get_size();
    GLuint m_sizeIndices  = m_indices .get_size();
    
    // GL_DYNAMIC_DRAW => m_playerns performant
    
    m_vbo.generate(); {
        m_vbo.bind();
        
        glBufferData(GL_ARRAY_BUFFER, m_sizeVertices + m_sizeNormals + m_sizeColors + m_sizeTextures, 0, GL_STATIC_DRAW);
        
        int offset = 0;
        if ( m_vertices.get_n() ) {
            glBufferSubData(GL_ARRAY_BUFFER, offset, m_sizeVertices, m_vertices);
            offset += m_sizeVertices;
        }
        
        if ( m_normals.get_n() ) {
            glBufferSubData(GL_ARRAY_BUFFER, offset, m_sizeNormals, m_normals);
            offset += m_sizeNormals;
        }
        
        if ( m_colors.get_n() ) {
            glBufferSubData(GL_ARRAY_BUFFER, offset, m_sizeColors, m_colors);
            offset += m_sizeColors;
        }
        
        if ( m_textures.get_n() ) {
            glBufferSubData(GL_ARRAY_BUFFER, offset, m_sizeTextures, m_textures);
            offset += m_sizeTextures;
        }
        
        m_vbo.unbind();

        if ( m_indices.get_n() ) {
            m_ibo.generate();
            m_ibo.bind();

			if ( m_ibo.type() != GL_ELEMENT_ARRAY_BUFFER ) {
				cout << "erreur";
			}

			glBufferData(m_ibo.type(), m_sizeIndices, m_indices, GL_STATIC_DRAW);

			m_ibo.unbind();
        }
    }
}

void Model::initVAO() {
    GLuint m_sizeVertices = m_vertices.get_size();
    GLuint m_sizeNormals  = m_normals .get_size();
    GLuint m_sizeColors   = m_colors  .get_size();
//  GLuint m_sizeTextures = m_textures.get_size();
//  GLuint m_sizeIndices  = m_indices .get_size();

    m_vao.generate(); {
		m_vao.bind();
        m_vbo.bind();
        
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, BUFFER_OFFSET(0));
        glEnableVertexAttribArray(0);

        if ( m_normals.get_n() ) {
            assert(m_vertices.get_n() == m_normals.get_n());
            glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 0, BUFFER_OFFSET(m_sizeVertices));
            glEnableVertexAttribArray(1);
        }

        if ( m_colors.get_n() ) {
            assert(m_vertices.get_n() == m_colors.get_n());
            glVertexAttribPointer(2, 4, GL_FLOAT, GL_TRUE, 0, BUFFER_OFFSET(m_sizeVertices + m_sizeNormals));
            glEnableVertexAttribArray(2);
        }
        
        if ( m_textures.get_n() ) {
            assert(m_vertices.get_n() == m_textures.get_n());
            glVertexAttribPointer(3, 2, GL_FLOAT, GL_FALSE, 0, BUFFER_OFFSET(m_sizeVertices + m_sizeNormals + m_sizeColors));
            glEnableVertexAttribArray(3);
        }
        
        if ( m_indices.get_n() ) {
            m_ibo.bind();
        }
        
        m_vao.unbind();
    }
}

void Model::center() {
    vec3 gc(0,0,0);
    
    for ( int i = 0; i < m_vertices.get_n(); ++i ) {
        gc.x += m_vertices[i * 3 + 0];
        gc.y += m_vertices[i * 3 + 1];
        gc.z += m_vertices[i * 3 + 2];
    }
    
    gc /= (float)m_vertices.get_n();
    
    m_alignment = -gc;
}

bool Model::is_visible(const vec3& position, const vec3& direction) {
    return true;
}

void Model::update(int time) {
    update_angle(m_angle.x, m_vangle.x, time);
    update_angle(m_angle.y, m_vangle.y, time);
    update_angle(m_angle.z, m_vangle.z, time);
}

void Model::draw(OpenGLEngine* engine) {
    if ( m_needRefresh ) {
        return;
    }
    
    glm::mat4 modelView = engine->m_modelView;
    glm::mat4 modelView_old = engine->m_modelView;
    
    modelView = glm::translate(modelView, m_position);
    
    modelView = glm::rotate(modelView, m_angle.x, axe_x);
    modelView = glm::rotate(modelView, m_angle.y, axe_y);
    modelView = glm::rotate(modelView, m_angle.z, axe_z);
    
    modelView = glm::scale(modelView, m_scale);
    
    modelView = glm::translate(modelView, m_alignment);
    
    engine->m_modelView = modelView; {
        draw_proc(engine, m_shader, m_texture, m_drawMode, m_polygonMode);
	
        if ( m_drawBorder ) {
            glLineWidth(20);
            draw_proc(engine, shader::get("default3d"), NULL, GL_LINES, GL_LINE);
        }
    }
    engine->m_modelView = modelView_old;
}

void Model::draw_proc(OpenGLEngine* engine, Shader* shader, Texture* texture, int drawMode, int polygonMode) {
    assert(shader);
    
    if ( shader->getProgramID() == 0 ) {
        shader->load(engine);
    }
    shader->use(engine);
    
    if ( texture ) {
        texture->use();
    }
    
    {
        BindBuffer bind(&m_vao);
        
        glPolygonMode(GL_FRONT_AND_BACK, polygonMode);
        
		if ( prop_mode_indices && m_indices.get_n() > 0 ) {
			glDrawElements(drawMode, m_indices.get_n(), GL_UNSIGNED_SHORT, (void*)0);
	    } else {
            glDrawArrays(drawMode, 0, m_vertices.get_n());
        }
    }
    
    if ( texture ) {
        texture->unuse();
    }
    
    shader->unuse(engine);
}

void Models::init(OpenGLEngine* engine) {
    for ( Model* m : *this ) {
        m->init(engine);
    }
}

void Models::release() {
    for ( Model* m : *this ) {
        delete m;
    }
    clear();
}

void Models::update(int time) {
    for ( Model* m : *this ) {
        m->update(time);
    }
}

void Models::draw(OpenGLEngine* engine) {
    for ( Model* m : *this ) {
        if ( m->is_visible(engine->m_player.m_position, engine->m_player.m_direction) ) {
            m->draw(engine);
        }
    }
}
