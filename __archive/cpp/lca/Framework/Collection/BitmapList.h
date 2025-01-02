#pragma once

ImplementClass(BitmapList) : public Collection {
public:	
	BitmapList();
	virtual ~BitmapList();
	
public:
	BitmapRef loadRes(const char* id, int w=0, int h=0);
	void loadMultipleRes(const char* id, int nx, int ny, int w=0, int h=0);
	
public:
	virtual BitmapRef makeBitmap(GdiRef gdi, const char* id, int w, int h);
	virtual bool draw(GdiRef gdi, const char* id, int x, int y, int w, int h);
	
};

extern BitmapList g_resources;
