#include "System.h"
#include "Billard.h"

/* LE BILLARD AMERICAIN
La surface de jeu est constituee d’une ardoise recouverte d’un drap dont les dimensions sont :
2,54 m x 1,27 m.
La delimitation de la surface de jeu se fait par l’opposition de bandes de caoutchouc, fixees sur
un cadre, hautes de 36 à 37 mm. Les dimensions du cadre sont : 2,80 m x 1,527 m.
Le cadre supporte des reperes appeles « mouches ».
La hauteur du billard entre le sol et la surface superieure du cadre doit être comprise entre 0,75
m et 0,80 m.
La dimension des poches d’angles peut varier de 125 mm à 140 mm à l’intersection des bandes
et 105 mm à 120 mm à l’entree de la poche ; la dimension des poches laterales est comprise
entre 135 mm et 150 mm et 110 mm à 125 mm à l’entree de la poche.
Les billes, de matiere synthetique, sont au nombre de 16 pour le jeu du 8 ou 14/1 continu et 10
pour le jeu de la neuf. Ces billes sont numerotees de 1 à 8 pour les billes dites pleines et 9 à 15
pour les cerclees. La seizieme est m_blanche est appelee bille de choc.
Leur masse est compris entre 170,10 g et 184,27 g et leur diametre entre 56,35 mm et 57,95
mm.
La queue est en bois ou matiere composite et comprend plusieurs parties :
- le procede (en cuir) d’un diametre de 10 à 12 mm
- la virole (en matiere synthetique)
- la fleche
- le talon (ou fût)
*/
void Billard::CreateBillardAmericain() {
	double longueurArdoise = 1.27;
	double largeurArdoise  = 2.54;

	double longueurCadre = 1.527;
	double largeurCadre  = 2.80;

	double largeurBande = .36;
	double hauteurBande = .36;

	double hauteurBillard = .8;

	double diametreBille = .056;

	CreateBillard(
		largeurArdoise, longueurArdoise, 
		largeurCadre, longueurCadre, 
		largeurBande, hauteurBande,
		hauteurBillard);

	double dx = sin(60)*diametreBille;
	double dy = cos(60)*diametreBille;

	double x = longueurArdoise/3;
	double y = largeurArdoise /2;

	int oid = 0;
	m_blanche = CreateBille(diametreBille, white , true , _t(""), oid++, x*2, y);

	CreateBille(diametreBille, yellow, true ,  _t("1"), oid++, x, y);

	x -= dx;
	CreateBille(diametreBille, red   , true , _t( "3"), oid++, x, y-dy);
	CreateBille(diametreBille, green , false, _t("14"), oid++, x, y+dy);

	x -= dx;
	CreateBille(diametreBille, red   , false, _t("11"), oid++, x, y-2*dy);
	CreateBille(diametreBille, black , true , _t( "8"), oid++, x, y);
	CreateBille(diametreBille, orange, false, _t("13"), oid++, x, y+2*dy);

	x -= dx;
	CreateBille(diametreBille, yellow, false, _t( "9"), oid++, x, y-3*dy);
	CreateBille(diametreBille, blue  , true , _t( "2"), oid++, x, y-dy);
	CreateBille(diametreBille, blue  , false, _t("10"), oid++, x, y+dy);
	CreateBille(diametreBille, purple, true , _t( "4"), oid++, x, y+3*dy);

	x -= dx;
	CreateBille(diametreBille, orange, true , _t( "5"), oid++, x, y-4*dy);
	CreateBille(diametreBille, brown , false, _t("15"), oid++, x, y-2*dy);
	CreateBille(diametreBille, green , true , _t( "6"), oid++, x, y);
	CreateBille(diametreBille, purple, false, _t("12"), oid++, x, y+2*dy);
	CreateBille(diametreBille, brown , true , _t( "7"), oid++, x, y+4*dy);
}

