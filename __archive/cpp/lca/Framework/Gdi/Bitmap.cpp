#include "System.h"
#include "Bitmap.h"
#include "OpenGL.h"

Bitmap::Bitmap(const char* id, int w, int h) {
	m_texture = 0;

	m_idBitmap = "";
	m_idRes = "";

	loadRes(id, w, h);
}

Bitmap::~Bitmap() {
	if ( m_texture ) {
		OpenGL::glDeleteTextures(1, &m_texture);
	}
}

void Bitmap::loadRes(const char* id, int w, int h) {
	m_idBitmap = id ? id : "";
	if ( id ) {
		GdiWindows::loadRes(id, w, h);
		if ( isValid() ) {
			m_idRes = m_idBitmap;
		}
	}
}
