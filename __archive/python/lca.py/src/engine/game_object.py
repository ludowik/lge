from src.engine.component import *


class GameObject(Component):
    id = 1

    def __init__(self):
        super().__init__()
        self.id = GameObject.id
        GameObject.id += 1

