To manage a Junos device, we do not run an on box Salt Minion. Instead we make use of a [Proxy Minion](https://docs.saltstack.com/en/latest/topics/proxyminion/index.html). A Proxy minion can be run on the Salt Master or the Salt Minion.

Now let's configure the Proxy Minions. To do this, we must define the IP address, username, password and the proxy type which in our case is `junos`. All of these details are part of the vqfx1.sls. An SLS file is a Salt State file which can be in various formats. The simplest case is YAML, or it can be YAML+Jinja in case we require a templating language.
```
cat /srv/pillar/vqfx1.sls
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('salt1', this)">Verify Output (Optional)</button>


At this point we have to write the top.sls file which maps the Proxy Minion to the [pillar](https://docs.saltstack.com/en/latest/topics/pillar/) file that contains its corresponding details (`vqfx1.sls`)
```
cat /srv/pillar/top.sls
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('salt1', this)">Verify Output (Optional)</button>


We also have to configure the /etc/salt/proxy file to point to the Salt Master
```
cat /etc/salt/proxy
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('salt1', this)">Verify Output (Optional)</button>

The Proxy Minion is now configured and is ready to start.
```
salt-proxy --proxyid=vqfx1 -d
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('salt1', this)">Run this snippet</button>

( Note: it might take sometime for the key to be populated. Keep executing the below command every few seconds, until you see the "vqfx1" key listed. )
```
salt-key -L
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('salt1', this)">Run this snippet</button>

Let's accept the Salt Proxy Minion's public key using the command
```
salt-key --accept="vqfx1" -y
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('salt1', this)">Run this snippet</button>

Once this is done, the Salt Master will be able to communicate with the Salt Proxy Minion

Next, let's retrieve the device facts using the junos.facts execution module to verify that the device is connected to the Salt Master.
(Note: give a few seconds for the keys to sync, before trying this command)
```
salt 'vqfx1' junos.facts
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('salt1', this)">Run this snippet</button>

Now that the Salt Environment is setup, let's dive deeper into the world of Salt!
