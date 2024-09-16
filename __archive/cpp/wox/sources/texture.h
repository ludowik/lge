#pragma once

#include "headers.h"

class Texture {
public:
    Texture();
    Texture(string imageFile);
    virtual ~Texture();
    
public:
    bool load();
    bool load(string imageFile);
    
    bool is(string imageFile);
    
    bool use();
    bool unuse();
    
public:
    GLuint m_id;
    string m_imageFile;
    
    int w;
    int h;
    
    SDL_Surface *inverserPixels(SDL_Surface *imageSource) const;
    
};

namespace texture {
    typedef std::list<Texture*> Textures;
    
    void init();
    void release();
    
    Texture* add(Texture* s);
    Texture* get(string imageFile);
};
