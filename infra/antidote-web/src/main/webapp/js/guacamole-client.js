function guacInit() {

    var display1 = document.getElementById("display1");
    var guac1 = new Guacamole.Client(
        new Guacamole.HTTPTunnel("../tunnel")
    );
    display1.appendChild(guac1.getDisplay().getElement());

    var display2 = document.getElementById("display2");
    var guac2 = new Guacamole.Client(
        new Guacamole.HTTPTunnel("../tunnel")
    );
    display2.appendChild(guac2.getDisplay().getElement());

    var display3 = document.getElementById("display3");
    var guac3 = new Guacamole.Client(
        new Guacamole.HTTPTunnel("../tunnel")
    );
    display3.appendChild(guac3.getDisplay().getElement());



    // Error handler
    guac1.onerror = function (error) {
        alert(error);
    };
    guac2.onerror = function (error) {
        alert(error);
    };
    guac3.onerror = function (error) {
        alert(error);
    };

    // Connect
    guac1.connect('csrx1');
    guac2.connect('csrx2');
    guac3.connect('csrx3');

    // Disconnect on close
    window.onunload = function () {
        guac1.disconnect();
        guac2.disconnect();
        guac3.disconnect();
    }

    // Mouse
    var mouse1 = new Guacamole.Mouse(guac1.getDisplay().getElement());
    mouse1.onmousedown =
        mouse1.onmouseup =
        mouse1.onmousemove = function (mouseState) {
            guac1.sendMouseState(mouseState);
        };

    var mouse2 = new Guacamole.Mouse(guac2.getDisplay().getElement());
    mouse2.onmousedown =
        mouse2.onmouseup =
        mouse2.onmousemove = function (mouseState) {
            guac2.sendMouseState(mouseState);
        };

    var mouse3 = new Guacamole.Mouse(guac3.getDisplay().getElement());
    mouse3.onmousedown =
        mouse3.onmouseup =
        mouse3.onmousemove = function (mouseState) {
            guac3.sendMouseState(mouseState);
        };


    // Keyboard
    var keyboard = new Guacamole.Keyboard(document);

    keyboard.onkeydown = function (keysym) {
        if (document.getElementById("csrx1").classList.contains("show")) {
            guac1.sendKeyEvent(1, keysym);
            // console.log("");
        } else if (document.getElementById("csrx2").classList.contains("show")) {
            guac2.sendKeyEvent(1, keysym);
        } else if (document.getElementById("csrx3").classList.contains("show")) {
            guac3.sendKeyEvent(1, keysym);
        }
    };

    keyboard.onkeyup = function (keysym) {
        if (document.getElementById("csrx1").classList.contains("show")) {
            guac1.sendKeyEvent(0, keysym);
        } else if (document.getElementById("csrx2").classList.contains("show")) {
            guac2.sendKeyEvent(0, keysym);
        } else if (document.getElementById("csrx3").classList.contains("show")) {
            guac3.sendKeyEvent(0, keysym);
        }
    };

}

// Run all this once the DOM is fully rendered so we can get a handle on the DIVs
document.addEventListener('DOMContentLoaded', function () {
    guacInit();
});