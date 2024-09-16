from src.libc.lib import *
import os

if os.name == 'nt':
    projectDirectory = os.getcwd()
    include_dirs = projectDirectory + '/../../Libraries/freetype/freetype/include'
    link = projectDirectory + '/../../libraries/bin/freetype.lib'
else:
    include_dirs = '/Library/Frameworks/FreeType.framework/Headers'
    link = '/Library/Frameworks/FreeType.framework/FreeType'

ft_ffi = FFI()

src_time = os.path.getmtime('src/libc/freetype.c')
lib_time = (
        os.path.exists('bin/ft.cp37-win_amd64.pyd') and os.path.getmtime('bin/ft.cp37-win_amd64.pyd') or
        os.path.exists('bin/ft.cpython-37m-darwin.so') and os.path.getmtime('bin/ft.cpython-37m-darwin.so')
)

if src_time > lib_time:
    print('recompile')

    ft_ffi.set_source("bin.ft",
                      source=io.open('src/libc/freetype.c').read(),
                      include_dirs=[include_dirs],
                      extra_compile_args=[],
                      extra_link_args=[link])

    ft_ffi.cdef("""
        typedef void* Handle;
        typedef unsigned char GLubyte;
        
        typedef struct {
            int w;
            int h;
            int size;
            GLubyte* pixels;
            struct {
                int BytesPerPixel;
                unsigned int Rmask;
            } format;
        } Glyph;
        
        Handle init_module();
        void release_module(Handle lib);
        
        Handle load_font(Handle lib, const char* font_name, int font_size);
        void release_font(Handle face);
        
        Glyph load_text(Handle face, const char* text);
        void release_text(Glyph glyph);
    """)

    ft_ffi.compile(verbose=True)

import bin.ft

ft = bin.ft.lib
