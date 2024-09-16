#version 150 core

// uniform
uniform mat4 modelviewProjection;

// out
in vec3 in_Vertex;
in vec3 in_Normal;
in vec4 in_Color;

// out
out vec3 normal;
out vec4 color;

void main() {
    // Position finale du vertex en 3D
    gl_Position = modelviewProjection * vec4(in_Vertex, 1.0);
    
    // Envoi des données au Fragment Shader
    float l = length(gl_Position);
    if ( l <= 100 ) {
        float r = l / 100;
        float t = 0.5;
        
        color = vec4(t, t, t, 1) * ( 1 - r ) + in_Color * r;
    } else {
        color = in_Color;
    }

    normal = in_Normal;
}
