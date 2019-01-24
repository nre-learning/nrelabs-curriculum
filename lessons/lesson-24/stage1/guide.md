## Junos Automation with PyEZ

**Contributed by: [@jnpr-raylam](https://github.com/jnpr-raylam)**

---

### Part 1 - Introduction

#### What is PyEZ?

Junos PyEZ is a micro-framework for Python that enables you to manage and automate Junos devices.

For Junos devices, every management protocol including on-box CLI and J-Web, remote management from Junos Space, or PyEZ - all are based on XML/NETCONF.

The Junos CLI is a special form of NETCONF client. It converts your CLI commands to Junos RPC requests, parses RPC responses and display them in human readable format.

The PyEZ framework is another NETCONF client, it inherits same capabilities and functions as Junos CLI, but in programmable and automatic way.

#### What is XML/Netconf?

So, if these are all NETCONF clients, what is NETCONF? In short, NETCONF is a standards-based transport protocol for managing network configurations, defined in [RFC6241](https://tools.ietf.org/html/rfc6241).

The relationship between NETCONF and XML is similar to the relationship between HTTP and HTML. The former is a transport protocol, and the latter is the format that the transport protocol carries between the sender and the receiver to communicate data.

Just like HTTP is used to carry HTML content from a web server to your web browser, NETCONF is used to transfer RPC requests and responses between NETCONF client (CLI, PyEZ program) and NETCONF server (Junos); and XML is a markup language to present requests (show, request, clear, configure) and responses (system uptime, interfaces statistics, etc.)

In Junos (as well as most other implementations), NETCONF is run over the Secure Shell (SSH) protocol, to take advantage of the built-in security model of SSH. To get an idea of what's happening in a NETCONF session, let's go to Linux terminal and SSH to vQFX, use `-s` parameter to invoke the NETCONF subsystem. 

```
sshpass -p antidotepassword \
ssh -o StrictHostKeyChecking=no antidote@vqfx -s netconf
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 0)">Run this snippet</button>

> While this isn't how you'd normally use NETCONF in the real world, it does allow us to tinker around with the protocol a bit and see how it works. Normally, you'd use a framework like PyEZ which abstracts these details away.

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

However, as mentioned before, PyEZ is designed to manage and automate Junos devices more easily, so you don't have to deal directly with NETCONF like this. In the next few sections, you will learn how to collect and parse information, as well as how to apply configuration changes on Junos devices.
