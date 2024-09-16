from src.graphic.graphic import *


class Window(object):
    def __init__(self, engine):
        self.engine = engine

    def __enter__(self):
        if sdl.SDL_Init(sdl.SDL_INIT_VIDEO):
            raise NameError('SDL_Init')

        sdl.SDL_SetThreadPriority(sdl.SDL_THREAD_PRIORITY_HIGH)

        attributes = sdl.SDL_WINDOW_RESIZABLE

        if config.mode == 'gl':
            attributes |= sdl.SDL_WINDOW_OPENGL

            sdl.SDL_GL_SetAttribute(sdl.SDL_GL_CONTEXT_MAJOR_VERSION, 2)
            sdl.SDL_GL_SetAttribute(sdl.SDL_GL_CONTEXT_MINOR_VERSION, 1)

            if sdl.SDL_GL_LoadLibrary(sdl_ffi.NULL):
                raise NameError('SDL_GL_LoadLibrary')

            sdl.SDL_GL_SetAttribute(sdl.SDL_GL_DOUBLEBUFFER, 1)
            sdl.SDL_GL_SetAttribute(sdl.SDL_GL_DEPTH_SIZE, 24)

        self.engine.window = sdl.SDL_CreateWindow(sdl_ffi.char(self.engine.name),
                                                  0, 0,
                                                  self.engine.w, self.engine.h,
                                                  attributes)

        if not self.engine.window:
            raise NameError('SDL_CreateWindow')

    def __exit__(self, exc_type, exc_val, exc_tb):
        sdl.SDL_DestroyWindow(self.engine.window)

        if config.mode == 'gl':
            sdl.SDL_GL_UnloadLibrary()

        sdl.SDL_Quit()


class Context(object):
    def __init__(self, engine):
        self.engine = engine

    def __enter__(self):
        if config.mode == 'gl':
            self.engine.context = sdl.SDL_GL_CreateContext(self.engine.window)
            if not self.engine.context:
                raise NameError('SDL_GL_CreateContext')
            gl.get_proc_adresses()
        else:
            self.engine.context = sdl.SDL_CreateRenderer(self.engine.window, -1, 0)
            if not self.engine.context:
                raise NameError('SDL_CreateRenderer')

    def __exit__(self, exc_type, exc_val, exc_tb):
        if config.mode == 'gl':
            if self.engine.context:
                sdl.SDL_GL_DeleteContext(self.engine.context)
        else:
            if self.engine.context:
                sdl.SDL_DestroyRenderer(self.engine.context)
