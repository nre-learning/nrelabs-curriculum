function getSession() {
    var sessionCookie = document.cookie.replace(/(?:(?:^|.*;\s*)nreLabsSession\s*\=\s*([^;]*).*$)|^.*$/, "$1");
    if (sessionCookie == "") {
        sessionId = makeid();
        document.cookie = "nreLabsSession=" + sessionId;
        return sessionId;
    }
    return sessionCookie;
}

function getLabId() {
    var url = new URL(window.location.href);
    var labId = url.searchParams.get("labId");
    if (labId == null || labId == "") {
        alert("Error: labId not provided. Page will not load correctly.")
        return 0;
    }
    return parseInt(labId);
}

function makeid() {
    var text = "";

    // must only be lower-case alphanumeric, since this will form
    // part of the kubernetes namespace name
    var possible = "0123456789abcdefghijklmnopqrstuvwxyz";

    for (var i = 0; i < 16; i++)
        text += possible.charAt(Math.floor(Math.random() * possible.length));

    return text;
}

function getRandomModalMessage() {
    var messages = [
        "Sweeping technical debt under the rug...",
        "Definitely not mining cryptocurrency in your browser...",
        "Duct-taping 53 javascript frameworks together...",
        "Dividing by < ERR - DIVIDE BY ZERO. SHUTTING DOWN. AND I WAS JUST LEARNING TO LOVE.....>",
        "try { toilTime / automatingTime; } catch (DivideByZeroException e) { panic(“More NRE Labs”); }",
        "Calculating airspeed velocity of an unladen swallow..."
    ];
    return messages[Math.floor(Math.random() * messages.length)];
}

async function requestLab() {

    var myNode = document.getElementById("tabHeaders");
    while (myNode.firstChild) {
        myNode.removeChild(myNode.firstChild);
    }

    var myNode = document.getElementById("myTabContent");
    while (myNode.firstChild) {
        myNode.removeChild(myNode.firstChild);
    }

    var data = {};
    data.labId = getLabId();
    data.sessionId = getSession();

    console.log("Sent session ID:" + data.sessionId);
    console.log("Sent lab ID:" + data.labId);

    var json = JSON.stringify(data);

    // Send lab request
    // TODO(mierdin): for both of these loops, need to break if we either get a non 200 status for too long,
    // or if the lab fails to provision (ready: true) before a timeout. Can't just loop endlessly.
    for (; ;) {
        var xhttp = new XMLHttpRequest();

        // Doing synchronous calls for now, need to convert to asynchronous
        xhttp.open("POST", "https://labs.networkreliability.engineering/syringe/exp/livelab", false);
        xhttp.setRequestHeader('Content-type', 'application/json; charset=utf-8');
        xhttp.send(json);

        if (xhttp.status != 200) {
            console.log("POST waiting a second.")
            await sleep(1000);
            continue;
        }
        break;
    }

    var attempts = 1;

    // get livelab
    for (; ;) {
        response = JSON.parse(xhttp.responseText);
        console.log("Received lab UUID from syringe: " + response.id)

        // Here we go get the livelab we requested, verify it's ready, and once it is, start wiring up endpoints.
        var xhttp2 = new XMLHttpRequest();
        xhttp2.open("GET", "https://labs.networkreliability.engineering/syringe/exp/livelab/" + response.id, false);
        xhttp2.setRequestHeader('Content-type', 'application/json; charset=utf-8');
        xhttp2.send();

        if (xhttp2.status != 200) {
            console.log("GET waiting a second.")
            await sleep(2000);
            continue;
        }

        console.log("Received lab information from syringe:")
        console.log(JSON.parse(xhttp2.responseText));

        var response2 = JSON.parse(xhttp2.responseText);

        if (!response2.Ready) {
            console.log("GET received data, but lab not ready. Attempt #" + attempts)
            attempts++;
            await sleep(2000);
            continue;
        }

        var endpoints = response2.Endpoints;

        var sort = function (prop, arr) {
            return arr.sort(function (a, b) {
                if (a[prop] < b[prop]) {
                    return -1;
                } else if (a[prop] > b[prop]) {
                    return 1;
                } else {
                    return 0;
                }
            });
        };

        endpoints = sort("Name", endpoints);
        renderLabGuide(response2.LabGuide);

        // for some reason, even though the syringe health checks work,
        // we still can't connect right away. Adding short sleep to account for this for now
        await sleep(4000);
        addTabs(endpoints);
        $("#exampleModal").modal("hide");
        break;
    }
}

