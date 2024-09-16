from array import array

from src.math.vector import *


size = 0.5

p1 = vec3(-size, -size, 0)
p2 = vec3(size, -size, 0)
p3 = vec3(size, size, 0)
p4 = vec3(-size, size, 0)

f1 = p1 + vec3(0, 0, size)
f2 = p2 + vec3(0, 0, size)
f3 = p3 + vec3(0, 0, size)
f4 = p4 + vec3(0, 0, size)

u5 = vec3(size, size, 1)

b1 = p1 + vec3(0, 0, -size)
b2 = p2 + vec3(0, 0, -size)
b3 = p3 + vec3(0, 0, -size)
b4 = p4 + vec3(0, 0, -size)

class Geometry(object):
    @staticmethod
    def line(s=1):
        vertices = array('f', [
            0, 0, 0,
            0, 0, 0,
            s, s, 0,
            s, s, 0,
        ])
        translations = array('f', [
            +1, +1, 0,
            -1, -1, 0,
            +1, +1, 0,
            -1, -1, 0,
        ])
        return vertices, translations

    @staticmethod
    def rect(s=1):
        vertices = array('f', [
            0, 0, 0,
            s, 0, 0,
            s, s, 0,
            0, 0, 0,
            s, s, 0,
            0, s, 0,
        ])
        return vertices

    @staticmethod
    def circle(r=1):
        vertices = array('f')

        n = 128

        x1, y1 = math.cos(0), math.sin(0)
        x2, y2 = 0, 0

        for i in range(1, n + 1):
            x2 = math.cos(math.tau * i / n)
            y2 = math.sin(math.tau * i / n)

            vertices.append(0)
            vertices.append(0)
            vertices.append(0)

            vertices.append(x2)
            vertices.append(y2)
            vertices.append(0)

            vertices.append(x1)
            vertices.append(y1)
            vertices.append(0)

            x1, y1 = x2, y2

        return vertices

    @staticmethod
    def box():
        vertices = array('f')

        for v in [b1, f1, f4, b1, f4, b4, # left
                  f1, f2, f3, f1, f3, f4, # front
                  f2, b2, b3, f2, b3, f3, # right
                  b2, b1, b4, b2, b4, b3, # back
                  f4, f3, b3, f4, b3, b4, # top
                  b1, b2, f2, b1, f2, f1  # bottom
                  ]:
            vertices.append(v.x)
            vertices.append(v.y)
            vertices.append(v.z)

        return vertices
