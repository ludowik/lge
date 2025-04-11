#pragma language glsl3

// uniforms
uniform highp float iTime;
uniform highp float SHAPE_SIZE;
uniform highp float TIMESCALE;
uniform highp float SMOOTHNESS;

uniform highp float z;
uniform vec3 CAMERA_POS_WORLD;

// variables
uniform int MAX_STEPS;

uniform highp float MAX_DIST;
uniform highp float SURF_DIST;

// shapes
float sdSphere(vec3 p, vec3 sp, float r) {
    return length(sp - p) - r;
}

// boolean operator
float shapeUnion(float a, float b) {
    return min(a, b);
}

float shapeSmoothUnion(float d1, float d2, float k) {
    float h = clamp(0.5 + 0.5 * (d2 - d1) / k, 0., 1.);
    return mix(d2, d1, h) - k * h * (1. - h);
}

float shapeSubstraction(float a, float b) {
    return max(-a, b);
}

float shapeSmoothSubstraction(float d1, float d2, float k) {
    float h = clamp(0.5 - 0.5 * (d2 + d1) / k, 0., 1.);
    return mix(d2, -d1, h) + k * h * (1. - h);
}

float shapeIntersection(float a, float b) {
    return max(a, b);
}

float smoothIntersection(float d1, float d2, float k) {
    float h = clamp(0.5 - 0.5 * (d2 - d1) / k, 0., 1.);
    return mix(d2, d1, h) + k * h * (1. - h);
}

float GetDist(vec3 p) {
    float t = iTime * TIMESCALE;

    vec3 shape1_pos = vec3(sin(t * +0.337), abs(sin(t * +0.428)), sin(t * -0.989));
    vec3 shape2_pos = vec3(sin(t * -0.214), abs(sin(t * -0.725)), sin(t * +0.56));
    vec3 shape3_pos = vec3(sin(t * -0.671), abs(sin(t * +0.272)), sin(t * +0.773));

    vec3 movescale = vec3(0.2, 3.0, 0.2);

    float sp1 = sdSphere(p, shape1_pos * movescale, SHAPE_SIZE * 0.5);
    float sp2 = sdSphere(p, shape2_pos * movescale, SHAPE_SIZE * 0.75);
    float sp3 = sdSphere(p, shape3_pos * movescale, SHAPE_SIZE * 1.);
    
    float sp4 = sdSphere(p, vec3(0.), 0.8);

    float spheres = shapeSmoothUnion(sp1, sp2, SMOOTHNESS);
    spheres = shapeSmoothUnion(spheres, sp3, SMOOTHNESS);
    spheres = shapeSmoothUnion(spheres, sp4, SMOOTHNESS);

    spheres = shapeUnion(spheres, (p.y + 1.));

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
    lightPos.xz += vec2(sin(iTime), cos(iTime)) * 2.;

    vec3 l = normalize(lightPos - p);
    vec3 n = GetNormal(p);

    float dif = clamp(dot(n, l), 0., 1.);

    float d = RayMarch(p + n * SURF_DIST * 2., l);

    if (d<length(lightPos - p)) dif *= 0.1;

    return dif;
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec3 ws_pixels_pos = vec3((screen_coords * 2. - love_ScreenSize.xy) / love_ScreenSize.x, 1.);
        
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
