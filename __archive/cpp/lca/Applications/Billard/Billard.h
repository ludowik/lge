#pragma once

class BillardForm : public View {
public:
	class Billard* billard;

public:
	BillardForm();
	virtual ~BillardForm();

public:
	virtual void InitUI();

};

class Billard : public Panel {
	int CoeffTapis;
	int CoeffBille;

	int CoeffBandeFrottement;
	int CoeffBandeElasticite;

	double m_largeurArdoise;
	double m_longueurArdoise;

	double m_largeurCadre;
	double m_longueurCadre;

	double m_largeurBande;
	double m_hauteurBande;

	double m_hauteurBillard;

	double m_f;

	class Ball* m_blanche;

public:
	Billard();
	virtual ~Billard();

	void CalcNextPos();

	virtual bool OnIdle();

	virtual void OnCalc();
	virtual void OnDraw(Gdi& gdi);

	virtual bool OnPenUp(int x, int y);
	virtual bool OnPenMove(int x, int y);

public:
	void CreateBillardAmericain();
	void CreateBillardFrancais();

	void CreateBillard(
		double largeurArdoise, double longueurArdoise, 
		double largeurCadre, double longueurCadre, 
		double largeurBande, double hauteurBande,
		double hauteurBillard);
	Ball* CreateBille(double diametreBille,
		Color couleur,
		bool pleine_raye,
		Char* text,
		int id,
		double x, double y);

};

typedef class CollectionObject<Array, Point> PointList;

class Ball : public Control {
public:
	int m_Masse;

	int m_Inertie;

	int m_Couleur;

	double m_SpeedLinear;
	double m_SpeedAngular;

	Bitmap m_Image;

	PointList move;

public:
	double x;
	double y;

	double m_d;
	double m_r;

	double m_vx;
	double m_vy;

public:
	Ball(int oid);
	virtual ~Ball();

	void CalcNextPos(double dt);

	virtual void OnCalc();
	virtual void OnDraw(Gdi& gdi);

};
