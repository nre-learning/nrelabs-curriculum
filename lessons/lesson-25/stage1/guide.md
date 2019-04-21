## Juniper Extension Toolkit (JET)

**Contributed by: [@valjeanchan](https://github.com/valjeanchan) and [@jnpr-raylam](https://github.com/jnpr-raylam)**

---

### Chapter 1 - JET rpc/notification configuration

#### What is JET?
Juniper Extension Toolkit (JET) is a framework that exposes API functionality made available by the internal Junos OS daemons. Each internal daemon exposes its own APIs. All of the APIs are accessible using the gRPC framework for remote procedure calls (RPCs).

JET supports the following:
* Multiple languages for applications that run off-box
* Python for applications that run on a device running Junos OS
* Applications written in C to run on devices that do not use the JET APIs
* An event notification method that enables the applications to respond to selected system events

There are two types of services JET provides:
* Request-response - An application can issue a request and wait for the response from Junos OS. (RPC model, gRPC based)
* Notification - An application can receive asynchronous notification of events happening on Junos OS. (publish-subscribe model. MQTT based)

For more informations about the JET can be found <a href="https://www.juniper.net/documentation/en_US/jet18.4/topics/concept/jet-architecture.html" target="_blank">here</a>.

In this lab we are going to explore a off-box python JET application.

#### Config the Junos device for JET
First of all, to run an off-box JET application, we need to enable the request-response configuration on the Junos OS device.

The gRPC can be run in clear-text mode _(insecure! that's why it is hidden and for lab test only!)_ or SSL encrypted mode for enhanced security. For simplicity we'll go with clear-text in the lab. More information about gRPC over SSL can be found <a href="https://www.juniper.net/documentation/en_US/jet18.4/topics/topic-map/jet-off-box-apps.html" target="_blank">here</a>.

Apply below configuration to enable notification and gRPC request-response service on vQFX.

```
configure
set system services extension-service notification port 1883 allow-clients address 0.0.0.0/0
set system services extension-service request-response grpc clear-text port 32767
commit and-quit
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', this)">Run this snippet</button>

We can check the listening port to verify the notification and gRPC service are enabled.

```
show system connections | match LISTEN | match "\.1883|\.32767"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', this)">Run this snippet</button>

Now the Junos OS device is ready for off-box JET applications and it's time to get some action!  In the next chapter, we'll go through the notifiaction mechanism and collect some events from the MQTT event bus.
