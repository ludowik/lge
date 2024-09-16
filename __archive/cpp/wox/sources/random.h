#pragma once

void srand(int x, int y, int z);
void srand(vec3 seed);

int rand(int max);
int rand(int min, int max);

vec3 noise3();
vec3 noise3(vec3);

float frand(float max);
float frand(float min, float max);

bool toss();
