#include "headers.h"
#include "main.h"
#include "adventure_engine.h"

#define log(var) cout << #var << "= " << var << endl;

int mainapp() {
#ifdef __APPLE__
    // Récupération du Bundle
    CFURLRef URLBundle = CFBundleCopyResourcesDirectoryURL(CFBundleGetMainBundle());
    char* cheminResources = new char[PATH_MAX];
    
    // Changement du 'Working Directory'
    if ( CFURLGetFileSystemRepresentation(URLBundle, 1, (UInt8*)cheminResources, PATH_MAX) ) {
        chdir(cheminResources);
    }
    
    // Libération de la mémoire
    delete[] cheminResources;
    CFRelease(URLBundle);    
#endif
    
    log(MAP_SIZE);
    log(MAP_HALF_SIZE);
    
    log(CHUNK_SIZE);
    log(CHUNK_COUNT);
    
    log(CHUNK_HEIGHT);
    
    log(COMPUTE_Z);
    
    log(CLIP_SIZE);
    log(CLIP_HALF_SIZE);
    
    log(VOXEL_SIZE);
    log(VOXEL_COUNT);
    log(VOXEL_HALF_COUNT);
    
    mem_init();
    mem_info();
    
    {
		int w = is_os_win() ? 640 : 1200;
		int h = is_os_win() ? 480 :  900;
        
        AdventureGameEngine game("Adventure Game", w, h);
    
        if ( game.init() ) {
            game.run();
        }
    
        game.release();
    }
    
    mem_info();
    
    return 0;
}
