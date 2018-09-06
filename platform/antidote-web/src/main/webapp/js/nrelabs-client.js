function getSession() {
    var sessionCookie = document.cookie.replace(/(?:(?:^|.*;\s*)nreLabsSession\s*\=\s*([^;]*).*$)|^.*$/, "$1");
    if (sessionCookie == "") {
        sessionId = makeid();
        document.cookie = "nreLabsSession=" + sessionId;
        return sessionId;
    }
    return sessionCookie;
}

function getLessonId() {
    var url = new URL(window.location.href);
    var lessonId = url.searchParams.get("lessonId");
    if (lessonId == null || lessonId == "") {
        alert("Error: lessonId not provided. Page will not load correctly.")
        return 0;
    }
    return parseInt(lessonId);
}

function getLessonStage() {
    var url = new URL(window.location.href);
    var lessonStage = url.searchParams.get("lessonStage");
    if (lessonStage == null || lessonStage == "") {
        console.log("Error: lessonStage not provided. Defaulting to 1.")
        return 1;
    }
    return parseInt(lessonStage);
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
 
    // Include memes? https://imgur.com/gallery/y0LQyOV
    var messages = [
        "Sweeping technical debt under the rug...",
        "Definitely not mining cryptocurrency in your browser...",
        "Duct-taping 53 javascript frameworks together...",
        "Dividing by < ERR - DIVIDE BY ZERO. SHUTTING DOWN. AND I WAS JUST LEARNING TO LOVE.....>",
        "try { toilTime / automatingTime; } catch (DivideByZeroException e) { panic(“More NRE Labs”); }",
        "Thank you for your call. You've reached 1-800-NRE-Labs. Please hold for Dr. Automation.",
        "I'd tell you a joke about UDP, but you probably wouldn't get it.",
        "Now rendering an NRE's best friend for you to play fetch with.",
        "Our Lab-Retriever, CloudDog, is still a puppy. Thanks for your patience.",
        "Calculating airspeed velocity of an unladen swallow..."
    ];
    return messages[Math.floor(Math.random() * messages.length)];
}

function renderLessonStages() {
    var reqLessonDef = new XMLHttpRequest();

    // Doing synchronous calls for now, need to convert to asynchronous
    reqLessonDef.open("GET", "https://labs.networkreliability.engineering/syringe/exp/lessondef/" + getLessonId(), false);
    reqLessonDef.setRequestHeader('Content-type', 'application/json; charset=utf-8');
    reqLessonDef.send();

    if (reqLessonDef.status != 200) {
        console.log("Unable to get lesson def")
    } else {
        console.log("Received lesson def from syringe:")
        console.log(JSON.parse(reqLessonDef.responseText));

        var lessonDefResponse = JSON.parse(reqLessonDef.responseText);
    }

    var stages = parseInt(lessonDefResponse.Stages)

    for (i = 1; i <= stages; i++) {

        var stageEntry = document.createElement('li');
        stageEntry.classList.add('page-item');

        if (i == getLessonStage()) {
            stageEntry.classList.add('active');
        }

        var stageLink = document.createElement('a');
        stageLink.appendChild(document.createTextNode(i));
        stageLink.classList.add('page-link');
        stageLink.href = ".?lessonId=" + getLessonId() + ",lessonStage=" + i;
        stageEntry.appendChild(stageLink);

        document.getElementById("lessonStagesPagination").appendChild(stageEntry);
    }



    // <li class="page-item active">
    //     <a class="page-link" href="#">1</a>
    // </li>

}

