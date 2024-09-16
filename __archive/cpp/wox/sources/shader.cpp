#include "headers.h"
#include "shader.h"
#include "game_engine.h"

shader::Shaders shaders;

void shader::init() {
    add(new Shader())->setDefault  ();
    add(new Shader())->setDefault3D();
    add(new Shader())->setColor2D  ();
    add(new Shader())->setColor3D  ();
    add(new Shader())->setTexture2D();
    add(new Shader())->setTexture  ();
}

void shader::release() {
    for ( auto shader : shaders) {
        delete shader;
    }
    shaders.clear();
}

Shader* shader::add(Shader* s) {
    shaders.push_back(s);
    return s;
}

Shader* shader::get(std::string name) {
    for ( auto shader : shaders) {
        if ( shader->is(name) ) {
            return shader;
        }
    }
    
    assert(0);
    return NULL;
}

Shader* shader::get(std::string vertexSource, std::string fragmentSource) {
    for ( auto shader : shaders) {
        if ( shader->is(vertexSource, fragmentSource) ) {
            return shader;
        }
    }
    
    return add(new Shader(vertexSource, fragmentSource));
}

Shader::Shader() : Shader("", "") {
}

Shader::Shader(std::string vertexSource, std::string fragmentSource) :
m_name(""),
m_vertexSource(vertexSource),
m_fragmentSource(fragmentSource),
m_vertextID(0),
m_fragmentID(0),
m_programID(0),
m_ulViewProjection(0),
m_light_direction(0),
m_light_ambient_color(0),
m_light_ambient_intensity(0) {
}

Shader::~Shader() {
    glDeleteProgram(m_programID);
}

GLuint Shader::getProgramID() const {
    return m_programID;
}

bool Shader::setDefault() {
    m_name = "default2d";
    return set("Shaders/basique2D.vert", "Shaders/basique2D.frag");
}

bool Shader::setDefault3D() {
    m_name = "default3d";
    return set("Shaders/basique3D.vert", "Shaders/couleur3D.frag");
}

bool Shader::setColor2D() {
    m_name = "color2d";
    return set("Shaders/couleur2D.vert", "Shaders/couleur2D.frag");
}

bool Shader::setColor3D() {
    m_name = "color3d";
    return set("Shaders/couleur3D.vert", "Shaders/couleur3D.frag");
}

bool Shader::setTexture2D() {
    m_name = "texture2D";
    return set("Shaders/texture2D.vert", "Shaders/texture2D.frag");
}

bool Shader::setTexture() {
    m_name = "texture";
    return set("Shaders/texture.vert", "Shaders/texture.frag");
}

bool Shader::is(std::string name) {
    return m_name == name;
}

bool Shader::is(std::string vertexSource, std::string fragmentSource) {
    return is(vertexSource + "/" + fragmentSource);
}

bool Shader::set(std::string vertexSource, std::string fragmentSource) {
    if ( m_name.empty() ) {
        m_name = vertexSource + "/" + fragmentSource;
    }
    
    m_vertexSource = vertexSource;
    m_fragmentSource = fragmentSource;
    
    return true;
}

