typedef struct ALCdevice_struct ALCdevice;
typedef struct ALCcontext_struct ALCcontext;

typedef char ALCboolean;
typedef char ALCchar;
typedef char ALCbyte;
typedef unsigned char ALCubyte;
typedef short ALCshort;
typedef unsigned short ALCushort;
typedef int ALCint;
typedef unsigned int ALCuint;
typedef int ALCsizei;
typedef int ALCenum;
typedef float ALCfloat;
typedef double ALCdouble;
typedef void ALCvoid;

ALCdevice* alcOpenDevice(const ALCchar *devicename);
ALCboolean alcCloseDevice(ALCdevice *device);

ALCcontext* alcCreateContext(ALCdevice *device, const ALCint* attrlist);
void alcDestroyContext(ALCcontext *context);

ALCboolean alcMakeContextCurrent(ALCcontext *context);

#define ALC_TRUE 1
#define AL_FALSE 0

#define AL_POSITION 0x1004
#define AL_VELOCITY 0x1006
#define AL_ORIENTATION 0x100F
#define AL_GAIN 0x100A
#define AL_PITCH 0x1003
#define AL_LOOPING 0x1007

#define AL_BUFFER 0x1009

typedef char ALboolean;
typedef char ALchar;
typedef char ALbyte;
typedef unsigned char ALubyte;
typedef short ALshort;
typedef unsigned short ALushort;
typedef int ALint;
typedef unsigned int ALuint;
typedef int ALsizei;
typedef int ALenum;
typedef float ALfloat;
typedef double ALdouble;
typedef void ALvoid;

void alListener3f(ALenum param, ALfloat value1, ALfloat value2, ALfloat value3);
void alListenerfv(ALenum param, const ALfloat* values);

void alGenSources(ALsizei n, ALuint* sources);
void alDeleteSources(ALsizei n, const ALuint* sources);

void alSourcei(ALuint sid, ALenum param, ALint value);
void alSourcef(ALuint sid, ALenum param, ALfloat value);
void alSource3f(ALuint sid, ALenum param, ALfloat value1, ALfloat value2, ALfloat value3);

void alSourcePlay(ALuint sid);
void alSourceStop(ALuint sid);
void alSourceRewind(ALuint sid);
void alSourcePause(ALuint sid);
