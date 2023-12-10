Box = class()

function Box:init(position, size)
    self.position = position:clone()
    self.size = size:clone()
end
