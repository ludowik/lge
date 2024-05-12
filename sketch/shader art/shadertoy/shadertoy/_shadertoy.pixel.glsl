void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    fragColor = vec4(
        cos(iTime), 
        sin(iTime), 
        cos(iTime), 1.);
}
