#pragma language glsl3

// uniforms
uniform float TIME = 0.;
uniform float TIMESCALE = 1.;
uniform float SHAPE_SIZE = 0.5;
uniform float SMOOTHNESS = 0.5;

uniform float z = 5.;
uniform vec3 CAMERA_POS_WORLD = vec3(0., 2., -5.);

// variables
uniform int MAX_STEPS = 100;

uniform float MAX_DIST = 100.;
uniform float SURF_DIST = 0.01;

// shapes
float sdSphere(vec3 p, vec3 sp, float r) {
    return length(sp - p) - r;
}

// boolean operator
float _union(float a, float b) {
    return min(a, b);
}

float smoothUnion(float d1, float d2, float k) {
    float h = clamp(0.5 + 0.5 * (d2 - d1) / k, 0., 1.);
    return mix(d2, d1, h) - k * h * (1. - h);
}

float _substraction(float a, float b) {
    return max(-a, b);
}

float smoothSubstraction(float d1, float d2, float k) {
    float h = clamp(0.5 - 0.5 * (d2 + d1) / k, 0., 1.);
    return mix(d2, -d1, h) + k * h * (1. - h);
}

float _intersection(float a, float b) {
    return max(a, b);
}

float smoothIntersection(float d1, float d2, float k) {
    float h = clamp(0.5 - 0.5 * (d2 - d1) / k, 0., 1.);
    return mix(d2, d1, h) + k * h * (1. - h);
}

float GetDist(vec3 p) {
    float t = TIME * TIMESCALE;

    vec3 shape1_pos = vec3(sin(t * +0.337), abs(sin(t * +0.428)), sin(t * -0.989));
    vec3 shape2_pos = vec3(sin(t * -0.214), abs(sin(t * -0.725)), sin(t * +0.56));
    vec3 shape3_pos = vec3(sin(t * -0.671), abs(sin(t * +0.272)), sin(t * +0.773));

    vec3 movescale = vec3(0.2, 3.0, 0.2);

    float sp1 = sdSphere(p, shape1_pos * movescale, SHAPE_SIZE * 0.5);
    float sp2 = sdSphere(p, shape2_pos * movescale, SHAPE_SIZE * 0.75);
    float sp3 = sdSphere(p, shape3_pos * movescale, SHAPE_SIZE * 1);
    
    float sp4 = sdSphere(p, vec3(0.), 0.8);

    float spheres = smoothUnion(sp1, sp2, SMOOTHNESS);
    spheres = smoothUnion(spheres, sp3, SMOOTHNESS);
    spheres = smoothUnion(spheres, sp4, SMOOTHNESS);

    spheres = _union(spheres, (p.y+1));

    return spheres;
}

vec3 GetNormal(vec3 p) {
    float d = GetDist(p);
    vec2 e = vec2(0.01, 0.0);
    vec3 n = d - vec3(
        GetDist(p-e.xyy),
        GetDist(p-e.yxy),
        GetDist(p-e.yyx));
    return normalize(n);
}

float RayMarch(vec3 ro, vec3 rd) {
    float d = 0.;
    for (int i=0; i<MAX_STEPS; i++) {
        vec3 p = ro + rd * d;
        float dS = GetDist(p);
        d += dS;
        if (dS < SURF_DIST || d > MAX_DIST) break;
    }
    return d;
}

float GetLight(vec3 p) {
    vec3 lightPos = vec3(0., 5., -1.);
    lightPos.xz += vec2(sin(TIME), cos(TIME)) * 2.;

    vec3 l = normalize(lightPos - p);
    vec3 n = GetNormal(p);

    float dif = clamp(dot(n, l), 0., 1.);

    float d = RayMarch(p + n * SURF_DIST * 2., l);

    if (d<length(lightPos - p)) dif *= 0.1;

    return dif;
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec3 ws_pixels_pos = vec3((screen_coords * 2 - love_ScreenSize.xy) / love_ScreenSize.x, 1.);
    
    ws_pixels_pos.y *= -1;
    
    vec3 ro = vec3(CAMERA_POS_WORLD.xy, -z);
    vec3 rd = normalize(ws_pixels_pos);

    float d = RayMarch(ro, rd);
    float ALPHA = step(d, MAX_DIST);

    vec3 p = ro + rd * d;
    vec3 n = GetNormal(p);

    float h = p.y;
    h = 1. - (h - 2.) * 0.1;

    float l = GetLight(p);
    vec3 ALBEDO = vec3(l * h);

    return vec4(color.xyz*ALBEDO, ALPHA);
}
