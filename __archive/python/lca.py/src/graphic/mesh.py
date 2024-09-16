from array import array
from src.graphic.geometry import Geometry
from src.graphic.mesh_render import MeshRender


class Mesh(MeshRender):
    def __init__(self, vertices=Geometry.rect()):
        super().__init__()

        self.vertices = vertices

        self.translations = array('f', )
        self.colors = array('f', )

        self.textCoords = array('f', [
            0, 0,
            1, 0,
            1, 1,
            0, 0,
            1, 1,
            0, 1,
        ])
