#pragma once

ImplementClass(Squelettisation) : public TraitementImage {
protected:
	int wf;
	int hf;
	
	Color run(GdiRef source, int x, int y, int wf, int hf, int matrice[3][3]);
	
public:
	Squelettisation(GdiRef source);  
	virtual ~Squelettisation();  

public:
	virtual void preTraitement();

	virtual Color traitementPixel(int x, int y);
	
};
