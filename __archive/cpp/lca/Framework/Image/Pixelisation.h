#pragma once

ImplementClass(Pixelisation) : public TraitementImage {
protected:
	int m_np;
	
public:
	Pixelisation(GdiRef source, int np=2);
	virtual ~Pixelisation();

public:
	virtual void getParam();

	virtual Color traitementPixel(int x, int y);
	
};