function renderLabGuide(url) {

    var lgGetter = new XMLHttpRequest();
    lgGetter.open('GET', url, false);
    lgGetter.send();

    var converter = new showdown.Converter();
    var labHtml = converter.makeHtml(lgGetter.responseText);
    document.getElementById("labGuide").innerHTML = labHtml;

    console.log("Rendered to HTML");
    console.log(lgGetter.responseText);
    console.log(labHtml);
}

function addTabs(endpoints) {

    // Add Devices tabs
    for (var i = 0; i < endpoints.length; i++) {
        if (endpoints[i].Type == "DEVICE") {
            console.log("Adding " + endpoints[i].Name);
            var newTabHeader = document.createElement("LI");
            newTabHeader.classList.add('nav-item');

            var a = document.createElement('a');
            var linkText = document.createTextNode(endpoints[i].Name);
            a.appendChild(linkText);
            a.classList.add('nav-link');
            a.href = "#" + endpoints[i].Name;
            a.setAttribute("data-toggle", "tab");
            if (i == 0) {
                a.classList.add('active', 'show');
            }
            newTabHeader.appendChild(a);

            document.getElementById("tabHeaders").appendChild(newTabHeader);

            var newTabContent = document.createElement("DIV");
            newTabContent.id = endpoints[i].Name;
            newTabContent.classList.add('tab-pane', 'fade');
            if (i == 0) {
                newTabContent.classList.add('active', 'show');
            }

            var newGuacDiv = document.createElement("DIV");
            newGuacDiv.id = "display" + endpoints[i].Name

            newTabContent.appendChild(newGuacDiv)

            document.getElementById("myTabContent").appendChild(newTabContent);

            console.log("Added " + endpoints[i].Name);
        }
    }

    for (var i = 0; i < endpoints.length; i++) {
        if (endpoints[i].Type == "NOTEBOOK") {
            console.log("Adding " + endpoints[i].Name);
            var newTabHeader = document.createElement("LI");
            newTabHeader.classList.add('nav-item');

            var a = document.createElement('a');
            var linkText = document.createTextNode(endpoints[i].Name);
            a.appendChild(linkText);
            a.classList.add('nav-link');
            a.href = "#" + endpoints[i].Name;
            a.setAttribute("data-toggle", "tab");
            if (i == 0) {
                a.classList.add('active', 'show');
            }
            newTabHeader.appendChild(a);

            document.getElementById("tabHeaders").appendChild(newTabHeader);

            var newTabContent = document.createElement("DIV");
            newTabContent.id = endpoints[i].Name;
            newTabContent.classList.add('tab-pane', 'fade');
            if (i == 0) {
                newTabContent.classList.add('active', 'show');
            }

            var iframe = document.createElement('iframe');
            iframe.width = "100%"
            iframe.height = "600px"
            iframe.frameBorder = "0"
            iframe.src = "https://vip.labs.networkreliability.engineering:" + String(endpoints[i].Port) + "/notebooks/work/lesson.ipynb"
            newTabContent.appendChild(iframe);
            document.getElementById("myTabContent").appendChild(newTabContent);

            console.log("Added " + endpoints[i].Name);
        }
    }
    guacInit(endpoints);
}

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

// async function closeModal() {
//     await sleep(1000);
//     $("#exampleModal").modal("hide");
// }

