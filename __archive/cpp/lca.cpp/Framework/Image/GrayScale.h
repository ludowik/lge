#pragma once

ImplementClass(GrayScale) : public TraitementImage {
public:
	GrayScale(GdiRef source);
	virtual ~GrayScale();
	
public:
	virtual Color traitementPixel(int x, int y);
	
};
