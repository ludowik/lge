Material = class()

function Material.setup()
    materials = Array{
        bronze = Material(
            Color(0.2125, 0.1275, 0.054),
            Color(0.714, 0.4284, 0.18144),
            Color(0.393548, 0.271906, 0.166721), 5),

        gold = Material(
            Color(0.24725, 0.1995, 0.0745),
            Color(0.75164, 0.60648, 0.22648),
            Color(0.628281, 0.555802, 0.366065), 0.4*128),

        wood = Material(
            Color(0.2, 0.15, 0.1),
            Color(0.6, 0.4, 0.2),
            Color(0.1, 0.1, 0.1), 5),
    }
end

function Material:init(ambientColor, diffuseColor, specularColor, shininess, alpha)
    self.ambientColor = ambientColor
    self.diffuseColor = diffuseColor
    self.specularColor = specularColor
    
    self.shininess = shininess

    self.alpha = alpha or 1
end
