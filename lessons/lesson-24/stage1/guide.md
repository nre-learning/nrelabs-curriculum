## Junos Automation with PyEZ

*Contributed by Raymond Lam @jnpr-raylam*

---

### Part 1 - Introduction

#### 1. What can Automation do?

People who are not familiar with Junos automation are often confused with Netconf / Python / PyEZ, and sometimes they may think Junos automation equals to PyEZ.  So before starting to learn about PyEZ, this section will give a brief introduction on their relationships and differences.

For Junos devices, every management protocol including CLI, J-Web, managed from Junos Space, or PyEZ - all are based on XML/Netconf. Exception is JET (Junos Extension Toolkit), which won't be covered in this training lesson.

Junos CLI is a special form of Netconf client. When you type commands in CLI, `cli` process will convert your requests to RPC call and send to Junos; and after Junos reply, the `cli` process will parse the response and display output in human readable format.

Junos automation tool is another Netconf client, it performs what we usually do in Junos CLI, but in programmable and automatic way:
  - Inherit same capabilities as CLI
  - Call some functions to get device status -> `show` command in CLI
  - Call another functions to execute action -> `request` or `clear` command in CLI
  - Load and commit configuration -> CLI configure mode

Currently there are lots of Python modules available in the Internet. If we can use Python language to manage Junos devices, it's easy to collect data from Junos, and then by using other Python's modules, store them in external database, send email, fire event in monitoring system, push message to Whatsapp/Slack, etc.  Automation can build the connections between Junos devices and the outside world.

#### 2. XML/Netconf

In short, Netconf is transport protocol, XML is data presentation format.

If you still can't get it, you may think the relationship between HTTP and HTML - HTTP is a communication protocol to transfer web page; and HTML is a markup language to present web page content.

Similarly, Netconf is use to transfer RPC requests and RPC replies between Netconf client (CLI, PyEZ program) and Netconf server (Junos); and XML is markup language to present the requests (show, request, clear, configure) and replies (system uptime, interfaces statistics, etc.)

In Junos, Netconf is run over SSH protocol. To get an idea of what's happening in a Netconf session, let's go to Linux terminal and SSH to vQFX, use `-s` parameter to invoke Netconf subsystem: 

```
sshpass -p VR-netlab9 \
ssh -o StrictHostKeyChecking=no root@vqfx -s netconf
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 0)">Run this snippet</button>

In the terminal, you should see some `<capability>` tags returned from Junos, it's the initial capabilities exchange between client and server, to declare what capabilities are supported on the server side. Another thing you should note is all those requests and responses are encoded in XML format as mentioned previously.

The outermost tag of all RPC requests is `<rpc>`. To get system uptime, use `<get-system-uptime-information>` as shown in below snippet. If you don't how to get the tag, no worries, it will be covered in next section.

```
<rpc><get-system-uptime-information/></rpc>
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 1)">Run this snippet</button>

Finally, to close the session, use `<close-session>` tag.

```
<rpc><close-session/></rpc>
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 2)">Run this snippet</button>

Now, you should have some idea on how XML data is exchanged in Netconf session, and how to use RPC request/reply to get a Junos device's uptime.

#### 3. What is PyEZ

PyEZ is a module to make Junos management easier. In fact, you can manage a Junos device by Python code without PyEZ.

In that case, you have to write codes to create network socket and TCP connection, use SSH module to handle authentication, invoke Netconf subsystem, prepare RPC request in XML format and send it to the server.  After received RPC reply, you may need to perform regular expression matching on the returned XML data, extract and at last display desired information. Here is a sample Python program to get system uptime information from Junos: <a href="https://raw.githubusercontent.com/nre-learning/antidote/lesson-24/lessons/lesson-24/stage1/sample_code/get-uptime-socket.py" target="_blank">Sample code here: get-uptime-socket.py</a>

Run the program to display vQFX uptime:

```
python /antidote/lessons/lesson-24/stage1/sample_code/\
get-uptime-socket.py vqfx
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 3)">Run this snippet</button>

Now, let's try using PyEZ module, what you have to do is just provide hostname, username, and password to create PyEZ Device object, call `open()` function, and then call RPC function, parse output which is already converted to an XML object, and finally display it -  everything becomes easy!  Here is a sample Python program using PyEZ module to get the same system uptime information from Junos: <a href="https://raw.githubusercontent.com/nre-learning/antidote/lesson-24/lessons/lesson-24/stage1/sample_code/get-uptime-pyez.py" target="_blank">Sample code here: get-uptime-pyez.py</a>

Run the program also to display vQFX uptime:

```
python /antidote/lessons/lesson-24/stage1/sample_code/\
get-uptime-pyez.py vqfx
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 4)">Run this snippet</button>

Beside basic RPC requests/replies handling, PyEZ contains below sub-modules for specific Junos management task:
  - **Config** - provision Junos config
  - **StartShell** - run shell commands in Junos
  - **Scp** - perform SCP copying files to and from Junos devices
  - **SW** - manage software upgrade / downgrade
  - **Tables** - help to manage Junos without any knowledge on XML

In next section, we will cover how to use PyEZ to collect and parse information from Junos devices.
