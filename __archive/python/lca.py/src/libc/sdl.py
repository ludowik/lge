from src.libc.lib import *
import os

sdl_cdef = read('src/libc/sdl.h')

projectDirectory = os.getcwd()

# sdl, sdl_ffi = load_lib(projectDirectory + '/../../Libraries/bin/64/SDL2', sdl_cdef)
# sdl_image,sdl_image_ffi = load_lib(projectDirectory + '/../../Libraries/bin/64/SDL2_image', sdl_cdef)

sdl, sdl_ffi = load_lib('SDL2', sdl_cdef)
sdl_image,sdl_image_ffi = load_lib('SDL2_image', sdl_cdef)
