from src.engine.game_object import GameObject


class Scene(GameObject):
    def __init__(self):
        self.nodes = []

    def add(self, node):
        self.nodes.append(node)

    def add_nodes(self, nodes):
        for node in nodes:
            self.nodes.append(node)

    def remove(self, node):
        self.nodes.remove(node)

    def setup(self):
        for node in self.nodes:
            node.setup()

    def release(self):
        for node in self.nodes:
            node.release()

    def reset(self):
        for node in self.nodes:
            node.reset()

    def update(self, dt):
        for node in self.nodes:
            node.update(dt)

    def draw(self):
        for node in self.nodes:
            node.draw()
