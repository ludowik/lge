#pragma language glsl3

uniform mat4 matrixPV;
uniform mat4 matrixModel;

uniform vec4 strokeColor;
uniform vec4 fillColor;

varying vec3 vertexPos;
varying vec3 fragmentPos;

varying vec4 vertexProjection;

uniform highp float useColor;
//attribute vec4 VertexColor;
varying vec4 color;

uniform highp float useTexCoord;
//attribute vec4 VertexTexCoord;
varying vec4 texCoord;

uniform highp float useNormal;
attribute vec3 VertexNormal;
varying vec3 normal;

uniform highp float useInstanced;
attribute vec3 InstancePosition;
attribute vec3 InstanceScale;
attribute vec4 InstanceColor;

uniform highp float useHeightMap;

uniform Image tex;
uniform float texWidth;
uniform float texHeight;

uniform float elapsedTime;

vec4 position(mat4 , vec4 ) {
    vec4 vp = vec4(VertexPosition.xyz, 1.);
    vec3 vn = VertexNormal;

    color = fillColor * VertexColor;

    if (useInstanced == 1.) {
        vp = vp * vec4(InstanceScale, 1.) + vec4(InstancePosition, 0.);
        color *= InstanceColor;
    }

    if (useHeightMap == 1.) {
        vec2 vp2 = vp.xz + ceil(abs(vp.xz)/texWidth)*texWidth;

        vec4 texturecolor = Texel(tex, mod(vp2, texWidth)/texWidth);
        vp.y = texturecolor.r;
        
        vec4 tc1 = Texel(tex, mod(vp2-vec2(1., 1.), texWidth) / texWidth);
        vec4 tc2 = Texel(tex, mod(vp2+vec2(1., 0.), texWidth) / texWidth);
        vec4 tc3 = Texel(tex, mod(vp2+vec2(0., 1.), texWidth) / texWidth);

        vec3 v1 = vec3(1., tc2.r-tc1.r, 0.);
        vec3 v2 = vec3(0., tc3.r-tc1.r, 1.);

        vn = normalize(cross(v1, v2));

        // vn += noise3(vertexPos);
    }

    texCoord = VertexTexCoord;

    mat4 inv = inverse(matrixModel);
    normal = normalize(mat3(transpose(inv)) * vn);

    vertexPos = vec3(vp);
    fragmentPos = vec3(matrixModel * vp);

    vertexProjection = matrixPV * matrixModel * vp;
    return vertexProjection;
}
