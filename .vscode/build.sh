echo version = \'$(date)\' > engine/version.lua
zip -u -1 -r build/lge.love . -x *.git* *.DS_Store* lge.love __archive/\\*
makelove --config build/makelove.toml
