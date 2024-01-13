Light = class()

function Light:init(lightType, lightColor, lightPos, ambientStrength, diffuseStrength, specularStrength)
    self.lightType = lightType or 0
    
    self.lightColor = lightColor or colors.white
    self.lightPos = lightPos or vec3()

    self.ambientStrength = ambientStrength or 0.8
    self.diffuseStrength = diffuseStrength or 1
    self.specularStrength = specularStrength or 0
end

function  Light.sun()
    return Light(1, colors.yellow, vec3(-500000., -50000., -1000.), 0.2, 0.8, 0.3)
end

function  Light.ambient(lightColor, ambientStrength)
    return Light(0, lightColor, nil, ambientStrength, 0, 0)
end

function  Light.directionnal(lightColor, lightPos, ambientStrength, diffuseStrength, specularStrength)
    return Light(1, lightColor, lightPos, ambientStrength, diffuseStrength, specularStrength)
end

function Light.random()
    return Light(
        1,
        Color.random(),
        vec3.random()*W,
        random(0.5, 1),
        random(0.5, 1),
        random(0.5, 1))
end
