import enum

from src.graphic.color import *


class Mode(enum.Enum):
    CORNER = 'corner'
    CENTER = 'center'


class Style(object):
    def __init__(self):
        self.stroke_color = white
        self.fill_color = white
        self.tint_color = white
        self.sprite_mode = Mode.CENTER

        self._stroke_width = 2

    def reset_style(self):
        Style.__init__(self)

    def stroke(self, clr):
        self.stroke_color = clr

    def fill(self, clr):
        self.fill_color = clr

    def tint(self, clr):
        self.tint_color = clr

    def stroke_width(self, stroke_width):
        self._stroke_width = stroke_width

    def spriteMode(self, mode):
        self.sprite_mode = mode