bool Shader::load(OpenGLEngine* engine) {
    // Compilation des shader
    if ( !buildShader(m_vertextID, GL_VERTEX_SHADER, m_vertexSource) ) {
        return false;
    }
    
    if ( !buildShader(m_fragmentID, GL_FRAGMENT_SHADER, m_fragmentSource) ) {
        return false;
    }
    
    // Création du programme
    if ( glIsProgram(m_programID) == GL_TRUE ) {
        glDeleteProgram(m_programID);
    }
    
    m_programID = glCreateProgram();
    
    if ( m_programID == 0 ) {
        std::cout << "Création du programme impossible" << std::endl;
        return false;
    }
    
    // Association des shader au programme
    glAttachShader(m_programID, m_vertextID);
    glAttachShader(m_programID, m_fragmentID);
    
    // Verrouillage des entrées shader
    glBindAttribLocation(m_programID, 0, "in_Vertex");
    glBindAttribLocation(m_programID, 1, "in_Normal");
    glBindAttribLocation(m_programID, 2, "in_Color");
    glBindAttribLocation(m_programID, 3, "in_TexCoord0");
    
    // Linkage du programme
    glLinkProgram(m_programID);

    // Contrôle du linkage
    GLint error(0);
    glGetProgramiv(m_programID, GL_LINK_STATUS, &error);
    
    if ( error != GL_TRUE ) {
        // Récupération de la taille du libellé de l'erreur
        GLint sizeError(0);
        glGetProgramiv(m_programID, GL_INFO_LOG_LENGTH, &sizeError);
        
        // Allocation
        char* textError = new char[sizeError + 1];
        
        // Récupération du libelle de l'erreur
        glGetProgramInfoLog(m_programID, sizeError, &sizeError, textError);
        textError[sizeError] = '\0';
        
        // Lod de l'erreur
        std::cout << textError << std::endl;
        
        // Libération
        delete []textError;
        glDeleteProgram(m_programID);
        
        return false;
    }
    
    m_ulViewProjection = glGetUniformLocation(getProgramID(), "modelviewProjection");
    
    m_light_direction = glGetUniformLocation(getProgramID(), "light_direction");
    m_light_ambient_color = glGetUniformLocation(getProgramID(), "light_ambient_color");
    
    m_light_ambient_intensity = glGetUniformLocation(getProgramID(), "light_ambient_intensity");
    
    return true;
}

bool Shader::buildShader(GLuint &shader, GLenum type, std::string const &filePath) {
    // Création du shader
    if ( glIsShader(shader) == GL_TRUE ) {
        glDeleteShader(shader);
	}
    shader = glCreateShader(type);
    if ( shader == 0 ) {
        std::cout << "Erreur, le type de shader (" << type << ") n'existe pas" << std::endl;
        return false;
    }
    
    // Flux de lecture
    std::ifstream file(filePath.c_str());
    
    // Test d'ouverture
    if ( !file ) {
        std::cout << "Erreur le fichier " << filePath << " est introuvable" << std::endl;
        glDeleteShader(shader);
        
        return false;
    }
    
    // Strings permettant de lire le code source
    std::string line;
    std::string codeSource;
    
    // Lecture
    while ( getline(file, line) ) {
        codeSource += line + '\n';
    }
    
    file.close();
    
    // Envoi du code source au shader
    const GLchar* p_source = codeSource.c_str();
    glShaderSource(shader, 1, &p_source, 0);
    
    // Compilation du shader
    glCompileShader(shader);
    
    // Contrôle de la compilation
    GLint error(0);
    glGetShaderiv(shader, GL_COMPILE_STATUS, &error);
    
    if ( error != GL_TRUE ) {
        // Récupération de la taille du libellé de l'erreur
        GLint sizeError(0);
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &sizeError);
        
        // Allocation
        char* textError = new char[sizeError + 1];
        
        // Récupération du libelle de l'erreur
        glGetShaderInfoLog(shader, sizeError, &sizeError, textError);
        textError[sizeError] = '\0';
        
        // Lod de l'erreur
        std::cout << textError << std::endl;
        
        // Libération
        delete []textError;
        glDeleteShader(shader);

        return false;
    }
    
    return true;
}

void Shader::use(OpenGLEngine* engine) {
    glUseProgram(m_programID);

    mat4 vp = engine->m_projection * engine->m_modelView;
    glUniformMatrix4fv(this->m_ulViewProjection, 1, GL_FALSE, glm::value_ptr(vp));
    
    vec3 light_direction = -normalize(vec3(1.0, 3.0, -1.0));
    vec3 light_ambient_color = vec3(0.55);
    
    GLfloat light_ambient_intensity = 0.0;
    if ( prop_with_light ) {
        light_ambient_intensity = 0.85;
    }

    glUniform3fv(m_light_direction, 1, glm::value_ptr(light_direction));
    glUniform3fv(m_light_ambient_color, 1, glm::value_ptr(light_ambient_color));
    
    glUniform1fv(m_light_ambient_intensity, 1, &light_ambient_intensity);
}

void Shader::unuse(OpenGLEngine* engine) {
    glUseProgram(0);
}
