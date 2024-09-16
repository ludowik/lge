import src.engine.config as config

from src.libc.sdl import sdl, sdl_ffi, sdl_image
from src.libc.opengl import gl, gl_ffi
from src.libc.freetype import ft, ft_ffi


class Texture(object):
    def __init__(self, file_name):
        surface = sdl_ffi.NULL
        texture_id = -1

    def release(self):
        if config.mode != 'gl':
            return

        if gl.glIsTexture(self.texture_id):
            gl.glDeleteTexture(self.texture_id)
            texture_id = -1

    def make_texture(self):
        if config.mode != 'gl':
            return

        self.texture_id = gl.glGenTexture()
        gl.glBindTexture(gl.GL_TEXTURE_2D, self.texture_id)

        internalFormat = gl.GL_RGBA
        formatRGB = gl.GL_RGBA

        if self.surface.format.BytesPerPixel == 1:
            internalFormat = gl.GL_ALPHA
            formatRGB = gl.GL_ALPHA

        elif self.surface.format.BytesPerPixel == 3:
            internalFormat = gl.GL_RGB
            if self.surface.format.Rmask == 0xff:
                formatRGB = gl.GL_RGB
            else:
                formatRGB = gl.GL_BGR

        elif self.surface.format.BytesPerPixel == 4:
            internalFormat = gl.GL_RGBA
            if self.surface.format.Rmask == 0xff:
                formatRGB = gl.GL_RGBA
            else:
                formatRGB = gl.GL_BGRA

        gl.glTexImage2D(gl.GL_TEXTURE_2D,
                        0,  # level
                        internalFormat,
                        self.surface.w, self.surface.h,
                        0,  # border
                        formatRGB, gl.GL_UNSIGNED_BYTE,
                        self.surface.pixels)

        gl.glPixelStorei(gl.GL_UNPACK_ALIGNMENT, 1)

        gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MIN_FILTER, gl.GL_LINEAR)
        gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAG_FILTER, gl.GL_LINEAR)

        gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_WRAP_S, gl.GL_CLAMP_TO_EDGE)
        gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_WRAP_T, gl.GL_CLAMP_TO_EDGE)

        gl.glBindTexture(gl.GL_TEXTURE_2D, 0)

    def use(self):
        if config.mode != 'gl':
            return
        gl.glBindTexture(gl.GL_TEXTURE_2D, self.texture_id)
        gl.glActiveTexture(gl.GL_TEXTURE0)

    def unuse(self):
        if config.mode != 'gl':
            return
        gl.glBindTexture(gl.GL_TEXTURE_2D, 0)


class Image(Texture):
    def __init__(self, file_name):
        self.surface = sdl_image.IMG_Load(sdl_ffi.char(file_name))
        if self.surface == sdl_ffi.NULL:
            print(gl_ffi.string(sdl.SDL_GetError()))
            return

        self.make_texture()


class Text(Texture):
    def __init__(self, face, txt):
        self.surface = ft.load_text(face, ft_ffi.char(txt))
        self.make_texture()

    def __del__(self):
        Texture.release(self)
        ft.release_text(self.surface)
