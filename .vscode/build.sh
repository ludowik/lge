echo version = \'$(date)\' > engine/version.lua
zip -u -1 -r build/lca.love . -x *.git* *.DS_Store* lca.love __archive/\\*
makelove --config build/makelove.toml
