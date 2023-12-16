#pragma language glsl3

float border = 0.;

uniform highp float useColor;
uniform highp float useTexCoord;
uniform highp float useNormal;
uniform highp float useLight;
uniform highp float useLightAmbient;
uniform highp float useLightDiffuse;

uniform highp float useInstanced;

uniform vec3 cameraToLight;

varying vec3 normal;
vec3 normalNormalize;

struct Light {    
    vec4 lightColor;
    
    float ambientStrength;
    float diffuseStrength;
};

vec4 ambient(Light light) {
    return light.ambientStrength * light.lightColor;
}

vec4 diffuse(Light light) {
    float diff = max(dot(normalNormalize, cameraToLight), 0.0);    
    return light.diffuseStrength * diff * light.lightColor;
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    if (border == 0.) {
        vec4 finalColor = vec4(1., 1., 1., 1.);

        if (useColor == 1.) {
            finalColor = color;
        }
        
        if (useTexCoord == 1.) {
            vec4 texturecolor = Texel(tex, texture_coords);
            finalColor = texturecolor * finalColor;
        }
        
        if (useLight == 1.) {
            normalNormalize = normalize(normal);

            vec4 composition;

            Light light = Light(vec4(.8, .6, .6, 1.), .8, .8);
            if (useLightAmbient == 1.) {
                composition += ambient(light);
            }

            if (useLightDiffuse == 1. && useNormal == 1.) {
               composition += diffuse(light);
            }

            finalColor = vec4(composition.xyz, 1.) * finalColor;
        }

        return finalColor;
    }

    if (texture_coords.x >= 0.01 && texture_coords.x <= 0.99 && texture_coords.y >= 0.01 && texture_coords.y <= 0.99) discard;    
    float v = 1.;
    return vec4(v, v, v, 1.);
}
