#include "headers.h"
#include "noise.h"

float noise(float x, float y, float n) {
    return scaled_raw_noise_2d(0., n, x, y);
}

float noise(float x, float y) {
    return noise(x, y, 1.);
}

float height_map(float x, float y) {
    int n = 128;
    
    int xx = x;
    int yy = y;
    
    int xo = xx % n;
    int yo = yy % n;
    
    int nix = xx - xo;
    int niy = yy - yo;

    float ha = noise(nix    , niy    );
    float hb = noise(nix + n, niy    );
    float hc = noise(nix + n, niy + n);
    float hd = noise(nix    , niy + n);
    
    float he = interpolation(ha, hb, n, xo);
    float hf = interpolation(hd, hc, n, xo);
    
    float hg = interpolation(he, hf, n, yo);
    
    return hg * 40.;
}
