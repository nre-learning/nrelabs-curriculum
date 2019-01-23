## Automating with JET

**Contributed by: [@valjeanchan](https://github.com/valjeanchan) and [@jnpr-raylam](https://github.com/jnpr-raylam)**

---

### Chapter 2 - Receive events from notification service using MQTT client

[Placeholder to explain how to subscribe JET notification events]

[JET Notification API document](https://www.juniper.net/documentation/en_US/jet17.4/topics/concept/jet-notification-api-overview.html)

We're going to use Python MQTT client to subscribe the JET notification events.

First, go to the Python interactive prompt and import the MQTT module.

```
python
import paho.mqtt.client as mqtt
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 0)">Run this snippet</button>

After that, create a MQTT client, define the `on_connect` callback function to subscribe the event. Here, we will subscribe `/junos/events/kernel/interfaces/ifa/add` topic to get notification if any interface address is added.

```
client = mqtt.Client()

def on_connect(client, userdata, flags, rc):
    client.subscribe("/junos/events/kernel/interfaces/ifa/add/#")

client.on_connect = on_connect
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 1)">Run this snippet</button>

Next, define `on_message` callback function to print the notification message payload.

```
def on_message(client, userdata, msg):
    print("%s %s" % (msg.topic, msg.payload))

client.on_message = on_message
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 2)">Run this snippet</button>

Finally, connect to vQFX tcp 1883 we configured in previous stage, and then call the `loop_forever()` function to wait for events.

```
client.connect('vqfx', 1883, 60)
client.loop_forever()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 3)">Run this snippet</button>

Now, create an new interface on vQFX.

```
configure
set interfaces xe-0/0/0 unit 0 family inet address 192.168.10.1/24
commit and-quit
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 4)">Run this snippet</button>

Change to `linux` terminal, you should be able to see the `KERNEL_EVENT_IFA_ADD` event.

Press `Ctrl-C` to exit the loop.

> Expected output (remove later)
>
> /junos/events/kernel/interfaces/ifa/add/xe-0/0/1.0/inet/192.168.20.1/32 {
>     "jet-event": {
>         "event-id": "KERNEL_EVENT_IFA_ADD",
>         "hostname": "vqfx",
>         "time": "2019-01-22-14:59:06",
>         "severity": "INFO",
>         "facility": "KERNEL",
>         "attributes": {
>             "name": "xe-0/0/0",
>             "subunit": 0,
>             "family": "inet",
>             "local-address": "192.168.10.1/32",
>             "destination-address": "192.168.10.0/24",
>             "broadcast-address": "192.168.10.255/32",
>             "generation-number": 144,
>             "flags": 192
>         }
>     }
> }

