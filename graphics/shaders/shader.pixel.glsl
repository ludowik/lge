uniform float border = 0.;

uniform highp float useColor;
uniform highp float useTexCoord;
uniform highp float useNormal;
uniform highp float useLight;
uniform highp float useLightAmbient;
uniform highp float useLightDiffuse;
uniform highp float useLightSpecular;
uniform highp float useMaterial;
uniform highp float useRelief;

uniform highp float useInstanced;

uniform mat4 matrixPV;
uniform mat4 matrixModel;

uniform vec4 strokeColor;
uniform vec4 fillColor;

uniform vec3 cameraPos;

varying vec3 vertexPos;
varying vec3 fragmentPos;
varying vec4 color;
varying vec4 texCoord;
varying vec3 normal;
vec3 nn;
varying float instanceID;
varying vec4 vertexProjection;

uniform float param1;
uniform float param2;
uniform float param3;

struct Light {
    float lightType;

    vec4 lightColor;
    vec3 lightPos;
    
    float ambientStrength;
    float diffuseStrength;
    float specularStrength;
};

uniform int lightsCount;
uniform Light lights[32];

struct Material {
    float ambientStrength;
    float diffuseStrength;
    float specularStrength;
    
    float shininess;
    
    float alpha;
};
uniform Material materials[1];
Material material = materials[0];

vec4 ambient(Light light) {
    return light.ambientStrength * light.lightColor;
}

vec4 diffuse(Light light, vec3 normal) {
    vec3 lightDir = normalize(light.lightPos - fragmentPos);
    //vec3 cameraToLight = normalize(light.lightPos - cameraPos);
    float diff = max(dot(normal, lightDir), 0.0);    
    return light.diffuseStrength * light.lightColor * diff;
}

vec4 specular(Light light, float shininess, vec3 normal) {
    vec3 lightDir = normalize(light.lightPos - fragmentPos);
    //vec3 cameraToLight = normalize(light.lightPos - cameraPos);    
    vec3 viewDir = normalize(cameraPos - fragmentPos);
    vec3 reflectDir = reflect(-lightDir, normal);  
    float brightness = pow(max(dot(viewDir, reflectDir), 0.0), shininess);            
    return light.specularStrength * light.lightColor * brightness;
}

vec4 effect(vec4 _color, Image tex, vec2 texture_coords, vec2 screen_coords) {    
    vec4 finalColor = color;
    
    if (border == 0.)
    {
        if (useColor == 1.) {
            finalColor = color;
        }

        if (useTexCoord == 1.) {
            vec4 texturecolor = Texel(tex, texture_coords);
            finalColor = texturecolor * finalColor;
        }
        
        if (useLight == 1.) {
            vec4 composition = vec4(0., 0., 0., 0.);

            for (int i=0; i<lightsCount; ++i) {
                Light light = lights[i];
                if (light.lightType == 0. && useLightAmbient == 1.) {
                    if (useMaterial == 1.)
                        composition += ambient(light) * finalColor * material.ambientStrength;
                    else
                        composition += ambient(light) * finalColor;
                }

                if (useLightDiffuse == 1. && useNormal == 1.) {
                    float relief = 0.;
                    if (useRelief == 1.)
                        relief = snoise(texCoord.xy * param1);
                        
                    if (useMaterial == 1.){
                        composition += diffuse(light, normal + vec3(relief)) * finalColor * material.diffuseStrength;}
                    else
                        composition += diffuse(light, normal + vec3(relief)) * finalColor;
                }

                if (useLightSpecular == 1. && useNormal == 1.) {
                    if (useMaterial == 1.)
                        composition += specular(light, material.shininess, normal) * finalColor * material.specularStrength;
                    else
                        composition += specular(light, 32., normal) * finalColor;
                }
            }

            if (useMaterial == 1.)
                finalColor = vec4(composition.rgb, material.alpha);
            else
                finalColor = vec4(composition.rgb, 1.);
        }

        return finalColor;
    }
    
    float size = 0.02;
    if (texture_coords.x >= size && texture_coords.x <= 1.-size &&
        texture_coords.y >= size && texture_coords.y <= 1.-size)
    {
        discard;
    }
    
    return strokeColor;
}
