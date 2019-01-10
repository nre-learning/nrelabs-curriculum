## Network Automation with Salt

**Contributed by: [Sudhishna Sendhilvelan](https://github.com/Sudhishna) and [Vinayak Iyer](https://github.com/vinayak-skywalker)**

---

## Part 3 - Executing Junos commands in Salt

Let's explore the environment by executing some rpc's and cli commands on the Junos Proxy Minion.

The junos.cli execution module allows the Salt Master to run cli commands on the Juniper device. You can use the  format argument to specify whether you want to view the output in xml or text.

```
salt 'vqfx1' junos.cli 'show interfaces terse' format=xml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('salt1', 0)">Run this snippet</button>

The junos.rpc execution module runs RPC's on the Juniper device and returns the output on the terminal.
In order to get the the RPC command equivalent for a CLI command , we use 'display xml rpc' after the pipe symbol ( | )
For example,

```
show route | display xml rpc
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', 1)">Verify Output (Optional)</button>

From the above snippet, the RPC command equivalent for the 'show route' CLI command is 'get-route-information'
Let us now run the junos.rpc command. We can specify a destination file where the output is directed to. The 'terse' keyword allows you to obtain a summary output.

```
salt 'vqfx1' junos.rpc get-route-information /var/tmp/route.xml terse=True
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('salt1', 2)">Run this snippet</button>

To verify that the output was written to the '/var/tmp/route.xml', execute:

```
cat /var/tmp/route.xml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('salt1', 3)">Verify Output (Optional)</button>

That's it for now - hopefully you enjoyed learning about Salt, and are ready to go automate!
