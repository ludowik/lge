EventManager = class()

function EventManager.setup()
    eventManager = EventManager()
end

function EventManager:init()
    self.currentObject = nil
end

local function mousepressed(x, y)
    if #love.touch.getTouches() == 5 then
        toggleFused()
    end

    mouse:pressed(x, y)

    eventManager.currentObject = contains(mouse)
    if eventManager.currentObject then
        eventManager.currentObject:mousepressed(mouse)
    end
end

local function mousemoved(x, y)
    if eventManager.currentObject then
        mouse:moved(x, y)
        eventManager.currentObject:mousemoved(mouse)
    end
end

local function mousereleased(x, y)    
    if eventManager.currentObject then
        mouse:released(x, y)
        eventManager.currentObject:mousereleased(mouse)
    end
    eventManager.currentObject = nil
end

if getOS() == 'ios' then
    function love.touchpressed(id, x, y, dx, dy, pressure)
        mousepressed(x, y, id)
    end

    function love.touchmoved(id, x, y, dx, dy, pressure)
        mousemoved(x, y, id)
    end

    function love.touchreleased(id, x, y, dx, dy, pressure)
        mousereleased(x, y, id)
    end

else
    function love.mousepressed(x, y, button, istouch, presses)
        mousepressed(x, y, button)
    end

    function love.mousemoved(x, y, dx, dy, istouch)
        mousemoved(x, y, 1)
    end

    function love.mousereleased(x, y, button, istouch, presses)
        mousereleased(x, y, button)
    end
end
