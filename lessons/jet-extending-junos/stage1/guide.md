Before we deep dive into notification service, let's get an introduction on message broker and publish-subscribe (PUB-SUB) model.

#### Message Broker and PUB-SUB model

![JET System Archtecture](https://www.juniper.net/documentation/images/g043543.png)

A message broker system is hub and spoke based model where
- Broker accepts messages from clients and delivers to other interested clients
- Client either publish an message with a topic, or subscribe to a topic or both
- Topic is a namespace on the broker. Client subscribes or publish to a topics
- Publish: a Client sending a message to a Broker with a topic
- Subscribe: a Client requesting broker what topic it is interested.The broker will deliver messages to this client based on the topic it subscribed.

#### JET Notification Service
Juniper JET notification service is a message broker system based on <a href="http://mqtt.org/" target="_blank">MQTT</a> protocol to deliver system events. Junos system daemons such as RPD will generate messages and publish them to the JET message broker through eventd with specific topics. For example, interface events (link up/down) will have topic `/junos/events/kernel/interfaces` while route table related event will have topic `/junos/events/kernel/route-table`. The list of topic available can be found <a href="https://www.juniper.net/documentation/en_US/jet17.4/topics/concept/jet-notification-api-overview.html" target="_blank">here</a>.

#### Creating a Python MQTT Client
We're going to create a Python MQTT client to collect JET notification events.

First of all, go to the Python interactive prompt and import the MQTT module.

```
python
import paho.mqtt.client as mqtt
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

After that, create a MQTT client object. Then define the `on_connect` callback function, which is triggered once the client connects to the JET MQTT broker, to subscribe the event. Here, we will subscribe to the topic `/junos/events/kernel/interfaces/ifa/add` which includes all new interfaces address events.
At last we bind the on_connect function to the client object.

```
client = mqtt.Client()

def on_connect(client, userdata, flags, rc):
    client.subscribe("/junos/events/kernel/interfaces/ifa/add/#")

client.on_connect = on_connect
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Next, define `on_message` callback function, which is triggered whatever a message is received, to print the notification message payload. Then we bind the on_message function to the client object.

```
def on_message(client, userdata, msg):
    print("%s %s" % (msg.topic, msg.payload))

client.on_message = on_message
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Finally, instruct the client to connect to vQFX TCP port 1883 we configured in previous stage, and start the main event loop function `loop_forever()`  to wait for events.

```
client.connect('vqfx', 1883, 60)
client.loop_forever()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

The client is now ready to received JET notification event. It's normal that you don't see a prompt back - this command runs endlessly until stopped.

#### Triggering a event

Now, we try to trigger a new interface address event by create an new interface on vQFX.

```
configure
set interfaces xe-0/0/0 unit 0 family inet address 192.168.10.1/24
commit and-quit
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', this)">Run this snippet</button>

Once the commit is completed, Eventd will receive the new IFA event and deliver it to all clients who subscribed the IFA topic.

Now change to `linux` terminal, you should be able to see the `KERNEL_EVENT_IFA_ADD` event.

Press `Ctrl-C` to exit the loop.

In the next chapter we are going to explore JET request-response calls.
