from src.engine.engine import *


class Game(Application):
    def __init__(self):
        super().__init__()
        self.image = None

    def setup(self):
        self.image = Image('./res/images/joconde.png')

    def release(self):
        self.image.release()

    def draw(self):
        background(black)

        for i in range(1):
            point(100, 100)

            stroke(green)
            rect(0, 0, mouse.x, mouse.y)

            stroke(blue)
            ellipse(mouse.x, mouse.y, 200, 300)

            stroke(red)
            line(100, 100, mouse.x, mouse.y)

            sprite(self.image, mouse.x, mouse.y)

            translate(1, -1)
