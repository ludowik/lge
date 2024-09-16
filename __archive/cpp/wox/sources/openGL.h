#pragma once

#define rgba(r,g,b,a) ((GLfloat)r/255.0f), ((GLfloat)g/255.0f), ((GLfloat)b/255.0f), ((GLfloat)a/255.0f)

#define white      rgba(255,255,255, 255)
#define black      rgba(  0,  0,  0, 255)
#define red        rgba(255,128,128, 255)
#define green      rgba(  0,255,  0, 255)
#define blue       rgba(  0,  0,255, 255)
#define yellow     rgba(255,255,  0, 255)
#define orange     rgba(255,204,  0, 255)
#define light_blue rgba(128,128,255, 255)
#define beige      rgba(200,173,127, 255)

extern GLfloat c_red[];
extern GLfloat c_black[];
extern GLfloat c_blue[];

#define origin vec3(0)

#define axe_x vec3(1,0,0)
#define axe_y vec3(0,1,0)
#define axe_z vec3(0,0,1)

void exitOnGLError(std::string error);

class Buffer {
public:
    Buffer(GLuint type = GL_ARRAY_BUFFER);
    virtual ~Buffer();
    
public:
    virtual bool generate();
    virtual void release();

    virtual bool bind();
    virtual bool unbind();
    
    GLuint id();
	GLuint type();
    
protected:
    GLuint m_id;
    GLuint m_type;

protected:
	static int m_count;
    
};

class VertexArray : public Buffer {
public:
    VertexArray();
    virtual ~VertexArray();
    
    virtual bool generate();
    virtual void release();

    virtual bool bind();
    virtual bool unbind();
    
};

class BindBuffer {
public:
    BindBuffer(Buffer *buffer);
    virtual ~BindBuffer();
    
private:
    Buffer *m_buffer;

};

void draw(class OpenGLEngine* engine, string str, GLfloat x, GLfloat y);
