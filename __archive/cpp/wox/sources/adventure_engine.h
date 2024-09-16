#pragma once

#include "game_engine.h"

class AdventureGameEngine : public GameEngine {
public:
    AdventureGameEngine(const char* wndTitle, int w, int h);
    virtual ~AdventureGameEngine();
    
protected:    
    virtual bool game_init();
    
public:
    virtual bool model_init();
    virtual void model_draw();

private:
    void model0();
    
private:
    void arbre(int x, int y, int z);
    void cactus(int x, int y, int z);
    void cactus_branche(int x, int y, int z, int h, int dx, int dy);
    
    void vegetation();
    
    void escalier(int x, int y, int z, int h, int dx, int dy);
    void colimacon(int x, int y, int z, int h);

    void pyramide(int x, int y, int z, int h);
    void sphere  (int x, int y, int z, int r);
    
    void silo    (int x, int y, int z, int r, int h);
    
    void mur(int x, int y, int z, int w, int h, int dx, int dy, byte material, byte material2 = null_material);
    void mur(int x, int y, int z, int w, int h, int dx, int dy);
    
    void plancher(int x, int y, int z, int w, int h, byte material);
    void plancher(int x, int y, int z, int w, int h);
    
    void tour(int x, int y, int z, int w, int);

protected:
    Model reticule;
    Model barre_de_vie;
    Model skybox;
    
};