/* LE BILLARD FRANCAIS
*/
void Billard::CreateBillardFrancais()
{
	double longueurArdoise = 1.15;
	double largeurArdoise  = 2.30;

	double longueurCadre = 1.41;
	double largeurCadre  = 2.56;

	double largeurBande = .36;
	double hauteurBande = .36;

	double hauteurBillard = .8;

	double diametreBille = .0615;

	CreateBillard(
		largeurArdoise, longueurArdoise, 
		largeurCadre, longueurCadre, 
		largeurBande, hauteurBande,
		hauteurBillard);

	double dx = sin(60)*diametreBille;
	double dy = cos(60)*diametreBille;

	double x = longueurArdoise/3;
	double y = largeurArdoise /2;

	m_blanche = CreateBille(diametreBille, yellow, true, _t(""), 1, x*2, y);

	CreateBille(diametreBille, red  , true, _t(""), 2, x, y);
	CreateBille(diametreBille, white, true, _t(""), 2, x, y+.2);
}

/* LE 8 POOL ANGLAIS
La surface de jeu est constituee d’une ardoise recouverte d’un drap dont les dimensions sont :
1,851 m x 0,935 m.
La delimitation de la surface de jeu se fait par l’opposition de bandes de caoutchouc, fixees sur
un cadre, hautes de 36 à 37 mm.
La hauteur du billard entre le sol et la surface superieure du cadre doit être comprise entre 0,75
m et 0,85 m.
La dimension des poches est de 76,2 mm soit 1 bille ½.
Les billes, de matiere synthetique, sont au nombre de 16. Les 7 billes rouges, 7 billes jaunes et
la bille noire numerotee 8 sont appelees billes de but. La seizieme bille est m_blanche et est
appelee bille de choc.
Leur diametre est de 50,8 mm pour les billes de but et 48 mm pour la bille de choc.
La queue est en bois et comprend plusieurs parties :
- le procede (en cuir) d’un diametre de 8 à 9 mm
- la virole (en laiton)
- la fleche
- le talon (ou fût)
La queue peut être en trois quart (¼ talon, ¾ fleche), demi (½ talon, ½ fleche) ou monobloc.
*/

/* LE SNOOKER
La surface de jeu est constituee d’une ardoise recouverte d’un drap dont les dimensions sont :
3,5687 m x 1,7778 m.
La delimitation de la surface de jeu se fait par l’opposition de bandes de caoutchouc, fixees sur
un cadre, hautes de 36 à 37 mm.
La hauteur du billard entre le sol et la surface superieure du cadre doit être comprise entre
0,8509 m et 0,8763 m.
Les billes, de matiere synthetique, sont au nombre de 22. 15 billes rouges et 6 billes de
couleurs differentes representent les billes de but. La vingt-deuxieme bille est m_blanche et est
appelee bille de choc.
Leur diametre est de 52,5 mm.
La queue est en bois et comprend plusieurs parties :
- le procede (en cuir) d’un diametre de 8 à 9 mm
- la virole (matiere synthetique)
- la fleche
- le talon (ou fût)
Elle doit mesurer au minimum 3 pieds de long soit 910 mm. Il est recommande une queue ¾
pour adapter un plus grand talon lorsque la bille de choc est trop
eloignee.
*/

BillardForm::BillardForm() : Form(_t("Billard"))
{
}

BillardForm::~BillardForm()
{
}

void BillardForm::InitUI()
{
	Form::InitUI();

	((Billard*)Add(new Billard()))->CreateBillardAmericain();
	//((Billard*)Add(new Billard()))->CreateBillardFrancais();
}

Billard::Billard()
{
	set_cid(objBillard);

	set_Border(true);
	set_opaque(true);

	m_f = 1;
}

Billard::~Billard()
{
}

void Billard::CreateBillard(double largeurArdoise, double longueurArdoise, 
							 double largeurCadre, double longueurCadre, 
							 double largeurBande, double hauteurBande,
							 double hauteurBillard)
{
	NormalBackColor = green;

	m_largeurArdoise = largeurArdoise;
	m_longueurArdoise = longueurArdoise;
	m_largeurCadre = largeurCadre;
	m_longueurCadre = longueurCadre;
	m_largeurBande = largeurBande;
	m_hauteurBande = hauteurBande;
	m_hauteurBillard = hauteurBillard;

	m_f = 200;
}

