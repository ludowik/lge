// Plot a line on Y using a value between 0.0-1.0
float plot(vec2 st, float pct) {
    return smoothstep(pct-0.01, pct, st.y) - smoothstep(pct, pct+0.01, st.y);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
	vec2 st = fragCoord.xy / iResolution.xy;

    float y = st.x;

    vec3 color = vec3(st.x, st.y, 0.0);

    // Plot a line
    float pct = plot(st, y);
    color = (1.0 - pct) * color + pct * vec3(0.0, 1.0, 0.0);

	fragColor = vec4(color, 1.0);
}
