#pragma language glsl3

uniform mat4 matrixPV;
uniform mat4 matrixModel;

uniform float useColor;
//attribute vec4 VertexColor;
//varying vec4 color;

uniform float useTexCoord;
//attribute vec4 VertexTexCoord;
varying vec4 texCoord;

uniform float useNormal;
attribute vec3 VertexNormal;
varying vec3 normal;

uniform float useInstanced;
attribute vec3 InstancePosition;
attribute vec3 InstanceScale;

vec4 position(mat4 transform_projection, vec4 vertex_position) {
    vec4 vp = vertex_position;
    if (useInstanced == 1.) {
        vp = vp * vec4(InstanceScale, 1.) + vec4(InstancePosition, 0.);
    }

    texCoord = VertexTexCoord;
    normal = mat3(transpose(inverse(matrixModel))) * VertexNormal;

    return transform_projection * vp;
}