Ball* Billard::CreateBille(double diametreBille,
							 Color couleur,
							 bool pleine_raye,
							 Char* text,
							 int id,
							 double x, double y)
{
	Ball* ball = (Ball*)Add(new Ball(id), posFree);

	ball->x = x;
	ball->y = y;

	ball->m_d = diametreBille;
	ball->m_r = diametreBille/2;

	ball->m_vx = 0;
	ball->m_vy = 0;

	ball->m_SpeedLinear = 0;

	ball->NormalForeColor = couleur;

	ball->set_Text(text);

	return ball;
}

bool Billard::OnIdle()
{
	Draw();
	return true;
}

void Billard::OnCalc()
{
	Panel::OnCalc();

	set_WH(
		(int)( m_f * m_longueurArdoise ),
		(int)( m_f * m_largeurArdoise  ));
}

void Billard::OnDraw(Gdi& gdi)
{
	for ( int i = 0 ; i < GetCount() ; ++i )
	{
		CBall* ball = (CBall*)GetAt(i);

		ball->m_x = (int)( m_x + m_f * ( ball->x - ball->m_r ));
		ball->m_y = (int)( m_y + m_f * ( ball->y - ball->m_r ));
	}

	Control::OnDrawBackground(gdi);
	Panel::OnDraw(gdi);

	if ( CEvent::g_penDown )
	{
		double vx = m_f * m_blanche->x - ( CEvent::g_lastX - m_x );
		double vy = m_f * m_blanche->y - ( CEvent::g_lastY - m_y );

		Vector v(vx, vy);
		v.Normalize();
		v.SetNorm(30);

		gdi.Vector(
			int(m_blanche->m_x-m_x+m_blanche->m_r*m_f-v.m_x),
			int(m_blanche->m_y-m_y+m_blanche->m_r*m_f-v.m_y),
			int(v.m_x),
			int(v.m_y),
			Black);
	}
}

bool Billard::OnPenMove(int x, int y)
{  
	Draw();

	return true;
}

bool Billard::OnPenUp(int x, int y)
{
	double vx = m_f * m_blanche->x - ( x - m_x );
	double vy = m_f * m_blanche->y - ( y - m_y );

	Vector v(vx, vy);

	m_blanche->m_SpeedLinear = v.GetNorm() / 100.;

	v.Normalize();

	m_blanche->m_vx = v.m_x;
	m_blanche->m_vy = v.m_y;

	CalcNextPos();

	Draw();

	return true;
}

