UpgradeApp = class() : extends(Sketch)

function UpgradeApp:init()
    Sketch.init(self)

    anchor = Anchor(7, 7)

    self.scene = Scene()
    self.scene:add(
        UIButton('upgrade from git'):attrib{
            position = anchor:pos(2, 4),
            size = anchor:size(2, 2),
        })
    self.scene:add(
        UIButton('upgrade from git'):attrib{
            position = anchor:pos(5, 4),
            size = anchor:size(2, 2),
        })
end

function UpgradeApp:draw()
    background(colors.black)
    drawAnchorGrid(anchor)
    self.scene:draw()
end
