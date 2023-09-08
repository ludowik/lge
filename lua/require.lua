function try_require(module)
    local ok, result = pcall(function () return require(module) end)
    return ok and result
end
