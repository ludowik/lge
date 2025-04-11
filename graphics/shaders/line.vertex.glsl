uniform highp mat4 matrixPV;
uniform highp mat4 matrixModel;

uniform highp float useInstanced;

uniform highp float strokeSize;
uniform highp vec4 strokeColor;

layout(location = 10) in vec3 InstancePosition;
layout(location = 11) in vec3 InstanceScale;
layout(location = 12) in vec4 InstanceColor;

varying vec3 vertexPos;
varying vec3 fragmentPos;
varying vec4 color;
varying vec4 vertexProjection;

flat out int instanceID;

vec4 position(mat4 , vec4 ) {
    vec4 vp = vec4(VertexPosition.xyz, 1.);

    vp = vp * vec4(InstanceScale, 1.) + vec4(InstancePosition, 0.);
    vp += normalize(vec4(-InstanceScale.y, InstanceScale.x, 0., 0.) * VertexTexCoord.x) * (strokeSize / 2.);

    vp.y = love_ScreenSize.y-vp.y;

    color = InstanceColor;
    instanceID = gl_InstanceID;

    vertexPos = vec3(vp);
    fragmentPos = vec3(matrixModel * vp);

    vertexProjection = matrixPV * matrixModel * vp;
    return vertexProjection;
}
