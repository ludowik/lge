import random

from src.tools.memory import *

from src.math.transform import *

from src.event.events import Events, mouse
from src.event.events_actions import Actions

from src.graphic.graphic import *
from src.graphic.graphic_gl import *
from src.graphic.graphic_sdl import *

from src.engine.engine_frame_time import *

from src.engine.window import *
from src.engine.application import *
from src.engine.scene import *


class Engine(Events, Actions, FrameTime):
    def __init__(self, apps, name='default'):
        self.apps = apps

        actions = Actions(self)

        Events.__init__(self, actions)
        FrameTime.__init__(self)

        if config.mode == 'gl':
            self.graphic = GraphicGL()
        else:
            self.graphic = GraphicSDL()

        self.components = Scene()
        self.components.add(self.graphic)
        self.components.add(actions)

        config.engine = self
        config.graphic = self.graphic

        self.name = name

        self.w = config.w
        self.h = config.h

        config.W, config.H = self.w, self.h

        self.active = True

        self.window = None
        self.context = None

        self.app_name = 'default'
        self.application = Application()

    def run(self, app_name):
        self.app_name = app_name
        self.application = self.apps[app_name].Game() or Application()

        with Window(self) as window:
            with Context(self) as context:
                self.graphic.renderer = self.context

                self.init()
                self.loop()
                self.release()

    def init(self):
        self.switch_synchro(config.synchro)

        self.graphic.setup()
        self.components.setup()

        self.library = ft.init_module()
        self.graphic.face = ft.load_font(self.library, b'./res/fonts/Arial.ttf', 8)

        self.setup()

    def loop(self):
        while self.active:
            self.frame()

    def quit(self):
        self.active = False

    def release(self):
        self.components.release()

        ft.release_font(self.graphic.face)
        ft.release_module(self.library)

    def frame(self):
        if self.process_events() == self.QUIT:
            self.active = False
            return

        self.reset()

        self.update(self.delta_time)
        self.draw()

        self.graphic.render_batch()

        self.swap()

        self.compute_time()

    def swap(self):
        if config.mode == 'gl':
            sdl.SDL_GL_SwapWindow(self.window)
        else:
            sdl.SDL_RenderPresent(self.context)

    def reset(self):
        self.components.reset()
        resetMatrix()

    def setup(self):
        self.application.app_setup()

    def update(self, dt):
        self.application.app_update(self.delta_time)

    def draw(self):
        self.graphic.draw_mode()
        self.application.app_draw()
        self.draw_info()

    def draw_info(self):
        resetMatrix()

        v = vec2(0, self.h)

        v -= text(f'fps : {self.fps}', 0, v.y)
        v -= text(f'ram : {memory()}', 0, v.y)

        v -= text(config.synchro, 0, v.y)
        v -= text(config.draw_mode, 0, v.y)
        v -= text(mouse, 0, v.y)

        v -= text(MeshRender.depth, 0, v.y)
        v -= text(MeshRender.n_render_calls, 0, v.y)
        v -= text(MeshRender.n_draw_arrays_calls, 0, v.y)
        v -= text(MeshRender.n_draw_arrays_instances_call, 0, v.y)
