-- start server
python3 -m http.server 8080


-- TODO

engine
- use new buffer
- application settings
- review restart method (release all before restart ? or more virtual restart ?)
- detect scripts error and execution error to change the current sketch to "sketches" for the next launch
- fusion of sketch and process manager (a process is a sketch)

sketch
- gérer un zoom
- gérer une translation
- gérer un pixelRatio

triomino    
- align position and drawing
- progress in the implementation : push triomino on the grid

easings
- complete easing functions

random
- try random https://github.com/linux-man/randomlua/blob/master/randomlua.lua

fonctions activables des sketches
- 2 fingers pinch gesture => zoom up or down
- 2 fingers swipe gesture => translate screen
- 1 touch / release => pause / resume

graph
Améliorer l'algo d'équilibrage

super_formula
Faire marche la version 3D : éloigner la caméra ?

3D
- rotation with quaternion
