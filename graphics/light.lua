Light = class()

function Light:init(lightColor, lightPos, ambientStrength, diffuseStrength, specularStrength)    
    self.lightColor = lightColor or colors.white
    self.lightPos = lightPos or vec3()

    self.ambientStrength = ambientStrength or 0.4
    self.diffuseStrength = diffuseStrength or 0.6
    self.specularStrength = specularStrength or 1.0
end

function Light.sun()
    return Light(colors.white, vec3(-10., 500., 10.), 0.4, 0.6, 1.0)
end

function  Light.ambient(lightColor, ambientStrength)
    return Light(lightColor, nil, ambientStrength, 0, 0)
end

function  Light.directionnal(lightColor, lightPos, ambientStrength, diffuseStrength, specularStrength)
    return Light(lightColor, lightPos, ambientStrength, diffuseStrength, specularStrength)
end

function Light.random()
    return Light(
        Color.random(),
        vec3.random()*W,
        random(0.5, 1),
        random(0.5, 1),
        random(0.5, 1))
end
