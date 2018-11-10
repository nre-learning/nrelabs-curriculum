## Junos Automation with PyEZ

**Contributed by: [@jnpr-raylam](https://github.com/jnpr-raylam)**

---

### Part 1 - Introduction

#### What is PyEZ?

Junos PyEZ is a micro-framework for Python that enables you to manage and automate Junos devices.

For Junos devices, every management protocol including on-box CLI and J-Web, remote management from Junos Space, or PyEZ - all are based on XML/Netconf.

Junos CLI is a special form of Netconf client. It converts your CLI commands to Junos RPC requests, parses RPC responses and display them in human readable format.

Junos PyEZ is another Netconf client, it inherits same capabilities and functions as Junos CLI, but in programmable and automatic way.

#### What is XML/Netconf?

In short, Netconf is transport protocol, XML is data presentation format.

If you still can't get it, you may think the relationship between HTTP and HTML - HTTP is a communication protocol to transfer web page; and HTML is a markup language to present web page content.

Similarly, Netconf is used to transfer RPC requests and responses between Netconf client (CLI, PyEZ program) and Netconf server (Junos); and XML is a markup language to present requests (show, request, clear, configure) and responses (system uptime, interfaces statistics, etc.)

In Junos, Netconf is run over SSH protocol. To get an idea of what's happening in a Netconf session, let's go to Linux terminal and SSH to vQFX, use `-s` parameter to invoke Netconf subsystem: 

```
sshpass -p VR-netlab9 \
ssh -o StrictHostKeyChecking=no root@vqfx -s netconf
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 0)">Run this snippet</button>

In the terminal, you should see some `<capability>` tags returned from Junos, it's the initial capabilities exchange between client and server. Another thing you should note is all those requests and responses are encoded in XML format as mentioned previously.

To get system uptime, use `<get-system-uptime-information>` and embedded it in `<rpc>` tag as shown in below snippet. If you don't how to get the tag, no worries, it will be covered in next section.

```
<rpc><get-system-uptime-information/></rpc>
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 1)">Run this snippet</button>

Finally, to close the session, use `<close-session>` tag.

```
<rpc><close-session/></rpc>
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 2)">Run this snippet</button>

#### What's next?

This section gives you an initial idea on how XML data is exchanged in Netconf session, and how to use RPC request/response to get a Junos device's uptime.

PyEZ is designed to manage and automate Junos devices easily without Netconf knowledge. In next few sections, you will learn how to collect and parse information, as well as how to apply configuration changes on Junos devices.
