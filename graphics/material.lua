Material = class()

function Material:init()
    self.ambientStrength = 1.5
    self.diffuseStrength = 1.5
    self.specularStrength = 0.25

    self.shininess = 32

    self.alpha = 1
end
