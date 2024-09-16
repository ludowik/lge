#include "headers.h"
#include "texture.h"

texture::Textures textures;

void texture::init() {
    add(new Texture())->load("textures/caisse.jpg");
    add(new Texture())->load("textures/caisse2.jpg");
    add(new Texture())->load("textures/herbe.jpg");
}

void texture::release() {
    for ( auto t : textures) {
        delete (Texture*)t;
    }
    textures.clear();
}

Texture* texture::add(Texture* s) {
    textures.push_back(s);
    return s;
}

Texture* texture::get(string imageFile) {
    for ( auto t : textures) {
        if ( t->is(imageFile) ) {
            return t;
        }
    }
    
    Texture* tx = new Texture();
    tx->load(imageFile);
    
    return add(tx);
}

Texture::Texture() {
    m_id = 0;
    m_imageFile.clear();
    
    w = 0;
    h = 0;
}

Texture::Texture(string imageFile) : Texture() {
    load(imageFile);
}

Texture::~Texture() {
    glDeleteTextures(1, &m_id);
}

bool Texture::load() {
    SDL_Surface *image = IMG_Load(m_imageFile.c_str());
    
    if ( image == NULL ) {
        cout << "Erreur de chargement de l'image " << m_imageFile << " : " << SDL_GetError() << endl;
        return false;
    }
    
    w = image->w;
    h = image->h;
    
    if ( glIsTexture(m_id) ) {
        glDeleteTextures(1, &m_id);
    }
    
    glGenTextures(1, &m_id);
    use(); {
        GLenum formatAlpha = 0;
        GLenum formatRGB = 0;
        
        if ( image->format->BytesPerPixel == 3 ) {
            formatAlpha = GL_RGB;
            if ( image->format->Rmask == 0xff ) {
                formatRGB = GL_RGB;
            } else {
                formatRGB = GL_BGR;
            }
        } else if ( image->format->BytesPerPixel == 4 ) {
            formatAlpha = GL_RGBA;
            if ( image->format->Rmask == 0xff ) {
                formatRGB = GL_RGBA;
            } else {
                formatRGB = GL_BGRA;
            }
        } else {
            std::cout << "Erreur, format de l'image inconnu" << std::endl;
            SDL_FreeSurface(image);
            image = NULL;
            return false;
        }
        
        SDL_Surface *image2 = inverserPixels(image); {
            glTexImage2D(GL_TEXTURE_2D, 0, formatAlpha, image2->w, image2->h, 0, formatRGB, GL_UNSIGNED_BYTE, image2->pixels);
        }
        SDL_FreeSurface(image2);
        SDL_FreeSurface(image);
        
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    }
    unuse();

    return true;
}

SDL_Surface* Texture::inverserPixels(SDL_Surface *imageSource) const {
    // Copie conforme de l'image source sans les pixels
    SDL_Surface *imageInversee = SDL_CreateRGBSurface(0,
                                                      imageSource->w,
                                                      imageSource->h,
                                                      imageSource->format->BitsPerPixel,
                                                      imageSource->format->Rmask,
                                                      imageSource->format->Gmask,
                                                      imageSource->format->Bmask,
                                                      imageSource->format->Amask);
    
    // Tableau intermédiaires permettant de manipuler les pixels
    unsigned char* pixelsSources  = (unsigned char*) imageSource->pixels;
    unsigned char* pixelsInverses = (unsigned char*) imageInversee->pixels;
    
    // Inversion des pixels
    for ( int i = 0; i < imageSource->h; i++ ) {
        for ( int j = 0; j < imageSource->w * imageSource->format->BytesPerPixel; j++ ) {
            pixelsInverses[(imageSource->w * imageSource->format->BytesPerPixel * (imageSource->h - 1 - i)) + j] =
                pixelsSources[(imageSource->w * imageSource->format->BytesPerPixel * i) + j];
        }
    }
    
    // Retour de l'image inversée
    return imageInversee;
}

bool Texture::load(string imageFile) {
    m_imageFile = imageFile;
    return load();
}

bool Texture::is(string imageFile) {
    return m_imageFile == imageFile;
}

bool Texture::use() {
    glBindTexture(GL_TEXTURE_2D, m_id);
    return true;
}

bool Texture::unuse() {
    glBindTexture(GL_TEXTURE_2D, 0);
    return true;
}

