#define S sin(p.z*.2)*vec4(1,2,0,0)
void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    vec4 p = vec4(fragCoord.xy,0.,1.0)/iResolution.xyxy-.5, d=p, t, c;
    p.z += iTime*4.;
    p -= S;
    for(float i=1.5; i>0.; i-=.01)
    {
        t = abs(mod(c=p+S, 8.)-4.);
        float x = step(0., c.y),
        r = (step(2.6, t.x) - step(2.8, t.x)) * x,
        w = step(t.x, 0.8) * step(2.8, t.z) + step(2.8, t.x) * x;
        c = texture(iChannel0, (c.y*t.x > 3. ? t.zx:t.yz)-3.);
        x = min(t.x+.2, t.y)-c.x * (1.-r) - r*.8;
        fragColor = p.wyyw*.02 + mix(c, vec4(.5), r) * mix(p/p, vec4(1,.5,.2,1), w ) * i*i/p.w;
        if(x<.01) break;
        p -= d*x*.5;
     }
}