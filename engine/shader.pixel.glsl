vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec4 texturecolor = Texel(tex, texture_coords);
    return texturecolor * color;

    // if (texture_coords.x >= 0.01 && texture_coords.x <= 0.99 && texture_coords.y >= 0.01 && texture_coords.y <= 0.99) discard;
    
    // float v = 1.;
    // return vec4(v, v, v, 1.);
}
