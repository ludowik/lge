from src.engine.engine import *


class Game(Application):
    def draw(self):
        background(black)

        translate(0, 0)

        perspective()
        camera(vec3(0, 0, 0))
        box()
        rect(1, 1, 10, 10)
