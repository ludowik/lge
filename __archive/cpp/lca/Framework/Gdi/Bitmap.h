#pragma once

ImplementClass(Bitmap) : public GdiWindows {
public:
	String m_idBitmap;
	String m_idRes;
	
	unsigned int m_texture;
	
	Rect m_textureSize;
	
public:
	Bitmap(const char* _id=0, int w=0, int h=0);
	virtual ~Bitmap();

public:
	virtual void loadRes(const char* id, int w=0, int h=0);

};
