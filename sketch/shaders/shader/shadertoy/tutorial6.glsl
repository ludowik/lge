// Plot a line on Y using a value between 0.0-1.0
float plot(vec2 st, float pct) {
    return smoothstep(pct-0.01, pct, st.y) - smoothstep(pct, pct+0.01, st.y);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 st = fragCoord.xy/iResolution.xy;

    // Smooth interpolation between 0.1 and 0.9
    float y = smoothstep(0.3, 0.7, st.x);
    //float y = smoothstep(0.25,0.3,st.x) - smoothstep(0.7,0.75,st.x);

    vec3 color = vec3(y);

    float pct = plot(st,y);
    color = (1.0-pct)*color+pct*vec3(0.0,1.0,0.0);

    fragColor = vec4(color,1.0);
}
