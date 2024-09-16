#pragma once

#include "Matrix.h"

ImplementClass(Element) : public Object {
private:
	double m_val;
	double m_p;
	
public:
	Element();
	Element(Element& e);
	Element(double val, double p=1.);
	
public:
	void setVal(double val, double p=1.);
	
	double getVal();
	double getP();
	
	double getVP();
	
public:
	void operator += (Element& e);
	void operator -= (Element& e);
	
	void operator = (Element& e);
	
	void operator *= (double val);
	void operator /= (double val);
	
};

ImplementClass(Ensemble) : public Collection {
public:
	Ensemble();
	Ensemble(Ensemble* E);

public:
	virtual ElementRef get(int i);

public:
	double getN();

};

void RegressionPolynomiale(Matrix& matrix, GraphSerieRef serie, int ordre);

Ensemble ensemble(int n, ...);

Element moyenne(Ensemble& E);
Element median (Ensemble& E);
Element mode   (Ensemble& E);
