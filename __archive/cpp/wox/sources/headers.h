#pragma once

#define TRACK_MEMORY

#ifdef _WIN32
#include <SDKDDKVer.h>
#include <stdio.h>
#include <tchar.h>
#define OPENGL
#include <GL/glew.h>
#include <SDL.h>
#include <SDL_image.h>

#elif __APPLE__
#define GL3_PROTOTYPES
#include <OpenGL/gl3.h>
#include <CoreFoundation/CoreFoundation.h>
#include <SDL2/SDL.h>
#include <SDL2_image/SDL_image.h>

#endif

#ifndef BUFFER_OFFSET
#define BUFFER_OFFSET(offset) ((char*)NULL + (offset))
#endif

// Includes GLM
#include <glm/glm.hpp>
#include <glm/gtx/transform.hpp>
#include <glm/gtc/type_ptr.hpp>

using namespace glm;
using namespace std;

// Système
#include <iostream>
#include <sstream>
#include <fstream>
#include <string>
#include <list>
#include <vector>
#include <map>
#include <thread>

#define foreach(c, o, cs, l) \
    cs::iterator it = (l).begin(); \
    for ( c* o = (l).size() > 0 ? *it : NULL; o && it != (l).end() ; ++it, o = it != (l).end() ? *it : NULL )

#define pi 3.1415927f

#define DEGREE_MAX 360.
#define RADIAN_MAX 200.

#define deg2rad(deg) ( deg * pi / 180. )

#define minmax(val,min,max) ( (val) < (min) ? (min) : ( (val) > (max) ? (max) : (val) ) )

#define min(val,min) ( (val) < (min) ? (val) : (min) )
#define max(val,max) ( (val) > (max) ? (val) : (max) )

#include "os.h"
#include "memory.h"
#include "tools.h"
#include "maths.h"
#include "random.h"
#include "noise.h"
#include "simplexnoise.h"
#include "variable.h"
#include "opengl.h"
#include "property.h"
#include "array.h"
#include "threads.h"

#pragma warning ( disable: 4244 4305 )
