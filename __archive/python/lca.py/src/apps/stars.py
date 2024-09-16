from src.engine.engine import *

MAX_STARS = 1000

class Star(GameObject):
    max_distance = vec2(config.w, config.h).len()

    def __init__(self, x, y):
        GameObject.__init__(self)

        self.position = vec2(0, 0)
        self.velocity = vec2(random.uniform(-1, 1), random.uniform(-1, 1)) * 25
        self.width = random.random()

    def update(self, dt):
        self.position += self.velocity * dt
        self.velocity *= 1.05
        self.width *= 1.01

    def draw(self):
        stroke_width(self.width)
        point(self.position.x, self.position.y)

    def is_out(self):
        distance = self.position.len()
        if distance > Star.max_distance:
            return True
        return False


class Game(Application):
    def setup(self):
        self.name = 'Stars'
        self.add_stars(100)

    def add_stars(self, n):
        self.scene.add_nodes([Star(random.randint(0, config.W), random.randint(0, config.H)) for i in range(n)])

    def update(self, dt):
        for star in self.scene.nodes:
            if star.is_out():
                self.scene.remove(star)

        self.add_stars(MAX_STARS-len(self.scene.nodes))

    def draw(self):
        background(black)
        translate(config.w / 2, config.h / 2)
        text(len(self.scene.nodes), 250, 100)
