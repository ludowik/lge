Anchor = class()

function Anchor:init(ni, nj)
    if ni and nj then
        self.ni = ni
        self.nj = nj

    elseif ni then
        self.ni = ni
        self.nj = H/(W/self.ni)

    elseif nj then
        self.nj = nj
        self.ni = W/(H/self.nj)

    else
        self.ni = 12
        self.nj = H/(W/self.ni)
    end

    self.ni = math.ceil(self.ni)
    self.nj = math.ceil(self.nj)
end

function Anchor:pos(i, j)
    i = i or 1
    j = j or i

    if i < 0 then i = self.ni + i end
    if j < 0 then j = self.nj + j end
    
    return vec2(
        floor((i)*(W/self.ni)),
        floor((j)*(H/self.nj)))
end

function Anchor:size(i, j)
    i = i or 1
    j = j or i

    return vec2(
        floor(i*(W/self.ni)),
        floor(j*(H/self.nj)))
end

function Anchor:draw(clr)
    stroke(clr or self.clr or colors.red)
    strokeSize(0.5)

    for j in index(self.nj+1) do
        line(
            self:pos(0, j).x,
            self:pos(0, j).y,
            self:pos(0, j).x + self:size(self.ni, 0).x,
            self:pos(0, j).y)
    end

    for i in index(self.ni+1) do
        line(
            self:pos(i, 0).x,
            self:pos(i, 0).y,
            self:pos(i, 0).x,
            self:pos(i, 0).y + self:size(0, self.nj).y)
    end
end
