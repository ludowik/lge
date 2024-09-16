#version 150 core

// in
in vec4 color;
in vec3 normal;

// out
out vec4 out_Color;

// uniform
uniform vec3 light_direction;
uniform vec3 light_ambient_color;

uniform float light_ambient_intensity;

// Fonction main
void main() {
    if ( light_ambient_intensity != 0.0 ) {
        float light_diffuse_intensity = max(0.0, dot(normal, light_direction));
        out_Color = color * vec4(light_ambient_color * ( light_ambient_intensity + light_diffuse_intensity ), 1.0);
    } else {
        out_Color = color;
    }
}
