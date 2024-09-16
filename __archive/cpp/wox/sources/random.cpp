#include "headers.h"
#include "random.h"

unsigned int g_r = 0;
unsigned int g_seed = 0;

#define FACTOR 16807

void srand(int x, int y, int z) {
    g_seed = ( z * FACTOR + x ) * FACTOR + y;
    srand(g_seed);
}

void srand(vec3 seed) {
    srand((int)seed.x, (int)seed.y, (int)seed.z);
}

int my_random() {
    return rand();
}

int rand(int max) {
    return my_random() % max;
}

int rand(int min, int max) {
    return min + rand(max-min);
}

vec3 noise3() {
    static float n = 0.05f;
    float noise_x = frand(-n, n);
    float noise_y = frand(-n, n);
    float noise_z = frand(-n, n);
    return vec3(noise_x, noise_y, noise_z);
}

vec3 noise3(vec3 seed) {
    srand(seed);
    return noise3();
}

float frand(float max) {
    return max * ( (float)rand(RAND_MAX) / RAND_MAX );
}

float frand(float min, float max) {
    return min + frand(max - min);
}

bool toss() {
    return rand() % 2 ? true : false;
}
