#include "headers.h"
#include "ortho.h"
#include "game_engine.h"

// Vertices et coordonnées
vec3 ortho_vertices[] = {
    origin, axe_x,
    origin, axe_y,
    origin, axe_z,
};

GLfloat ortho_colors[] = {
    red, red,
    green, green,
    blue, blue
};

Ortho::Ortho() {
    int nvertices = sizeof(ortho_vertices) / sizeof(float) / 3;
    
    m_vertices.add(nvertices, (GLfloat*)ortho_vertices, true);
    m_colors.add(nvertices, ortho_colors, true);
    
    m_drawMode = GL_LINES;
    m_polygonMode = GL_LINE;
    
    m_lineWidth = 5;
    
    m_shader = shader::get("color3d");
}

Ortho::~Ortho() {
}
