#pragma language glsl3

uniform mat4 matrixPV;
uniform mat4 matrixModel;

varying vec3 fragmentPos;

uniform highp float useColor;
//attribute vec4 VertexColor;
//varying vec4 color;

uniform highp float useTexCoord;
//attribute vec4 VertexTexCoord;
varying vec4 texCoord;

uniform highp float useNormal;
attribute vec3 VertexNormal;
varying vec3 normal;

uniform highp float useInstanced;
attribute vec3 InstancePosition;
attribute vec3 InstanceScale;

vec4 position(mat4 transform_projection, vec4 vertex_position) {
    vec4 vp = vertex_position;
    if (useInstanced == 1.) {
        vp = vp * vec4(InstanceScale, 1.) + vec4(InstancePosition, 0.);
    }

    texCoord = VertexTexCoord;

    mat4 inv = inverse(matrixModel);
    normal = mat3(transpose(inv)) * VertexNormal;

    fragmentPos = vec3(matrixModel * vp);

    return transform_projection * vp;
}
