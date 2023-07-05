UIButton = class() : extends(UI)

function UIButton:init(label, callback)
    UI.init(self, label)
    self.callback = callback
end
