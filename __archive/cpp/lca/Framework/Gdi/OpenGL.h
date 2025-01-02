#pragma once

#if (_WINDOWS)

	#include <windows.h>

	namespace OpenGL {
		#include <gl/gl.h>
		#include <gl/glu.h>
		//#include <gl/glut.h>
		//#include <gl/glaux.h>
	};

#elif (_MAC)

	namespace OpenGL {
		#import <OpenGLES/ES1/gl.h>
		#import <OpenGLES/ES1/glext.h>
	};

	#define glOrtho     glOrthof
	#define glFrustum   glFrustumf
	#define glPointSize glPointSizex

#endif

typedef OpenGL::GLfloat GLfloat;
typedef OpenGL::GLint GLint;
typedef OpenGL::GLuint GLuint;
typedef OpenGL::GLubyte GLubyte;
typedef OpenGL::GLenum GLenum;

int adjustSize(int wh);

void glBegin(GLenum type);
void glColor(Color color);
void glVertex(GLfloat x, GLfloat y, GLfloat z=0);
void glPush();
void glEnd();

inline void glLineWidth(GLfloat x) {	
	OpenGL::glLineWidth(x);
	OpenGL::glPointSize(x);
}
