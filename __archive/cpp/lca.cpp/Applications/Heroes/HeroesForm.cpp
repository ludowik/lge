#include "HeroesForm.h"

class AltitudeMap {
private:
  double *map;
  bool *calc;

  double sealevel;
  
  int xsize;
  int ysize;

public:
  AltitudeMap(int _x, int _y);
  virtual ~AltitudeMap();

public:
  double get(int x, int y);
  void set(int x, int y, double alt);
  void init(int x, int y, double alt);

  void check(int x, int y);
  
  void Subdivision(double coeff, double lt, double rt, double lb, double rb);
  void SubdivPrivate(double coeff, int x1, int y1, int x2, int y2);

  void Randomize(double r);

  void Erosion(int r, int iter);

  void Plateau(int x, int y, int r);

};

AltitudeMap::AltitudeMap(int _xsize, int _ysize)
:xsize(_xsize),
ysize(_ysize),
sealevel(0.)
{
  map = new double [xsize*ysize];
  calc = new bool [xsize*ysize];

  for ( int x = 0 ; x < xsize ; ++x )
  {
    for ( int y = 0 ; y < ysize ; ++y )
    {
      init(x, y, 0.0);
    }
  }
}

AltitudeMap::~AltitudeMap()
{
  delete []map;
  delete []calc;
}

double AltitudeMap::get(int x, int y)
{
  return map[x*ysize+y];
}

void AltitudeMap::set(int x, int y, double alt)
{
  if ( !calc[x*ysize+y] )
  {  
    map[x*ysize+y] = alt;
  }
  calc[x*ysize+y] = true;
}

void AltitudeMap::init(int x, int y, double alt)
{
  map[x*ysize+y] = alt;
  calc[x*ysize+y] = false;
}

void AltitudeMap::check(int x, int y)
{
  double alt = get(x,y);
  if ( alt > 1.0 )
    init(x, y, 1.0);
  else if ( alt < 0.0 )
    init(x, y, 0.0);
}

/*
* coeff est un nombre à virgule flottante compris entre 0.0 et 0.5
*/
void AltitudeMap::Subdivision(double coeff, double lt, double rt, double lb, double rb)
{                                             
  init(0, 0, lt);
  init(xsize-1, 0, rt);

  init(0, ysize-1, lb); 
  init(xsize-1, ysize-1, rb);

  SubdivPrivate(coeff, 0, 0, xsize-1, ysize-1);

  for ( int x = 0 ; x < xsize ; ++x )
  {
    for ( int y = 0 ; y < ysize ; ++y )
    {
      init(x, y, get(x, y) + 0.5);
      check(x, y);
    }
  }
}

void AltitudeMap::SubdivPrivate(double coeff, int x1, int y1, int x2, int y2)
{
  if ( abs(x1-x2) <= 1
    && abs(y1-y2) <= 1 )
    return;

  int xmiddle = x1 + int(floor((x2-x1)/2.0));
  int ymiddle = y1 + int(floor((y2-y1)/2.0));

  double x1y1 = get(x1,y1);
  double x1y2 = get(x1,y2);
  double x2y1 = get(x2,y1);
  double x2y2 = get(x2,y2);

  const double v = 0.5;

  set(xmiddle, y1     , ( x1y1 + x2y1 ) / 2.0 + rand(-v,v) * coeff);
  set(x1     , ymiddle, ( x1y1 + x1y2 ) / 2.0 + rand(-v,v) * coeff);
  set(xmiddle, ymiddle, ( x1y1 + x2y2 ) / 2.0 + rand(-v,v) * coeff);
  set(xmiddle, y2     , ( x1y2 + x2y2 ) / 2.0 + rand(-v,v) * coeff);
  set(x2     , ymiddle, ( x2y1 + x2y2 ) / 2.0 + rand(-v,v) * coeff);

  coeff *= coeff;

  SubdivPrivate(coeff, x1, y1, xmiddle, ymiddle);
  SubdivPrivate(coeff, xmiddle, y1, x2, ymiddle);
  SubdivPrivate(coeff, x1, ymiddle, xmiddle, y2);
  SubdivPrivate(coeff, xmiddle, ymiddle, x2, y2);
}

void AltitudeMap::Randomize(double r)
{
  for ( int x = 0 ; x < xsize ; ++x )
  {
    for ( int y = 0 ; y < ysize ; ++y )
    {
      init(x, y, get(x, y) + rand(-r,r));
      check(x, y);
    }
  }
}

