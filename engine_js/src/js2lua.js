function setup() {
    console.clear();

    createCanvas(
        screen.width,
        screen.height);
        //WEBGL);
    
    textFont(loadFont('/resources/fonts/arial.ttf'))

    angleMode(RADIANS)
    colorMode(RGB, 1)
    textAlign(LEFT, TOP)

    pg = createGraphics(
        screen.width,
        screen.height);
}

var needLoad = true;
var needSetup = true;

function draw() {
    if (needLoad) {
        if (call('__initall')) {
            needLoad = false;
        }
        return;
    }

    if (needSetup) {
        if (call('__update') || call('__draw')) {
            needSetup = false;
        }
        return;
    }
    
    call('__update');
    call('__draw');
}

function _draw() {
    if (needLoad) {
        if (call('__initall')) {
            needLoad = false;
        }
        return;
    }

    call('__debugGraphics');
}

function call(functionName) {
    var f = fengari.load('return ' + functionName)();
    if (f) {
        f();
        return true;
    }
    return false;
}

function mousePressed(event) {
    __event = {
        x: event.clientX,
        y: event.clientY,
    };
    call('__mousepressed()');
}

function touchStarted() {
    __event = {
        x: touches[0].x,
        y: touches[0].y,
    };
    call('__mousepressed');
}

function mouseDragged(event) {
    __event = {
        x: event.clientX,
        y: event.clientY,
    };
    call('__mousemoved');
}

function touchMoved() {
    __event = {
        x: touches[0].x,
        y: touches[0].y,
    };
    call('__mousemoved');
}

function mouseReleased(event) {
    __event = {
        x: event.clientX,
        y: event.clientY,
    };
    call('__mousereleased');
}

function touchEnded() {
    call('__mousereleased');
}

function keyTyped() {
    __key = key;
    call('__textinput');
}

function keyPressed() {
    __key = key;
    call('__keypressed');
}

function keyReleased() {
    __key = key;
    call('__keyreleased');
}

screen.orientation.addEventListener("change", (event) => {
    __orientation = event.target.type;    
    setup();
    call('__orientationchange');
});
