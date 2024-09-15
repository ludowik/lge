console.clear();

function setup() {
    createCanvas(
        window.innerWidth,
        window.innerHeight);
}

var needLoad = true;
var needSetup = true;
function draw() {
    var INIT = fengari.load('return INIT')();
    if (!INIT) return;

    if (needLoad) {
        var init = fengari.load('return __init')();
        var loadASketch = fengari.load('return __loadASketch')();
        if (init && loadASketch) {
            init();
            loadASketch();
            needLoad = false;
        }
        return;
    }

    if (needSetup) {
        var update = fengari.load('return __update')();
        var draw = fengari.load('return __draw')();
        if (setup || draw) {
            if (setup) setup();
            if (update) update();
            if (draw) {
                background(0, 0, 0);
                draw();
            }
            needSetup = false;
        }
        return;
    }

    fengari.load('return __update()')();
    fengari.load('return __draw()')();
}

function mousePressed(event) {
    __event = {
        x: event.clientX,
        y: event.clientY,
    }
    fengari.load('return __mousepressed()')();
}

function touchStarted() {
    __event = {
        x: touches[0].x,
        y: touches[0].y,
    }
    fengari.load('return __mousepressed()')();
}

function mouseDragged(event) {
    __event = {
        x: event.clientX,
        y: event.clientY,
    }
    fengari.load('return __mousemoved()')();
}

function touchMoved() {
    __event = {
        x: touches[0].x,
        y: touches[0].y,
    }
    fengari.load('return __mousemoved()')();
}

function mouseReleased(event) {
    __event = {
        x: event.clientX,
        y: event.clientY,
    }
    fengari.load('return __mousereleased()')();
}

function touchEnded() {
   fengari.load('return __mousereleased()')();
}

function keyPressed() {
    keys = {
        'Enter': 'enter',
        'ArrowDown': 'down',
        'ArrowUp': 'up',
        'ArrowLeft': 'left',
        'ArrowRight': 'right',
        ' ': 'space',
    };

    __key = keys[key] || key;
    fengari.load('return __keypressed()')();
}
