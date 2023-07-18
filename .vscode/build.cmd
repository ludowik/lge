@echo off
@echo version = '%date% %time%' > engine/version.lua

C:/progra~1/7-Zip/7z.exe u -mx1 -r -tZIP build/lca.love . -xr!.git* -xr!.DS_Store* -xr!lca.love -xr!build
