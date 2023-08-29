function time()
    return love.timer.getTime()
end

function date()
    return os.date("*t", os.time())
end

assert(time())
assert(date())
