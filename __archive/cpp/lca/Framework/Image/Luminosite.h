#pragma once

ImplementClass(Luminosite) : public TraitementImage {
protected:
	double m_lum;
	
public:
	Luminosite(GdiRef source, double lum=.5);
	virtual ~Luminosite();

public:
	virtual void getParam();

	virtual Color traitementPixel(int x, int y);
	
};
