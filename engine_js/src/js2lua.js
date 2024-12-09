console.clear();

function setup() {
    createCanvas(
        screen.width,
        screen.height);
}

var needLoad = true;
var needSetup = true;

function draw() {
    if (needLoad) {
        var init = fengari.load('return __init')();
        if (init) {
            init();
            needLoad = false;
        }
        return;
    }

    if (needSetup) {
        var update = fengari.load('return __update')();
        var draw = fengari.load('return __draw')();
        if (update || draw) {
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
    };
    fengari.load('return __mousepressed()')();
}

function touchStarted() {
    __event = {
        x: touches[0].x,
        y: touches[0].y,
    };
    fengari.load('return __mousepressed()')();
}

function mouseDragged(event) {
    __event = {
        x: event.clientX,
        y: event.clientY,
    };
    fengari.load('return __mousemoved()')();
}

function touchMoved() {
    __event = {
        x: touches[0].x,
        y: touches[0].y,
    };
    fengari.load('return __mousemoved()')();
}

function mouseReleased(event) {
    __event = {
        x: event.clientX,
        y: event.clientY,
    };
    fengari.load('return __mousereleased()')();
}

function touchEnded() {
    fengari.load('return __mousereleased()')();
}

function keyTyped() {
    __key = key;
    fengari.load('return __textinput()')();
}

function keyPressed() {
    __key = key;
    fengari.load('return __keypressed()')();
}

function keyReleased() {
    __key = key;
    fengari.load('return __keyreleased()')();
}

screen.orientation.addEventListener("change", (event) => {
    __orientation = event.target.type;    
    setup();
    
    fengari.load('return __orientationchange()')();
});
