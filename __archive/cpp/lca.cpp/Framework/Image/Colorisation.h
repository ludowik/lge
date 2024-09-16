#pragma once

ImplementClass(Colorisation) : public TraitementImage {
protected:
	int m_clr;
	
public:
	Colorisation(GdiRef source, int clr=0);
	virtual ~Colorisation();
	
public:
	virtual void getParam();

	virtual Color traitementPixel(int x, int y);
	
};
