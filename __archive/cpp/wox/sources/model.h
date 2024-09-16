#pragma once

#include "headers.h"
#include "shader.h"
#include "texture.h"

class OpenGLEngine;

class Shader;
class Texture;

template <class T, int N> class Array {
public:    
	Array() {
		ptr = NULL;
		nbr_elem = 0;
		max_elem = 0;
		size_vec = N * sizeof(T);
	}

	virtual ~Array() {
		release();
	}

	inline operator bool () {
		return nbr_elem == 0 ? false : true;
	};
    
	inline operator T* () {
		return ptr;
	};
    
	inline operator GLvoid* () {
		return ptr;
	};

	inline void set_n(int n_) {
		nbr_elem = n_;
		alloc();
	}

	inline void add_n(int n_) {
		nbr_elem += n_;
		alloc();
	}

	inline int get_n() {
		return nbr_elem;
	}

	inline int get_size() {
		return nbr_elem * size_vec;
	}
    
	inline int get_size_vec() {
		return size_vec;
	}

    inline void add(int n, T* data, bool init=false) {
        int i = init ? 0 : nbr_elem;
        if ( init )
            set_n(n);
        else
            add_n(n);

        memcpy(&ptr[N * i], data, n * size_vec);
    }

    inline void repeat(int n, T* data, bool init=false) {
        int i = init ? 0 : nbr_elem;
        if ( init )
            set_n(n);
        else
            add_n(n);
        
        for ( ; i < nbr_elem; ++i ) {
            memcpy(&ptr[N * i], data, size_vec);
        }
    }
    
    inline string as_text() {
        string text = "";
        for ( int i = 0; i < nbr_elem; ++i ) {
            if ( i % 6 == 0 ) {
                cout << "face" << endl;
            }
            for ( int n = 0; n < N; ++n ) {
                text += ::as_string(ptr[N * i + n]);
                cout << ptr[N * i + n] << " - ";
            }
            cout << endl;
        }
        return text;
    }

private:
	void alloc() {
		static int size_realloc = 1024;

		if ( nbr_elem > max_elem ) {
			max_elem = size_realloc * ( 1 + ( nbr_elem / size_realloc ) ) ;
			if ( ptr ) {
				ptr = (T*)::mem_realloc(max_elem * size_vec, ptr);
			} else {
				ptr = (T*)::mem_alloc(max_elem * size_vec);
			}
		}
	};

	void release() {
		if ( ptr ) {
			::mem_free(ptr);
		}
		ptr = NULL;
		nbr_elem = 0;
		max_elem = 0;
	}

	T* ptr;

	int nbr_elem;
	int max_elem;

	int size_vec;

};

class Model {
public:
    Model();
    virtual ~Model();

public:
    //    void setVertices(int nvertices, GLfloat *vertices);
    //    void addVertices(int nvertices, GLfloat *vertices);
    
    //    void setColor(GLfloat r, GLfloat g, GLfloat b, GLfloat a);
    //    void addColor(int nvertices, GLfloat r, GLfloat g, GLfloat b, GLfloat a);

    //    void setColors(GLfloat *colors);
    //    void addColors(int nvertices, GLfloat *colors);

    void setRepeatTextures(int n);
    
    void setTextures(GLfloat x, GLfloat y, GLfloat w, GLfloat h);
    void addTextures(GLfloat x, GLfloat y, GLfloat w, GLfloat h);
    
    void setTextures();
    void setTextures(int nvertices);
    void setTextures(int nvertices, GLfloat *textures);
    void addTextures(int nvertices, GLfloat *textures);
    
public:
    void computeNormals();
    void computeNormals(int vertices);

public:
    void createRect(vec3 o, GLfloat w, GLfloat h);
    
    void createCube(vec3 o, GLfloat w);
    void createParallelepipede(vec3 o, GLfloat w, GLfloat l, GLfloat h);
    
    void createSurface1(vec3 o, GLfloat w, GLfloat h, int n_iter);
    void createSurface2(vec3 o, GLfloat w, GLfloat h, int n_iter);
    
public:
    void center();
    
    void translate(vec3 v);
    void scale(vec3 v);
    
    void translate(vec3 v, int nvertices, GLfloat* vertices);
    void scale(vec3 v, int nvertices, GLfloat* vertices);
    
    void translate(int n, int nindices, GLushort* indices);
    
    void transform_for_screen();
    
public:
    virtual void init(OpenGLEngine* engine);
    
    void initVBO();
    void initVAO();
    
    void release();
    
public:
    virtual void update(int time);

    virtual bool is_visible(const vec3& position, const vec3& direction);

    virtual void draw(OpenGLEngine* engine);
    virtual void draw_proc(OpenGLEngine* engine, Shader* shader, Texture* texture, int drawMode, int polygonMode);

public:
	Array<GLushort, 1> m_indices;
    
	Array<GLfloat, 3> m_vertices;
    Array<GLfloat, 3> m_normals;
    Array<GLfloat, 4> m_colors;
    Array<GLfloat, 2> m_textures;
    
    GLenum m_drawMode;
    GLenum m_polygonMode;
    
    int m_lineWidth;

    Shader* m_shader;
    
    Texture* m_texture;
    
    Buffer m_vbo;
    Buffer m_ibo;
    VertexArray m_vao;
    
    vec3 m_position;
    
    vec3 m_alignment;
    
    vec3 m_scale;
    
    vec3 m_angle;
    vec3 m_vangle;

    bool m_needRefresh;
    bool m_drawBorder;

};

class Models : public std::list<Model*> {
public:
    void init(OpenGLEngine* engine);
    void release();
    
public:
    void update(int time);
    
    void draw(OpenGLEngine* engine);
    
};
