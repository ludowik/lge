#include "System.h"
#include "OpenGL.h"

#include "Gdi.OpenGL.h"

const int g_nv = 1024 * 3;
const int g_nc = 1024 * 4;

typedef struct {
    GLfloat x;
    GLfloat y;
    GLfloat z;
}
Vertex3D;

static GLfloat g_vertex[g_nv];
static GLfloat g_colors[g_nc];

static GLenum g_type = 0;

static int g_iv = 0;
static int g_ic = 0;

static GLfloat g_rIntensity = 0;
static GLfloat g_gIntensity = 0;
static GLfloat g_bIntensity = 0;
static GLfloat g_aIntensity = 0;

int adjustSize(int wh) {
	wh = min(wh, 256);
	
	int i = 4; // optimisation
	while ( i < wh ) {
		i = i * 2;
	}
	return i;
}

void glBegin(GLenum type) {
	g_type = type;
	
	g_iv = 0;
	g_ic = 0;
	
	g_rIntensity = 1; // rIntensity(white);
	g_gIntensity = 1; // gIntensity(white);
	g_bIntensity = 1; // bIntensity(white);
	g_aIntensity = 1; // aIntensity(white);

	glLineWidth(1);
}

void glColor(Color color) {
	g_rIntensity = rIntensity(color);
	g_gIntensity = gIntensity(color);
	g_bIntensity = bIntensity(color);
	g_aIntensity = aIntensity(color);
}

void glVertex(GLfloat x, GLfloat y, GLfloat z) {
	if ( g_iv + 3 > g_nv ) {
		glPush();
	}
	
	g_vertex[g_iv++] =  x;
	g_vertex[g_iv++] =  y;
	g_vertex[g_iv++] = -2;
	
	g_colors[g_ic++] = g_rIntensity;
	g_colors[g_ic++] = g_gIntensity;
	g_colors[g_ic++] = g_bIntensity;
	g_colors[g_ic++] = g_aIntensity;
}

void glPush() {
	glEnd();
	
	g_iv = 0;
	g_ic = 0;
}

void glEnd() {
	int n = g_iv/3;
		
	OpenGL::glVertexPointer(3, GL_FLOAT, 0, g_vertex);
	OpenGL::glEnableClientState(GL_VERTEX_ARRAY);
	
	OpenGL::glColorPointer(4, GL_FLOAT, 0, g_colors);
	OpenGL::glEnableClientState(GL_COLOR_ARRAY);
	
	OpenGL::glEnable(GL_POINT_SMOOTH);
	
	OpenGL::glDrawArrays(g_type, 0, n);

	OpenGL::glDisableClientState(GL_COLOR_ARRAY);
	OpenGL::glDisableClientState(GL_VERTEX_ARRAY);
}
