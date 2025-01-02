#pragma once

ImplementClass(Blur) : public TraitementImage {
protected:
	int wf;
	int hf;
	
	int total;
	
	int Total(int wf, int hf, int matrice[3][3]);
	Color Convolution(GdiRef source, int x, int y, int wf, int hf, int matrice[3][3], int total);
	
public:
	Blur(GdiRef source);
	virtual ~Blur();

public:
	virtual Color traitementPixel(int x, int y);
	
};
