function lower_path(path)
    dir(path):foreach(function (fname, index)
        os.rename(path..'/'..fname, 'resources/fonts/'..fname:lower())
    end)
end

-- lower_path('resources/fonts')
