#include "headers.h"
#include "model.h"
#include "game_engine.h"

GLfloat c_red[] = {red};
GLfloat c_black[] = {black};
GLfloat c_blue[] = {blue};

void exitOnGLError(string str_error) {
	GLenum error = glGetError();
	if ( error != GL_NO_ERROR ) {
        cout << str_error << "(" << error << ")" << endl;
        exit(error);
    }
}

int Buffer::m_count = 0;

Buffer::Buffer(GLuint type) :
m_type(type),
m_id(0) {
}

Buffer::~Buffer() {
    release();
}

bool Buffer::generate() {
    release();
	glGenBuffers(1, &m_id);
	exitOnGLError("glGenBuffers");
	m_count++;
    return true;
}

void Buffer::release() {
    if ( m_id && glIsBuffer(m_id) == GL_TRUE ) {
        glDeleteBuffers(1, &m_id);
		m_count--;
    }
}

bool Buffer::bind() {
    glBindBuffer(m_type, m_id);
    return true;
}

bool Buffer::unbind() {
    glBindBuffer(m_type, 0);
    return true;
}

GLuint Buffer::id() {
    return m_id;
}

GLuint Buffer::type() {
    return m_type;
}

VertexArray::VertexArray() {
}

VertexArray::~VertexArray() {
    release();
}

bool VertexArray::generate() {
    release();
    glGenVertexArrays(1, &m_id);
    return true;
}

void VertexArray::release() {
    if ( m_id && glIsVertexArray(m_id) == GL_TRUE ) {
        glDeleteVertexArrays(1, &m_id);
    }
}

bool VertexArray::bind() {
    glBindVertexArray(m_id);
    return true;
}

bool VertexArray::unbind() {
    glBindVertexArray(0);
    return true;
}

BindBuffer::BindBuffer(Buffer *buffer) {
    m_buffer = buffer;
    m_buffer->bind();
}

BindBuffer::~BindBuffer() {
    m_buffer->unbind();
}

GLfloat add_car(Model* str, GLfloat x, GLfloat y, GLfloat w, GLfloat h, const unsigned char car) {
    GLfloat rectangle_vertices[] = {
        x,y,0, x,y-h,0, x+w,y,0, x+w,y,0, x,y-h,0, x+w,y-h,0
    };
    
    str->m_vertices.add(6, rectangle_vertices);
    
    GLfloat pw = 1./16. , ph = pw;
    
    GLfloat margin = pw / 4.;
    
    GLfloat px = ( car % 16 ) * pw + margin;
    GLfloat py = ( 15 - car / 16 ) * ph;
    
    str->addTextures(px, py, pw - margin * 2, ph);
    
    return w;
}

void draw(OpenGLEngine* engine, string str, GLfloat x_, GLfloat y_) {
    Model m;
    m.m_shader = shader::get("texture2D");
    m.m_texture = texture::get("textures/font.tga");
    
	GLfloat w = minmax((float)g_engine->m_w / 50., 5, 15);
    GLfloat h = w * 3 / 2;
    
    GLfloat x = x_;
    GLfloat y = y_;
    
    const char *txt = str.c_str();
    for ( int i = 0; txt[i] != 0; ++i ) {
        if ( txt[i] == '\n' ) {
            x = x_;
            y -= h;
        } else {
            x += add_car(&m, x, y, w, h, txt[i]);
        }
    }
    
    m.transform_for_screen();
    
    m.init(engine);
    m.draw(engine);
}
