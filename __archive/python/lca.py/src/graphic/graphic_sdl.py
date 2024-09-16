from src.graphic.image import *
from src.engine.style import *
from src.math.vector import *


class GraphicSDL(Style):
    def __init__(self):
        self.sdl_rect = sdl_ffi.new('SDL_Rect*')
        self.sdl_points = sdl_ffi.new('SDL_Point[]', 64 + 1)

    def setup(self):
        pass

    def release(self):
        pass

    def reset(self):
        self.reset_style()

    def draw_mode(self):
        pass

    def render_batch(self):
        pass

    def background(self, clr):
        sdl.SDL_SetRenderDrawColor(self.renderer, *clr)
        sdl.SDL_RenderClear(self.renderer)

    def point(self, x, y):
        pass

    def line(self, x1, y1, x2, y2):
        sdl.SDL_SetRenderDrawColor(self.renderer, *self.stroke_color)
        sdl.SDL_RenderDrawLine(self.renderer, x1, y1, x2, y2)

    def rect(self, x, y, w, h):
        self.sdl_rect.x = x
        self.sdl_rect.y = y
        self.sdl_rect.w = w
        self.sdl_rect.h = h
        if self.fill_color:
            sdl.SDL_SetRenderDrawColor(self.renderer, *self.fill_color)
            sdl.SDL_RenderFillRect(self.renderer, self.sdl_rect)
        if self.stroke_color:
            sdl.SDL_SetRenderDrawColor(self.renderer, *self.stroke_color)
            sdl.SDL_RenderDrawRect(self.renderer, self.sdl_rect)

    def circle(self, x, y, r):
        n = len(self.sdl_points) - 1
        for i in range(n + 1):
            self.sdl_points[i].x = math.floor(x + r * math.cos(math.tau * i / n))
            self.sdl_points[i].y = math.floor(y + r * math.sin(math.tau * i / n))

        sdl.SDL_RenderDrawLines(self.renderer, self.sdl_points, n + 1)

    def ellipse(self, x, y, w, h):
        pass

    def sprite(self, image, x, y):
        pass

    def text(self, txt, x, y):
        return vec2()
