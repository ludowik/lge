#include "System.h"
#include "Stat.h"
#include "Matrix.h"

Element::Element() {
	m_val = 0.;
	m_p = 1.;
}

Element::Element(Element& e) {
	m_val = e.m_val;
	m_p = e.m_p;
}

Element::Element(double val, double p) {
	m_val = val;
	m_p = p;
}

void Element::setVal(double val, double p) {
	m_val = val;
	m_p = p;
}

double Element::getVal() {
	return m_val;
}

double Element::getP() {
	return m_p;
}

double Element::getVP() {
	return m_val*m_p;
}

void Element::operator += (Element& e) {
	m_val = getVP()+e.getVP();
}

void Element::operator -= (Element& e) {
	m_val = getVP()-e.getVP();
}

void Element::operator = (Element& e) {
	m_val = e.getVal();
	m_p = e.getP();
}

void Element::operator *= (double val) {
	m_val *= val;
}

void Element::operator /= (double val) {
	m_val /= val;
}

Element operator + (Element& e1, Element& e2) {
	Element r(e1);
	r += e2;
	return r;
}

Element operator - (Element& e1, Element& e2) {
	Element r(e1);
	r -= e2;
	return r;
}

Element operator * (Element& e, double div) {
	Element r(e);
	r *= div;
	return r;
}

Element operator / (Element& e, double div) {
	Element r(e);
	r /= div;
	return r;
}

int CompareElement(ObjectRef o1, ObjectRef o2) {
	ElementRef e1 = (ElementRef)o1;
	ElementRef e2 = (ElementRef)o2;
	
	if ( e1->getVal() < e2->getVal() ) {
		return -1;
	}
	else if ( e1->getVal() > e2->getVal() ) {
		return 1;
	}
	
	return 0;
}

double Ensemble::getN() {
	double N = 0;
	
	Iterator iter = getIterator();
	while ( iter.hasNext() ) {
		ElementRef elt = (ElementRef)iter.next();
		N += elt->getP();
	}

	return N;
}

Ensemble::Ensemble() {
	m_collection = new List();
}

Ensemble::Ensemble(Ensemble* E) : Collection(E) {
}

ElementRef Ensemble::get(int i) {
	return (ElementRef)Collection::get(i);
}

Ensemble ensemble(int n, ...) {
	va_list arg_ptr;
	va_start(arg_ptr, n);

	EnsembleRef e = new Ensemble();

	fromto(int, i, 0, n) {
		e->add(new Element(va_arg(arg_ptr, double)));
	}

	va_end(arg_ptr);

	return e;
}

/* Le mode (la valeur la plus frequente d'une distribution)
*/
Element mode(Ensemble& E) {
	Element r;
	return r;
}

/* La mediane
 Les valeurs du caractere X etant classees par ordre croissant, la mediane est la valeur du caractere qui
 partage l'ensemble decrit par X en deux sous ensembles d'effectifs egaux : 50 % des elements ont des
 valeurs de X superieures à X med et 50% prennent des valeurs inferieures. La mediane ne peut être
 calculee que pour les caracteres quantitatifs. */
Element median(Ensemble& E) {
	Element r;
	
	/* On ordonne le tableau, et on cherche l'element qui partage la distribution en deux parties egales: on
	 repere l'element qui a le rang (N+1)/2 pour le caractere X */
	
	Ensemble sortedE;
	sortedE.add(&E);
	sortedE.sort(CompareElement);
	
	int N = sortedE.getCount();
	
	int i = (N+1)/2;
	
	if ( N%2 ) {
		/* impair
		 Si la distribution a un nombre impair d'elements on trouve une valeur unique qui est la mediane */
		r = *sortedE.get(i-1);
	}
	else  {
		/* pair
		 Si la distribution a un nombre pair d'elements on trouve deux valeurs qui determinent un intervalle median
		 On prend alors pour mediane le centre de cet intervalle median */
		Element m;
		
		m = *sortedE.get(i);
		m += *sortedE.get(i-1);
		
		m /= 2;
		
		r = m;
	}
	
	sortedE.removeAll();
	
	return r;
}

/* La moyenne
*/
Element moyenne(Ensemble& E) {
	Element r;

	Iterator iter = E.getIterator();
	while ( iter.hasNext() ) {
		ElementRef elt = (ElementRef)iter.next();
		r += *elt;
	}

	double N = E.getN();
	r /= N;

	return r;
}

/* La regression polynomiale (tendance)
*/
void RegressionPolynomiale(Matrix& result, GraphSerieRef serie, int ordre) {
	int n = serie->getCount();
	
	Matrix X(n, ordre+1);
	Matrix y(n, 1);

	fromto(int, x, 0, n) {
		X.set(x, 0, 1);
		y.set(x, 0, serie->get(x)->m_val);

		fromto(int, iordre, 1, ordre+1) {
			X.set(x, iordre, pow(x+1, iordre));
		}
	}

	Matrix Xt;
	Xt = X;
	Xt.transpose();

	result = Xt;
	result *= X;

	result.inverse();

	result *= Xt;
	result *= y;
}

ImplementClass(StatView) : public View {
public:
	virtual void create() {
		Ensemble E;
		
		add(new StaticControl("mode"), posNextLine);
		add(new FloatControl(mode(E).getVal()));
		
		add(new StaticControl("mediane"), posNextLine);
		add(new FloatControl(median(E).getVal()));
		
		add(new StaticControl("moyenne"), posNextLine);
		add(new FloatControl(moyenne(E).getVal()));

	};

};

ApplicationObject<StatView, Model> appStat("Stat", "Stat", "stat.png");
