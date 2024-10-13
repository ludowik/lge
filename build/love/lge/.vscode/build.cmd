echo version = '%date% %time%' > engine/version.lua
C:/progra~1/7-Zip/7z.exe u -mx1 -r -tZIP build/lge.love . -xr!.git* -xr!.DS_Store* -xr!lge.love -xr!build
makelove --config build\makelove.toml
