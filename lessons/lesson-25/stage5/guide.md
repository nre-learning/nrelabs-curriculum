## Automating with JET

**Contributed by: [@valjeanchan](https://github.com/valjeanchan) and [@jnpr-raylam](https://github.com/jnpr-raylam)**

---

### Chapter 5 - Closed loop automation with JET

In this stage, we try to combine what we have learnt previously to demonstrate a closed-loop automation script.

We use JET notification services to listen for new IFA event and if the configured IP address is a public IP address, we use gRPC service to provision a firewall filter to protect the vQFX device.

Here, we put the JET firewall API code in stage 4 in a separate file `add_firewall_filter.py`. Try to view the code now.

```
cd /antidote/lessons/lesson-25
cat add_firewall_filter.py
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 0)">Run this snippet</button>

Again, we repeat what we have done in previous stage - compile the IDL package, go to Python interactive prompt, import the required module.

```
tar -xzf jet-idl-17.4R1.16.tar.gz
python -m grpc_tools.protoc -I./proto --python_out=. --grpc_python_out=. ./proto/*.proto

python
import json
import ipaddress
import paho.mqtt.client as mqtt
from add_firewall_filter import add_firewall_filter

```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 1)">Run this snippet</button>

Same as stage 2, we create the MQTT client and define `on_connect` callback function to subscribe the IFA add event once clients connect to the JET MQTT broker.

```
client = mqtt.Client()

def on_connect(client, userdata, flags, rc):
    client.subscribe("/junos/events/kernel/interfaces/ifa/add/#")

client.on_connect = on_connect
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 2)">Run this snippet</button>

Next, define `on_message` callback function, to call the `add_firewall_filter` function if the new IP address is in the public range. After that, connect to vQFX and start to wait for event.

```
def on_message(client, userdata, msg):
    payload = json.loads(msg.payload)
    intf = '%s.%s' % (payload['jet-event']['attributes']['name'],
                      payload['jet-event']['attributes']['subunit'])
    ipaddr = payload['jet-event']['attributes']['local-address']
    if not ipaddress.IPv4Network(ipaddr).is_private:
        print('Apply firewall filter on interface %s' % intf)
        add_firewall_filter(intf)
    else:
        print('No action for private IP %s' % ipaddr.split('/')[0])

client.on_message = on_message

client.connect('vqfx', 1883, 60)
client.loop_forever()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 3)">Run this snippet</button>

Here, We simulate another neighboring device by creating one more routing instance in the vQFX. Interface xe-0/0/2 and xe-0/0/3 is connected together, and a public IP address `20.1.1.2/24` is pre-configured on xe-0/0/3 which is in routing instance `VR2`

Now, let's create IP address on xe-0/0/2 interface.

```
configure
set interfaces xe-0/0/2 unit 0 family inet address 20.1.1.1/24
commit and-quit
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 4)">Run this snippet</button>

Verify the message `Apply firewall filter ...` is shown in `linux` terminal.

To verify the firewall ACL is being applied, we ping 20.1.1.2 again and then check the firewall log.

```
ping 20.1.1.2 count 3
show firewall log
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 5)">Run this snippet</button>

This concludes our closed-loop automation using JET services.
