from src.event.mouse import *
from src.libc.sdl import sdl, sdl_ffi


class Events(object):
    def __init__(self, action):
        self.event = sdl_ffi.new('SDL_Event*')
        self.QUIT = 'quit'

        self.action = action

    def process_events(self):
        while sdl.SDL_PollEvent(self.event) == 1:
            if self.event.type == sdl.SDL_WINDOWEVENT:
                if self.event.window.event == sdl.SDL_WINDOWEVENT_CLOSE:
                    self.quit()

            elif self.event.type == sdl.SDL_KEYDOWN:
                key = sdl_ffi.string(sdl.SDL_GetScancodeName(self.event.key.keysym.scancode)).decode().lower()
                self.action.process_key(key)

            elif self.event.type == sdl.SDL_MOUSEMOTION:
                mouse.x = self.event.motion.x
                mouse.y = self.h - self.event.motion.y
