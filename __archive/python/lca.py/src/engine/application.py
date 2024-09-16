from src.engine.scene import *


class Application(object):
    def __init__(self):
        self.name = 'default'
        self.scene = Scene()

    def app_setup(self):
        self.setup()
        self.scene.setup()

    def app_update(self, dt):
        self.update(dt)
        self.scene.update(dt)

    def app_draw(self):
        self.draw()
        self.scene.draw()

    def setup(self):
        pass

    def update(self, dt):
        pass

    def draw(self):
        pass
