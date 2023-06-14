function makezip()
    if oswindows then
        local zip = '"C:/Program Files/7-Zip/7z.exe"'
        os.execute(zip..' u -mx1 -r -tZIP lca.love . -xr!.git* -xr!.DS_Store* -xr!lca.love -xr!__archive')
        
    else
        local zip = 'zip'
        local zipCommand = zip..' -u -1 -r lca.love . -x *.git* *.DS_Store* lca.love __archive/\\*'
        print(zipCommand)
        os.execute(zipCommand)
    end
end
