import src.engine.config as config

from src.libc.sdl import sdl, sdl_ffi
from src.engine.game_object import Component
from src.engine.application import *


class Actions(Component):
    def __init__(self, engine):
        self.engine = engine
        self.keys = {}

    def on_key(self, key, f):
        self.keys[key] = f

    def process_key(self, key_pressed):
        for key, f in self.keys.items():
            if key == key_pressed:
                f()

    def setup(self):
        self.on_key('escape', self.engine.quit)
        self.on_key('s', self.switch_synchro)
        self.on_key('l', self.switch_draw_mode)
        self.on_key('r', self.switch_render_mode)
        self.on_key('n', self.switch_application)

    @staticmethod
    def switch_synchro(synchro=None):
        config.synchro = synchro or not config.synchro
        sdl.SDL_GL_SetSwapInterval(config.synchro and 1 or 0)

    @staticmethod
    def switch_draw_mode():
        if config.draw_mode == 'lines':
            config.draw_mode = 'triangles'
        else:
            config.draw_mode = 'lines'

    @staticmethod
    def switch_render_mode():
        if config.render_mode == 'batch':
            config.render_mode = 'direct'
        else:
            config.render_mode = 'batch'

    def switch_application(self):
        def find_next_app():
            next_app = False
            for app_name, app_class in self.engine.apps.items():
                if next_app:
                    return app_name, app_class
                if app_name == self.engine.app_name:
                    next_app = True
            return list(self.engine.apps.items())[0]

        app_name, app_class = find_next_app()
        if app_name:
            self.engine.app_name = app_name
            self.engine.application = app_class.Game()
            self.engine.application.setup()
            sdl.SDL_SetWindowTitle(self.engine.window, sdl_ffi.char(app_name));

