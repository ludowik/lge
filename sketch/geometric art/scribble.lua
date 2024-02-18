function setup()
    renderCount = 100
    sketch.fb = FrameBuffer(w, h)
end

function update(dt)
    renderCount = renderCount + 1000 * dt
end

function draw()
    local w = W / 2;
    local v = renderCount / 1000;

    translate(W/2, H/2);
    rotate(noise(v / 10) * TAU);

    local c = noise(v + 952.74);

    local r = noise(v + 92.74);
    local g = noise(v + 5.74);
    local b = noise(v + 52.4);
    local a = noise(v + 43245.3463);

    noStroke();
    fill(r, g, b, 0.1);

    local x = noise(v + 1254.2) * 2 - 1;
    local y = noise(v + 34.356) * 2 - 1;

    local radius = noise(v + 693.4566) * w / 5;

    circle(
        x * w,
        y * w,
        radius);

    x = (1 - abs(x)) * sign(x);
    y = (1 - abs(y)) * sign(y);

    noFill();

    strokeSize(0.2);
    stroke(c, 0.5, 0.5, a);

    circle(
        x * w,
        y * w,
        radius);
end
