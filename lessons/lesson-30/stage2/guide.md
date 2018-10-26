# Working with SaltStack
## Part 2 - Junos Proxy Minions

To manage a Junos device, we do not run an on box Salt Minion. Instead we make use of a [Proxy Minion](https://docs.saltstack.com/en/latest/topics/proxyminion/index.html). A Proxy minion can be run on the Salt Master or the Salt Minion. 


Now let's configure the Proxy Minions. To do this, we must define the IP address, username, password and the proxy type which in our case is junos. All of these details are part of the vqfx1.sls . An SLS file is a SaltStack State file which can be in various formats. The simplest case is YAML, or it can be YAML+Jinja in case we require a templating language. 

```
antidote@saltstack1:~$ cat /srv/pillar/vqfx1.sls
proxy:
  proxytype: junos
  host: 10.0.0.15
  username: root
  password: VR-netlab9
```

At this point we have to write the top.sls file whoch maps the Proxy Minion to the [pillar](https://docs.saltstack.com/en/latest/topics/pillar/) file that contains its corresponding details (vqfx1.sls)

```
antidote@saltstack1:~$ cat /srv/pillar/top.sls
base:
  'vqfx1':
    - vqfx1
```

We also have to configure the /etc/salt/proxy file to point to the Salt Master

```
master: 172.17.0.2
```

The Proxy Minion is now configured and is ready to start. 

```
salt-proxy --proxyid=vqfx1 -d
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('saltmaster', 3)">Run this snippet</button>

Let's accept the Salt Proxy Minion's public key using the command

```
salt-key --accept=“vqfx1”
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('saltmaster1', 4)">Run this snippet</button>

Once this is done, the Salt Master will be able to communicate with the Salt Proxy Minion

Next, let's retrieve the device facts using the junos.facts execution module to verify that the device is connected to the Salt Master.

```
salt 'vqfx1' junos.facts
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('saltmaster1', 5)">Run this snippet</button>

Now that the SaltStack Environment is setup, let's dive deeper into the world of Salt!
