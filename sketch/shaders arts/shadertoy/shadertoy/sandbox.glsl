void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = (fragCoord.xy - 0.5 * iResolution.xy) / iResolution.y;

    uv = fract(uv * 5.0) - 0.5;

    vec3 col = vec3(0.0);

    float d = length(uv);
    d = cos(iTime) * 0.5 + 0.5;

    float m = smoothstep(0.1, 0.05, d);

    col += m;

    fragColor = vec4(col, 1.0);
}
