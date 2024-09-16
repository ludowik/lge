from src.engine.engine import *


class Game(Application):
    def setup(self):
        self.vertices = [vec2.random(config.W, config.H) for i in range(10)]

    def draw(self):
        background(black)

        stroke(white)
        stroke_width(5)

        lines(self.vertices)

        stroke(red)
        points(self.vertices)
