#pragma once

ImplementClass(Dilatation) : public TraitementImage {
protected:
	int wf;
	int hf;
	
public:
	Color run(GdiRef source, int x, int y, int wf, int hf, int matrice[3][3]);
	
public:
	Dilatation(GdiRef source);
	virtual ~Dilatation();

public:
	virtual Color traitementPixel(int x, int y);
	
};
