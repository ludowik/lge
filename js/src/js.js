console.clear();

var needSetup = true;

function setup() {
    createCanvas(
        window.innerWidth,
        window.innerHeight);
}

function draw() {
    print('call draw');
    if (needSetup) {
        var setup = fengari.load('return __setup')();
        var update = fengari.load('return __update')();
        var draw = fengari.load('return __draw')();
        if (setup || draw) {
            if (setup) setup();
            if (update) update();
            if (draw) {
                background(0, 0, 0)
                draw();
            }
            needSetup = false;
        }
    } else {
        fengari.load('return __draw()')();
    }
}

function mousePressed() {
    fengari.load('return mousepressed()')();
}

function mouseReleased() {
    fengari.load('return mousereleased()')();
}
