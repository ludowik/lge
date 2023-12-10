#pragma language glsl3

float border = 0.;

uniform float useColor;
uniform float useTexCoord;
uniform float useNormal;
uniform float useInstanced;

varying vec4 normal;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    if (border == 0.) {
        vec4 finalColor = vec4(1., 1., 1., 1.);

        if (useColor == 1.) {
            finalColor = finalColor * color;
        }
        
        if (useTexCoord == 1.) {
            vec4 texturecolor = Texel(tex, texture_coords);
            finalColor = finalColor * texturecolor;
        }

        if (useNormal == 1.) {                
            finalColor = finalColor * normal;
        }        

        return finalColor;
    }

    if (texture_coords.x >= 0.01 && texture_coords.x <= 0.99 && texture_coords.y >= 0.01 && texture_coords.y <= 0.99) discard;    
    float v = 1.;
    return vec4(v, v, v, 1.);
}
