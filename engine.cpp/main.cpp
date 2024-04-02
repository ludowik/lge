#include <iostream>

#include <SDL.h>

extern "C" {
    #include <stdio.h>
    #include <lua.h>
    #include <lualib.h>
    #include <lauxlib.h>
    #include <luajit.h>
};

int lua()
{
    int status;
    lua_State *L;

    L = luaL_newstate(); // open Lua
    if (!L)
    {
        return -1; // Checks that Lua started up
    }

    luaL_openlibs(L); // load Lua libraries
    // if (argc > 1)
    {
        status = luaL_loadfile(L, "/Users/Ludo/Dev/engine/main.lua"); // argv[1]); // load Lua script
        if (status)
        {
            /* If something went wrong, error message is at the top of */
            /* the stack */
            fprintf(stderr, "Couldn't load file: %s\n", lua_tostring(L, -1));
            exit(1);
        }

        int ret = lua_pcall(L, 0, 0, 0);       // tell Lua to run the script
        if (ret != 0)
        {
            fprintf(stderr, "%s\n", lua_tostring(L, -1)); // tell us what mistake we made
            return 1;
        }
    }

    lua_close(L); // Close Lua
    return 0;
}

int main(int, char **)
{
    lua();

    SDL_Init(SDL_INIT_EVERYTHING);

    SDL_Window *window = SDL_CreateWindow("engine",
                                          SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
                                          640, 480, 0);

    bool shouldClose = false;
    while (!shouldClose)
    {
        SDL_Event event;
        while (SDL_PollEvent(&event))
        {
            switch (event.type)
            {
            case SDL_WINDOWEVENT:
                if (event.window.event == SDL_WINDOWEVENT_CLOSE)
                {
                    shouldClose = true;
                }
                break;

            case SDL_KEYDOWN:
                if (event.key.keysym.sym == SDLK_ESCAPE)
                {
                    shouldClose = true;
                }
                break;

            default:
                break;
            }
        }
    }

    SDL_DestroyWindow(window);
    SDL_Quit();

    return 0;
}
