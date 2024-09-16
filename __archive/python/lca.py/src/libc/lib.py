from ctypes.util import find_library
from src.libc.ffi import FFI
import io


def read(file_name):
    return io.open(file_name).read()


def load_lib(lib_name, cdef):
    ffi = FFI()
    ffi.cdef(cdef)

    lib_path = find_library(lib_name)
    lib = ffi.dlopen(lib_path)

    return lib, ffi
