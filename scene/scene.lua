Scene = class() : extends(Node)

function Scene:ui(name)
    for i,v in ipairs(self.items) do
        if v.label == name then return v end
    end
end
