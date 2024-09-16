from src.graphic.graphic_sdl import *


def background(clr):
    return config.graphic.background(clr)


def stroke(clr):
    return config.graphic.stroke(clr)


def stroke_width(width):
    return config.graphic.stroke_width(width)


def point(x, y):
    return config.graphic.point(x, y)


def points(vertices):
    return config.graphic.points(vertices)


def line(x1, y1, x2, y2):
    return config.graphic.line(x1, y1, x2, y2)


def lines(vertices):
    return config.graphic.lines(vertices)


def rect(x, y, w, h):
    return config.graphic.rect(x, y, w, h)


def circle(x, y, r):
    return config.graphic.circle(x, y, r)


def ellipse(x, y, w, h):
    return config.graphic.ellipse(x, y, w, h)


def sprite(image, x, y):
    return config.graphic.sprite(image, x, y)


def text(txt, x, y):
    return config.graphic.text(txt, x, y)


def box():
    return config.graphic.box()
