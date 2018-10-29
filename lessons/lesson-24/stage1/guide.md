## Junos Automation with PyEZ

### Part 1 - Introduction

#### 1. What can Automation do?

All Junos management protocol is based on XML/Netconf (except JET)
  - Including CLI, JWeb, Managed from Junos Space, PyEZ, etc

Junos CLI is a special form of Netconf client
  - When you type commands in CLI, the cli process will convert your requests to RPC call and send to Junos
  - After Junos reply, the cli process will parse the response and display the output in human readable format

Junos automation tool just performs what we usually do in Junos CLI, but in programmable and automatic way
  - Inherit the same capability as CLI
  - Call some functions to get device status -> "show" command in CLI
  - Call another functions to execute action -> "request" or "clear" command in CLI
  - Load and commit configuration -> CLI configure mode

Lots of Python modules available in Internet
  - For example, using Python program to manage Junos device, you can collect data from Junos and store them in external database through Python's database module
  - By using PyEZ, open the interaction between Junos and outside world

#### 2. XML/Netconf

Netconf is the protocol, XML is the data structure

Similar to the relationship between HTTP and HTML
  - HTTP is the communication protocol to transfer web page
  - HTML is the markup language to present the web page content

Netconf to transfer the RPC request and RPC reply between Netconf client (CLI, PyEZ program) and Netconf server (Junos)

XML is the markup language to present the request (show, request, clear, configure) and reply (system uptime, interfaces statistics, etc.)

For HTTP, telnet to web server port 80

```
telnet labs.networkreliability.engineering 80

```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 0)">Run this snippet</button>

To get the web page, issue the GET command, following the relative path of the web page, and then specify the HTTP version, and at last provide the 'Host' field to specify the web host.

<pre>
GET / HTTP/1.0
Host: labs.networkreliability.engineering

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 1)">Run this snippet</button>

For Netconf, ssh to vqfx1, use `-s` to invoke the Netconf subsystem.

```
sshpass -p VR-netlab9 \
ssh -o StrictHostKeyChecking=no root@vqfx1 -s netconf
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 2)">Run this snippet</button>

Junos management protocol is XML/Netconf, all the requests and responses are encoded in XML format

To get system uptime, use the `<get-system-uptime-information>` tag embedded in `<rpc>` tag, the response from Junos is in XML format as well

```
<rpc><get-system-uptime-information/></rpc>
<rpc><close-session/></rpc>
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 3)">Run this snippet</button>

#### 3. What is PyEZ

PyEZ is a library to make the Junos management easier. In fact, you can manage a Junos device by pure Python code without PyEZ

For pure Python code, you have to manually write the code to
  - create the network socket
  - connect to the remote host using the socket
  - prepare the XML string
  - send the string to the socket
  - receive the raw data from socket
  - perform regular expression matching on the response
  - extract the desired information
  - <a href="https://raw.githubusercontent.com/jnpr-raylam/antidote/lesson-24/lessons/lesson-24/stage1/sample_code/get-uptime-socket.py" target="_blank">Sample code here: get-uptime-socket.py</a>

  ```
  cd /antidote/lessons/lesson-24/stage1/sample_code
  python get-uptime-socket.py vqfx1
  ```
  <button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 4)">Run this snippet</button>

Before PyEZ, people use Python Netconf client module - ncclient, to manage devices with Netconf capability. With ncclient, you just write code to
  - connect to remote host
  - call the ncclient function the send the RPC request
  - get the response
  - perform regular expression matching on the response
  - extract the information
  - a litter bit easier compared to pure Python code
  - <a href="https://raw.githubusercontent.com/jnpr-raylam/antidote/lesson-24/lessons/lesson-24/stage1/sample_code/get-uptime-ncclient.py" target="_blank">Sample code here: get-uptime-ncclient.py</a>

  ```
  cd /antidote/lessons/lesson-24/stage1/sample_code
  python get-uptime-ncclient.py vqfx1
  ```
  <button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 5)">Run this snippet</button>

With PyEZ library, managing Junos devices becomes easy, you just need to
  - connect to remote host
  - call the PyEZ function
  - get the response
  - extract information
  - in addition to simple request response, PyEZ contains sub-modules:
      - Config - provision Junos config
      - StartShell - run shell commands in Junos
      - Scp - perform SCP to and from Junos devices
      - SW - manage the software upgrade / downgrade
      - Tables - help to manage the Junos without any knowledge on XML
  - <a href="https://raw.githubusercontent.com/jnpr-raylam/antidote/lesson-24/lessons/lesson-24/stage1/sample_code/get-uptime-pyez.py" target="_blank">Sample code here: get-uptime-pyez.py</a>

  ```
  cd /antidote/lessons/lesson-24/stage1/sample_code
  python get-uptime-pyez.py vqfx1
  ```
  <button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 6)">Run this snippet</button>
