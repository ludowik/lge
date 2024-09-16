// Version du GLSL
#version 150 core

// Uniform
uniform sampler2D texture;

// Entrée
in vec2 coordTexture;

// Sortie
out vec4 out_Color;

// Fonction main
void main() {
    // Couleur du pixel
    out_Color = texture(texture, coordTexture);
}
