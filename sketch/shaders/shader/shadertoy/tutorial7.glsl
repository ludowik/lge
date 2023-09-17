// Plot a line on Y using a value between 0.0-1.0
float plot(vec2 st, float pct) {
    return smoothstep(pct-0.01, pct, st.y) - smoothstep(pct, pct+0.01, st.y);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 st = fragCoord.xy/iResolution.xy;
    float x = st.x;

    float y;
    y = x;
    y = mod(x,0.5); // renvoie x modulo 0.5
    y = fract(x); // renvoie uniquement la partie fractionnelle d'un chiffre (les chiffres après la virgule)
    y = ceil(x);  // renvoie le plus proche entier supérieur ou égal à x
    y = floor(x); // renvoie le plus proche entier inférieur ou égal à x
    y = sign(x);  // renvoie le signe de x (-1 ou 1)
    y = abs(x);   // renvoie la valeur absolue de x
    y = clamp(x,0.0,1.0); // force x à se retrouver entre 0.0 et 1.0
    y = min(0.0,x);   // renvoie le plus petit chiffre entre 0 et x
    y = max(0.0,x);   // renvoie le plus grand chiffre entre 0 et x

    vec3 color = vec3(y);

    float pct = plot(st,y);
    color = (1.0-pct)*color+pct*vec3(0.0,1.0,0.0);

    fragColor = vec4(color,1.0);
}