void AltitudeMap::Erosion(int r, int iter)
{
  int r2 = r*r;

  double *copy = new double [xsize*ysize];
  while ( iter-- )
  {
    for ( int x = 0 ; x < xsize ; ++x )
    {
      for ( int y = 0 ; y < ysize ; ++y )
      {
        double sum = 0.0;

        int offx;
        if ( x >= r )
          offx = -r;
        else
          offx = 0;

        for ( ; offx <= r && offx+x < xsize ; ++offx) {
          int offy;
          if ( y >= r )
            offy = -r;
          else
            offy = 0;

          for ( ; offy <= r && offy+y < ysize ; ++offy ){
            sum += get(x+offx, y+offy);
          }
        }

        copy[x*ysize+y] = sum / (double)(4*r2+4*r+1);
      }
    }
    for ( int x = 0 ; x < xsize ; ++x )
    {
      for ( int y = 0 ; y < ysize ; ++y )
      {
        init(x, y, copy[x*ysize+y]);
        check(x, y);
      }
    }
  }
  delete []copy;
}

void AltitudeMap::Plateau(int x, int y, int r)
{
  int offx;
  if ( x >= r )
    offx = -r;
  else
    offx = 0;

  for ( ; offx <= r && offx+x < xsize ; ++offx)
  {
    int offy;

    if ( y >= r )
      offy = -r;
    else
      offy = 0;

    for ( ; offy <= r && offy+y < ysize ; ++offy )
    {
      double distance = sqrt(offx*offx+offy*offy)/double(r);
      if ( distance > 1.0 )
      {
        continue;
      }

      init(x+offx, y+offy, distance*get(x+offx,y+offy)+(1.0-distance)*get(x,y));
      check(x, y);
    }
  }
}

CHeroesForm::CHeroesForm() : Form(_t("Heroes"))
{
  m_pboard = new Board(g_wscreen, g_hscreen);
  
  AltitudeMap map(g_wscreen, g_hscreen);
  map.Subdivision(0.5,
    rand(0.0, 1.0),
    rand(0.0, 1.0),
    rand(0.0, 1.0),
    rand(0.0, 1.0));
  map.Randomize(0.02);
  map.Erosion(10, 2);
  map.Plateau(g_wscreen/2, g_hscreen/2, 25);

  for ( int x = 0 ; x < m_pboard->m_w ; ++x )
  {
    for ( int y = 0 ; y < m_pboard->m_h ; ++y )
    {
      m_pboard->Set(Position(x,y), int(map.get(x,y)*255.0));
    }
  }
}

CHeroesForm::~CHeroesForm()
{
  delete m_pboard;
}

void CHeroesForm::InitUI()
{
  CForm::InitUI();
}

void CHeroesForm::OnDraw(Gdi& gdi)
{
  for ( int x = 0 ; x < m_pboard->m_w ; ++x )
  {
    for ( int y = 0 ; y < m_pboard->m_h ; ++y )
    {
      int color = m_pboard->Get(Position(x,y));
      gdi.set_Pixel(x, y,
        Rgb(color,0,0));
    }
  }
}

/*
Force // Strenght
Dexterite // Dexterity
Connaissance // Knowledge
Defense // Fonction de armure et bouclier
Resistance
Or
Niveau // Level : Le niveau définit l'expérience a acquérir pour passer au niveau supérieur
Experience // Experience max a atteindre par niveau et experience courante utilisée dans les combats
Vie // Vie max disponible selon niveau / expérience / Resistance et vie courante

Armure / Bouclier / Casque
Defense
Resistance // ou nombre d'utilisation possible

Arme
Attaque // Force
Resistance // ou nombre d'utilisation possible
Type // Utilité ?? Arme de jet, lame, hache
Force // Force requise pour utilisation

Arme magique
Attaque // Effet
Resistance // ou nombre d'utilisation possible
Type // Eau, Feu, Eau...
Experience // Expérience requise pour utilisation

Inventaire
Inventaire global : ce dont je dispose
- armures
- casques
- boucliers
- armes
- potions (effet sur les caractéristiques à l'utilisation)
- amulettes (effet sur les caractéristiques immédiat)
Inventaire courant : ce que j'utilise
- 1 armure
- 1 casque
- 1 bouclier + 1 arme // ou 2 armes

Potion
Vie
Augmenter une caractéristique (temporaire, définitif)

Combat
Tour par tour
Action
- attaque
- attaque magique
- utilisation d'une potion
- la fuite
Effet selon formule à définir
*/
