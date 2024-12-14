#include "System.h"

DeclareClass(TowerDefenseCell);
DeclareClass(TowerDefenseModel);

ImplementClass(Monster) : public Object {
public:
	int m_typeMonster;
	int m_lifeMax;
	int m_lifeCurrent;
	
	List m_chemin; // Le chemin à parcourir

public:
	int x;
	int y;

	LineRef m_line; // Le chemin entre deux case
	
public:
	Monster(int typeMonster);
	virtual ~Monster();
	
};

ImplementClass(Defender) : public Object {
public:
	int m_typeDefender;
	int m_attaque;

	TowerDefenseCellRef m_cell;
	List m_zone; // La zone défendue

public:
	Defender(int typeDefender, TowerDefenseCellRef m_cell);
	virtual ~Defender();
	
public:
	void initZone(TowerDefenseModelRef model);
	void addCellToZone(TowerDefenseModelRef model, int c, int l);

};

ImplementClass(TowerDefenseCell) : public Cell {
public:
	int m_typeCell;
	int m_nbDefenders;
	
public:
	MonsterRef m_monster;
	DefenderRef m_defender;
	
public:
	TowerDefenseCell(int c, int l, sint* pvalue, int id);

public:
	virtual void draw(GdiRef gdi);
	
};

ImplementClass(TowerDefenseModel) : public GameBoardModel {
public:
	List m_entree;
	List m_sortie;
	
	CollectionObject<List, Monster> m_monsters;
	CollectionObject<List, Defender> m_defenders;
	
	Timer m_timer;
	
	int m_previousDelay;

public:
	TowerDefenseModel();
	virtual ~TowerDefenseModel();

public:
	virtual CellRef newCell(int id, int c, int l);	
	virtual void init();

public:
	virtual bool idle();
	
public:
	void addMonster(int typeMonster);
	
public:
	virtual bool action(CellRef cell);
	
};

ImplementClass(TowerDefenseView) : public BoardView {
public:
	BitmapList m_resourcesMonsters;
	BitmapList m_resourcesDefenders;

	AudioClip m_shoot;

public:
	TowerDefenseView();
	virtual ~TowerDefenseView();
	
public:
	virtual void loadResource();
	
};
