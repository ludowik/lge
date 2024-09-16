from src.libc.lib import *
import os

openal_cdef = read('libc/openal.h')

if os.name == 'nt':
    al_name = 'OpenAL32'
else:
    al_name = 'OpenAL'

al, al_ffi = load_lib(al_name, openal_cdef)

device = al.alcOpenDevice(al_ffi.NULL)
context = al.alcCreateContext(device, al_ffi.NULL)
al.alcMakeContextCurrent(context)

al.alListener3f(al.AL_POSITION, 0, 0, 1)
al.alListener3f(al.AL_VELOCITY, 0, 0, 0)

listener = al_ffi.new('float[6]', [0, 0, 1, 0, 1, 0])
al.alListenerfv(al.AL_ORIENTATION, listener)

uint_ptr = al_ffi.new('ALuint[1]')
al.alGenSources(1, uint_ptr)
source = uint_ptr[0]

al.alSourcef(source, al.AL_GAIN, 1)
al.alSourcef(source, al.AL_PITCH, 1)
al.alSourcei(source, al.AL_LOOPING, al.AL_FALSE)

al.alSource3f(source, al.AL_POSITION, 0, 0, 0)
al.alSource3f(source, al.AL_VELOCITY, 0, 0, 0)

al.alSourceStop(source)
al.alSourcei(source, al.AL_BUFFER, 0)
al.alDeleteSources(1, uint_ptr)

al.alcMakeContextCurrent(al_ffi.NULL)

al.alcDestroyContext(context)

al.alcCloseDevice(device)
