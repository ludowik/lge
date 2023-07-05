UpgradeApp = class() : extends(Sketch)

function UpgradeApp:init()
    Sketch.init(self)

    anchor = Anchor(7, 7)

    self.scene = Scene()
    self.scene:add(
        UIButton('upgrade from git',
            function () 
                updateScripts(true)
                restart()
            end)
        :attrib{
            position = anchor:pos(1, 3),
            size = anchor:size(2, 1),
            styles = {
                fillColor = colors.blue
            }
        })
    self.scene:add(
        UIButton('upgrade from local',
            function ()
                updateScripts(false)
                restart()
            end)
        :attrib{
            position = anchor:pos(4, 3),
            size = anchor:size(2, 1),
            styles = {
                fillColor = colors.blue
            }
        })
end

function UpgradeApp:draw()
    background(colors.black)
    anchor:draw()
    self.scene:draw()
end