async function requestLesson() {

    renderLessonStages()

    var myNode = document.getElementById("tabHeaders");
    while (myNode.firstChild) {
        myNode.removeChild(myNode.firstChild);
    }

    var myNode = document.getElementById("myTabContent");
    while (myNode.firstChild) {
        myNode.removeChild(myNode.firstChild);
    }

    var data = {};
    data.lessonId = getLessonId();
    data.sessionId = getSession();

    console.log("Sent lesson ID:" + data.lessonId);
    console.log("Sent session ID:" + data.sessionId);

    var json = JSON.stringify(data);

    // Send lesson request
    // TODO(mierdin): for all these loops, need to break if we either get a non 200 status for too long,
    // or if the lesson fails to provision (ready: true) before a timeout. Can't just loop endlessly.
    for (; ;) {
        var xhttp = new XMLHttpRequest();

        // Doing synchronous calls for now, need to convert to asynchronous
        xhttp.open("POST", "https://labs.networkreliability.engineering/syringe/exp/livelesson", false);
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

    // get livelesson
    for (; ;) {
        response = JSON.parse(xhttp.responseText);
        console.log("Received lesson UUID from syringe: " + response.id)

        // Here we go get the livelesson we requested, verify it's ready, and once it is, start wiring up endpoints.
        var xhttp2 = new XMLHttpRequest();
        xhttp2.open("GET", "https://labs.networkreliability.engineering/syringe/exp/livelesson/" + response.id, false);
        xhttp2.setRequestHeader('Content-type', 'application/json; charset=utf-8');
        xhttp2.send();

        if (xhttp2.status != 200) {
            console.log("GET waiting a second.")
            await sleep(2000);
            continue;
        }

        console.log("Received lesson information from syringe:")
        console.log(JSON.parse(xhttp2.responseText));

        var response2 = JSON.parse(xhttp2.responseText);

        if (!response2.Ready) {
            console.log("GET received data, but lesson not ready. Attempt #" + attempts)
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
        // TODO try removing this now that the health check is SSH based
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

function rescale(browserDisp, guacDisp) {
    var scale = Math.min(browserDisp.offsetWidth / Math.max(guacDisp.getWidth(), 1), browserDisp.offsetHeight / Math.max(guacDisp.getHeight(), 1));
    console.log("Scale factor is: " + scale)
    guacDisp.scale(scale);
}

function addTabs(endpoints) {

    // Add Devices tabs
    for (var i = 0; i < endpoints.length; i++) {
        if (endpoints[i].Type == "DEVICE" || endpoints[i].Type == "UTILITY") {
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
            // newTabContent.height="350px";
            // newTabContent.style.height = "350px";
            newTabContent.style="height: 100%;";

            var newGuacDiv = document.createElement("DIV");
            newGuacDiv.id = "display" + endpoints[i].Name
            // newGuacDiv.height="300px";
            // newGuacDiv.style.height = "300px";


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
            iframe.src = "https://vip.labs.networkreliability.engineering:" + String(endpoints[i].Port) + "/notebooks/lesson-" + getLessonId() + "/stage" + getLessonStage() + "/notebook.ipynb"
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

function provisionLesson() {
    var modal = document.getElementById("modal-body");
    modal.removeChild(modal.firstChild);
    var modalMessage = document.createTextNode(getRandomModalMessage());
    modal.appendChild(modalMessage);
    $("#exampleModal").modal("show");

    requestLesson();

    // $("#exampleModal").modal("hide");
}

// Do NOT do this. Horrendous User experience.
// window.onbeforeunload = deleteLesson;
//
// Call deleteLesson ONLY in response to an explicit user event, where they're able to understand
// what it means. Do not call this on a load or unload event. Seriously. Kittens might die.
// Actually don't do this either. Just rely on GC
//
// function deleteLesson() {

//     var data = {};
//     data.Id = 1;
//     data.sessionId = getSession();
//     var json = JSON.stringify(data);

//     var xhttp = new XMLHttpRequest();
//     xhttp.open("DELETE", "https://labs.networkreliability.engineering/syringe/exp/livelesson", true);
//     xhttp.setRequestHeader('Content-type', 'application/json; charset=utf-8');
//     xhttp.send(json);

//     return null;
// }

async function guacInitRetry(endpoints) {
    for (; ;) {
        var guacSuccess = guacInit(endpoints);
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
        if (endpoints[i].Type == "DEVICE" || endpoints[i].Type == "UTILITY") {

            var thisTerminal = {};

            var tunnel = new Guacamole.HTTPTunnel("../tunnel")

            console.log("Adding guac configuration for " + endpoints[i].Name)

            thisTerminal.display = document.getElementById("display" + endpoints[i].Name);
            thisTerminal.guac = new Guacamole.Client(
                tunnel
            );

            thisTerminal.guac.onerror = function (error) {
                console.log(error);
                console.log("Problem connecting to the remote endpoint.");
                return false
            };

            var password = ""
            if (endpoints[i].Type == "DEVICE") {
                password = "VR-netlab9"
            } else if (endpoints[i].Type == "UTILITY") {
                password = "antidotepassword"
            }

            connectData = endpoints[i].Port + ";" + String(document.getElementById("tabPane").offsetWidth) + ";" + String(document.getElementById("tabPane").offsetHeight - 42) + ";" + password;
            thisTerminal.guac.connect(connectData);

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
    provisionLesson();
});
