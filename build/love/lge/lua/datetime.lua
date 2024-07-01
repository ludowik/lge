function time()
    return love.timer.getTime()
end

function date()
    return os.date("*t", os.time())
end

assert(time())
assert(date())

Date = class()

function Date:init()
    self:attrib(os.date('*t'))
end

function Date:__tostring()
    return self:asdate()
end

function Date:asDate()
    return string.format('%02d/%02d/%04d', self.day, self.month, self.year)
end

function Date:asTime()
    return string.format('%02d:%02d', self.hour, self.min)
end

function Date:asDatetime()
    return self:asDate()..' '..self:asTime()
end
