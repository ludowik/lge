UICheck = class() : extends(UI)

function UICheck:init(label, object, callback)
    UI.init(self, label)
    self.callback = callback

    if classnameof(object) == 'Bind' then
        self.value = object
    else
        self.value = Bind(object)
    end
end

function UICheck:click()
    self.value:toggle()
    MouseEvent.click(self)
end
