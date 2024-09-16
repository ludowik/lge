import cffi

def FFI():
    ffi = cffi.FFI()

    def char(txt):
        return ffi.new('char[]', txt.encode('ascii'))

    ffi.char = char
    return ffi
