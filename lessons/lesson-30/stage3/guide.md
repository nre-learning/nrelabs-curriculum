# Working with SaltStack
## Part 3 - Executing Junos commands in Salt Stack

Let's explore the environment by executing some rpc's and cli commands on the Junos Proxy Minion.


The junos.cli execution module allows the Salt Master to run cli commands on the Juniper device. You can use the  format argument to specify whether you want to view the output in xml or text. 

```
salt 'device_name' junos.cli 'show interfaces terse' format=xml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('saltstack1', 1)">Run this snippet</button>

The junos.rpc execution module runs RPC's on the Juniper device and returns the output on the terminal. 
In order to get the the RPC command equivalent for a CLI command , we use 'display xml rpc' after the pipe symbol ( | )
For example,

```
root@vqfx1> show route | display xml rpc
<rpc-reply xmlns:junos="http://xml.juniper.net/junos/10.1I0/junos">
    <rpc>
        <get-route-information>
        </get-route-information>
    </rpc>
    <cli>
        <banner></banner>
    </cli>
</rpc-reply>
```
From the above snippet, the RPC command equivalent for the 'show route' CLI command is 'get-route-information'
Let us now run the junos.rpc command. We can specify a destination file where the output is directed to. The 'terse' keyword allows you to obtain a summary output.

```
salt 'vqfx1' junos.rpc get-route-information /var/tmp/route.xml terse=True
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('saltstack1', 3)">Run this snippet</button>