function provisionLab() {
    var modal = document.getElementById("modal-body");
    modal.removeChild(modal.firstChild);
    var modalMessage = document.createTextNode(getRandomModalMessage());
    modal.appendChild(modalMessage);
    $("#exampleModal").modal("show");

    requestLab();

    // $("#exampleModal").modal("hide");
}

// Do NOT do this. Horrendous User experience.
// window.onbeforeunload = deleteLab;
//
// Call deleteLab ONLY in response to an explicit user event, where they're able to understand
// what it means. Do not call this on a load or unload event. Seriously. Kittens might die.
//
function deleteLab() {

    var data = {};
    data.labId = 1;
    data.sessionId = getSession();
    var json = JSON.stringify(data);

    var xhttp = new XMLHttpRequest();
    xhttp.open("DELETE", "https://labs.networkreliability.engineering/syringe/exp/livelab", true);
    xhttp.setRequestHeader('Content-type', 'application/json; charset=utf-8');
    xhttp.send(json);

    return null;
}

async function guacInitRetry(endpoints) {
    for (; ;) {
        var guacSuccess = guacInit(endpoints);
        console.log("POOP")
        console.log(endpoints)
        if (guacSuccess == true) {
            break;
        }
        console.log("Still can't connect. Trying again in a second.")
        await sleep(1000);
    }
    console.log("Successfully connected to all guac terminals")
    $("#exampleModal").modal("hide");
}


var terminals = {};
function guacInit(endpoints) {

    for (var i = 0; i < endpoints.length; i++) {
        if (endpoints[i].Type == "DEVICE") {

            var thisTerminal = {};

            console.log("Adding guac configuration for " + endpoints[i].Name)

            thisTerminal.display = document.getElementById("display" + endpoints[i].Name);
            thisTerminal.guac = new Guacamole.Client(
                new Guacamole.HTTPTunnel("../tunnel")
            );

            thisTerminal.guac.onerror = function (error) {
                console.log(error);
                console.log("Problem connecting to the remote endpoint.");
                return false
            };

            thisTerminal.guac.connect(endpoints[i].Port);

            thisTerminal.display.appendChild(thisTerminal.guac.getDisplay().getElement());

            // Disconnect on close
            window.onunload = function () {
                thisTerminal.guac.disconnect();
            }


            thisTerminal.mouse = new Guacamole.Mouse(thisTerminal.guac.getDisplay().getElement());
            thisTerminal.mouse.onmousedown =
                thisTerminal.mouse.onmouseup =
                thisTerminal.mouse.onmousemove = function (mouseState) {
                    thisTerminal.guac.sendMouseState(mouseState);
                };

            terminals[endpoints[i].Name] = thisTerminal
        }
    }

    // This is a HORRIBLY inefficient approach but javascript is blazing fast so *shrug*
    // (just kidding we should revisit this sometime. (TODO))
    var keyboard = new Guacamole.Keyboard(document);
    keyboard.onkeydown = function (keysym) {
        var tabs = document.getElementById("myTabContent").children;
        for (var i = 0; i < tabs.length; i++) {
            var tab = tabs[i];
            if (tab.classList.contains("show")) {
                console.log(terminals[tab.id])
                terminals[tab.id].guac.sendKeyEvent(1, keysym);
            }
        }
    };
    keyboard.onkeyup = function (keysym) {
        var tabs = document.getElementById("myTabContent").children;
        for (var i = 0; i < tabs.length; i++) {
            var tab = tabs[i];
            if (tab.classList.contains("show")) {
                console.log(terminals[tab.id])
                terminals[tab.id].guac.sendKeyEvent(0, keysym);
            }
        }
    };

    console.log(terminals)
    return true
}

// Run all this once the DOM is fully rendered so we can get a handle on the DIVs
document.addEventListener('DOMContentLoaded', function () {
    provisionLab();
});


