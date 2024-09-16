import glm

import src.engine.config as config
from src.math.vector import *


class Transform:
    modelMatrix = None
    viewMatrix = None
    projectionMatrix = None


def resetMatrix():
    Transform.modelMatrix = glm.mat4()
    Transform.viewMatrix = glm.mat4()
    ortho()


def ortho():
    Transform.projectionMatrix = glm.orthoLH(0, config.w, 0, config.h, 0.1, 1_000)


def perspective(fovy=45, aspect=config.w / config.h, near=0.1, far=1_000):
    Transform.projectionMatrix = glm.perspective(fovy, aspect, near, far)


def camera(eye, at=vec3(0, 0, 0), up=vec3(0, 1, 0)):
    f = (at - eye).normalize()
    u = up.normalize()
    s = f.cross(u).normalize()

    u = s.cross(f)

    Transform.viewMatrix = glm.mat4(
        s.x, s.y, s.z, -s.dot(eye),
        u.x, u.y, u.z, -u.dot(eye),
        -f.x, -f.y, -f.z, f.dot(eye),
        0, 0, 0, 1)


def modelMatrix():
    return Transform.modelMatrix


def viewMatrix():
    return Transform.viewMatrix


def projectionMatrix():
    return Transform.projectionMatrix


def translate(x, y, z=0):
    Transform.modelMatrix = glm.translate(Transform.modelMatrix, glm.vec3(x, y, z))


def scale(w, h, d=1):
    Transform.modelMatrix = glm.scale(Transform.modelMatrix, glm.vec3(w, h, d))


def rotate(angle):
    Transform.modelMatrix = glm.rotate(Transform.modelMatrix, angle)
