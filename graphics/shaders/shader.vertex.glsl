uniform highp mat4 matrixPV;
uniform highp mat4 matrixModel;

uniform highp vec4 strokeColor;
uniform highp vec4 fillColor;

varying vec3 vertexPos;
varying vec3 fragmentPos;

varying vec4 vertexProjection;

uniform highp float useColor;
// attribute vec4 VertexColor;
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
flat out int instanceID;

uniform highp float useHeightMap;
uniform highp float computeHeight;
uniform highp float frequence1;
uniform highp float frequence2;
uniform highp float frequence3;
uniform highp float octave1;
uniform highp float octave2;
uniform highp float octave3;
uniform vec3 translation;

uniform Image tex;
uniform highp float texWidth;
uniform highp float texHeight;

uniform highp float elapsedTime;

float noise(vec2 v) {
    return snoise(v / 43.65);
}

vec4 position(mat4 , vec4 ) {
    vec4 vp = vec4(VertexPosition.xyz, 1.);
    vec3 vn = VertexNormal;

    color = fillColor * VertexColor;

    if (useInstanced == 1.) {
        vp = vp * vec4(InstanceScale, 1.) + vec4(InstancePosition, 0.);
        color *= InstanceColor;
        instanceID = gl_InstanceID;
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

    } else if (computeHeight == 1.) {
        float height =
            noise(vec3(vp.xyz + translation).xz / frequence1) * octave1 +
            noise(vec3(vp.xyz + translation).xz / frequence2) * octave2 +
            noise(vec3(vp.xyz + translation).xz / frequence3) * octave3;

        vp.y += height * 25.;
    
        float ya = noise(vec3(vp.xyz + translation).xz) * 10.;
        float yb = noise(vec3(vp.xyz + translation).xz + vec2(1., 0.)) * 10.;
        float yc = noise(vec3(vp.xyz + translation).xz + vec2(0., 1.)) * 10.;
        
        vec3 v1 = vec3(1., yb-ya, 0.);
        vec3 v2 = vec3(0., yc-ya, 1.);
        
        vn = normalize(cross(v1, v2));
    }

    texCoord = VertexTexCoord;

    mat4 inv = inverse(matrixModel);
    normal = normalize(mat3(transpose(inv)) * vn);

    vertexPos = vec3(vp);
    fragmentPos = vec3(matrixModel * vp);

    vertexProjection = matrixPV * matrixModel * vp;
    return vertexProjection;
}
