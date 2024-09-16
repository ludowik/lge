#include <math.h>

#include "simplexnoise.h"
#include "simplextextures.h"


// 2D Marble Noise: x-axis.
float marble_noise_2d( const float octaves, const float persistence, const float scale, const float x, const float y ) {
    return cosf( x * scale + octave_noise_2d(octaves, persistence, scale / 3, x, y) );
}


// 3D Marble Noise: x-axis.
float marble_noise_3d( const float octaves, const float persistence, const float scale, const float x, const float y, const float z ) {
    return cosf( x * scale + octave_noise_3d(octaves, persistence, scale / 3, x, y, z) );
}


// 4D Marble Noise: x-axis.
float marble_noise_4d( const float octaves, const float persistence, const float scale, const float x, const float y, const float z, const float w ) {
    return cosf( x * scale + octave_noise_4d(octaves, persistence, scale / 3, x, y, z, w) );
}

