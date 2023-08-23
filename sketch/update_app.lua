UpdateApp = class() : extends(Sketch)

function UpdateApp:init()
    Sketch.init(self)

    anchor = Anchor(7, 7)

    self.scene = Scene()
    self.scene:add(
        UIButton('update from git',
            function () 
                updateScripts(true)
                quit()
            end)
        :attrib{
            position = anchor:pos(1, 3),
            size = anchor:size(2, 1),
            styles = {
                fillColor = colors.blue,
                wrapSize = anchor:size(2, 1).x,
                mode = 'center',
            }
        })
    self.scene:add(
        UIButton('update from local',
            function ()
                updateScripts(false)
                quit()
            end)
        :attrib{
            position = anchor:pos(4, 3),
            size = anchor:size(2, 1),
            styles = {
                fillColor = colors.blue,
                wrapSize = anchor:size(2, 1).x,
                mode = 'center',
            }
        })
end

function UpdateApp:draw()
    background()
    anchor:draw()
    self.scene:draw()
end