void Billard::CalcNextPos()
{
	double dt = 0.05;

	double SpeedLinear = 0;

	do
	{
		SpeedLinear = 0;

		for ( int i = 0 ; i < GetCount() ; ++i )
		{
			Ball* ball1 = (Ball*)GetAt(i);
			SpeedLinear += ball1->m_SpeedLinear;
		}

		for ( int i = 0 ; i < GetCount() ; ++i )
		{
			Ball* ball1 = (Ball*)GetAt(i);
			ball1->CalcNextPos(dt);

			ball1->move.Add(new CPoint(
				(int)( m_x + m_f * ( ball1->x - ball1->m_r ) ),
				(int)( m_y + m_f * ( ball1->y - ball1->m_r ) )));
		}

		for ( int i = 0 ; i < GetCount() ; ++i )
		{
			Ball* ball1 = (Ball*)GetAt(i);

			double sl = ball1->m_SpeedLinear;
			if ( sl > .001 )
			{
				for ( int j = 0 ; j < GetCount() ; ++j )
				{
					if ( i != j )
					{
						Ball* ball2 = (Ball*)GetAt(j);

						double dx = ball2->x - ball1->x;
						double dy = ball2->y - ball1->y;

						double distance = sqrt(dx*dx + dy*dy);
						if ( distance < ball1->m_r + ball2->m_r )
						{
							Vector v(ball1->m_vx, ball1->m_vy);

							Vector v2(dx, dy);
							v2.Normalize();

							double dot_product = Vector::DotProduct(&v, &v2);
							double angle = acos(dot_product);
							double transfert = angle/90.;

							ball2->m_vx = v2.m_x;
							ball2->m_vy = v2.m_y;

							ball2->m_SpeedLinear = sl * (1.-transfert);
							ball1->m_SpeedLinear = sl * (   transfert);

							Vector v1(
								ball1->m_vx * ball1->m_SpeedLinear - v2.m_x * ball2->m_SpeedLinear,
								ball1->m_vy * ball1->m_SpeedLinear - v2.m_y * ball2->m_SpeedLinear);
							v1.Normalize();

							ball1->m_vx = v1.m_x;
							ball1->m_vy = v1.m_y;

							v2.SetNorm(1.001*(ball1->m_r + ball2->m_r));
							v2.GetNorm();

							ball1->x = ball2->x-v2.m_x;
							ball1->y = ball2->y-v2.m_y;
						}
					}
				}
			}
		}

		Draw();
	}
	while ( SpeedLinear != 0);
}

Ball::Ball(int oid) : CControl(_t(""), oid)
{
	get_Text().Format(_t("%ld"), 1 + oid);

	set_LayoutText(posHcenter|posVcenter);

	m_vx = 0;
	m_vy = 0;

	m_d = 0;
	m_r = 0;

	m_SpeedLinear = 0;
	m_SpeedAngular = 0;

	set_opaque(false);

	NormalForeColor = Red;

	set_fontSize(14);

	x = 0;
	y = 0;
}

Ball::~Ball()
{
}

void Ball::OnCalc()
{
	double f = ((Billard*)get_parent())->m_f;
	set_WH(
		(int)( f * m_d ),
		(int)( f * m_d ));
}

void Ball::OnDraw(Gdi& gdi)
{
	if ( get_Image().m_w == 0 )
	{
		get_Image().Init(m_w, m_h);

		get_Image().set_fontSize(get_fontSize());
		get_Image().set_fontName(get_fontName());

		double f = ((Billard*)get_parent())->m_f;

		get_Image().Circle(
			int(f*m_r),
			int(f*m_r),
			int(f*m_r),
			Black,
			NormalForeColor);

		get_Image().Text(xLayoutText(), yLayoutText(), get_Text(), TextColor(), Transparent);
	}

	gdi.Bitmap(get_Image(), 0, 0, 0, 0, 0, 0, White);
}

void Ball::CalcNextPos(double dt)
{
	if ( m_parent )
	{
		double f = ((Billard*)get_parent())->m_f;

		double w = m_parent->m_w / f;
		double h = m_parent->m_h / f;

		double dx = m_vx * m_SpeedLinear;
		double dy = m_vy * m_SpeedLinear;

		if ( dt )
		{
			m_SpeedLinear = m_SpeedLinear - m_SpeedLinear * dt * .3;
			if ( m_SpeedLinear < .05 )
			{
				m_SpeedLinear = 0;
			}
			else
			{
				x = x + dx * dt;
				y = y + dy * dt;

				bool ouest = x <= m_r;
				bool nord  = y <= m_r;

				bool est = x >= w-m_r;      
				bool sud = y >= h-m_r;

				if ( ouest && m_vx < 0 )
				{
					x = m_r;
					m_vx = -m_vx;
				}
				if ( est && m_vx > 0 )
				{
					x = w-m_r;
					m_vx = -m_vx;
				}
				if ( nord && m_vy < 0 )
				{
					y = m_r;
					m_vy = -m_vy;
				}
				if ( sud && m_vy > 0 )
				{
					y = h-m_r;
					m_vy = -m_vy;
				}
			}
		}
	}
}
