#pragma once

#include "headers.h"

class Shader {
public:
    Shader();
    Shader(std::string vertexSource, std::string fragmentSource);
    virtual ~Shader();
    
public:
    GLuint getProgramID() const;
    
    bool setDefault  ();
    bool setDefault3D();
    bool setColor2D  ();
    bool setColor3D  ();
    bool setTexture2D();
    bool setTexture  ();
    
    bool is(std::string name);
    bool is(std::string vertexSource, std::string fragmentSource);
    
    bool set(std::string vertexSource, std::string fragmentSource);
    
    bool load(OpenGLEngine* engine);
    
    void use(OpenGLEngine* engine);
    void unuse(OpenGLEngine* engine);
    
private:
    bool buildShader(GLuint& shader, GLenum type, std::string const& filePath);
    
private:
    std::string m_name;
    
    std::string m_vertexSource;
    std::string m_fragmentSource;
    
    GLuint m_vertextID;
    GLuint m_fragmentID;
    
    GLuint m_programID;
    
    GLint m_ulViewProjection;
    
    GLint m_light_direction;
    GLint m_light_ambient_color;
    
    GLint m_light_ambient_intensity;
    
};

namespace shader {
    typedef std::list<Shader*> Shaders;
    
    void init();
    void release();
    
    Shader* add(Shader* s);
    Shader* get(std::string name);
    Shader* get(std::string vertexSource, std::string fragmentSource);
};
