from src.libc.lib import *
from src.libc.sdl import sdl

import os, glm


opengl_cdef = read('src/libc/opengl.h')

if os.name == 'nt':
    gl_name = 'OpenGL32'
else:
    gl_name = 'OpenGL'

gl_lib, gl_ffi = load_lib(gl_name, opengl_cdef)

class GL:
    def __init__(self):
        self.lib = type('lib', (), {})

        for name in dir(gl_lib):
            if not name.startswith('gl'):
                const = getattr(gl_lib, name)
                setattr(self, name, const)

        self.ptr_int = gl_ffi.new('GLuint[1]')
        self.ptr_float = gl_ffi.new('GLfloat[16]')


    def get_proc_adresses(self):
        for name in dir(gl_lib):
            if name.startswith('gl'):
                func = gl_ffi.cast('PFN_' + name, sdl.SDL_GL_GetProcAddress(gl_ffi.char(name)))
                setattr(self.lib, name, func)
                if not getattr(self, name, None):
                    setattr(self, name, GL.glFunc(func, name))

    @classmethod
    def glCheckError(cls, name):
        error = gl.lib.glGetError()
        if error != gl.GL_NO_ERROR:
            error_name = 'OpenGL Error {} : 0x{:02x}'.format(name, error)
            print(error_name)
            raise NameError(error_name)

    def glFunc(func, name=None):
        def wrapper(*args, **kwargs):
            res = func(*args, **kwargs)
            GL.glCheckError(name or func.__name__)
            return res
        return wrapper

    @glFunc
    def glGenBuffer(self):
        self.lib.glGenBuffers(1, self.ptr_int)
        return self.ptr_int[0]


    @glFunc
    def glDeleteBuffer(self, buffer):
        self.ptr_int[0] = buffer
        self.lib.glDeleteBuffers(1, self.ptr_int)


    @glFunc
    def glGenTexture(self):
        self.lib.glGenTextures(1, self.ptr_int)
        return self.ptr_int[0]


    @glFunc
    def glDeleteTexture(self, buffer):
        self.ptr_int[0] = buffer
        self.lib.glDeleteTextures(1, self.ptr_int)


    @glFunc
    def glGetAttribLocation(self, program, name):
        location = self.lib.glGetAttribLocation(program, gl_ffi.char(name))
        return location

    @glFunc
    def glGetUniformLocation(self, program, name):
        location = self.lib.glGetUniformLocation(program, gl_ffi.char(name))
        return location

    @glFunc
    def glUniform2fv(self, location, count, data1, data2):
        self.ptr_float[0] = data1
        self.ptr_float[1] = data2
        self.lib.glUniform2fv(location, count, self.ptr_float)

    @glFunc
    def glUniform4fv(self, location, count, data1, data2, data3, data4):
        self.ptr_float[0] = data1
        self.ptr_float[1] = data2
        self.ptr_float[2] = data3
        self.ptr_float[3] = data4
        self.lib.glUniform4fv(location, count, self.ptr_float)

    @glFunc
    def glUniformMatrix4fv(self, uniformMatrix, count, transpose, matrix):
        value_ptr = glm.value_ptr(matrix)
        for i in range(16):
            self.ptr_float[i] = value_ptr[i]
        self.lib.glUniformMatrix4fv(uniformMatrix, count, transpose, self.ptr_float)


gl = GL()
