#pragma once

ImplementClass(Binarisation) : public TraitementImage {
protected:
	int m_plage;
	
public:
	Binarisation(GdiRef source, int plage=32);
	virtual ~Binarisation();
	
public:
	virtual Color traitementPixel(int x, int y);
	
};
