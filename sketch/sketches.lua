function setup()
    scene = Scene()
    processManager:foreach(function (env)
        scene:add(UIButton(env.__className,
            function (self)
                processManager:setSketch(self.label)
            end):attrib{
                styles = {
                    fillColor = colors.transparent,
                },
            })
    end)
    scene:layout(0, 0, 'center')
end
