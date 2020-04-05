Now let's apply some Junos device configurations!

To configure general infrastructure services such as DNS and NTP, we will take advantage of configuration templating provided by Salt. The template will isolate the variable data like IP addresses, VLAN numbers, etc. from the network device feature configuration. With Salt, the variable data is naturally stored in the pillar system.

To do this, an SLS file is created in the pillar root directory containing the list of NTP and DNS servers.

```
cat /srv/pillar/infrastructure_data.sls
``` 
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('salt1', this)">Verify Output (Optional)</button>

To allow the Junos proxy minions to use the data defined in the `infrastructure_data.sls` file, we need to edit the top.sls file.

```
cat /srv/pillar/top.sls
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('salt1', this)">Verify Output (Optional)</button>

We also have to refresh the pillar data, so our minions can see the new pillar data.

```
salt 'vqfx1' saltutil.refresh_pillar
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('salt1', this)">Run this snippet</button>

Now let's create a configuration template - but before that, let's understand the placing of the template.

Salt has the concept of [file roots](https://docs.saltstack.com/en/latest/ref/file_server/file_roots.html) directory, which is configured as a `file_roots` parameter. This parameter is located in the '/etc/salt/master' configuration file on the Salt master, and this location is '/srv/salt' by default. Thus, in our case, we will use '/srv/salt' as the path.

The template will use Jinja syntax for the conditional loops, and the variables are accessed using `pillar.<var_name>`. We do have multiple options to create the template - Junos text configuration, XML, or Junos set commands. For now, let's go with a text configuration template.

```
cat /srv/salt/infrastructure_config.conf
``` 
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('salt1', this)">Run this snippet</button>

The next step is to create a salt SLS file, describing the state we want our 'vqfx1' and its configurations to be in. It will reference the [Junos state module] (https://docs.saltstack.com/en/latest/ref/states/all/salt.states.junos.html) to provision the configuration template.

```
cat /srv/salt/provision_infrastructure.sls
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('salt1', this)">Run this snippet</button>

To apply the configuration changes, we need to execute a 'state.apply' function.

```
salt 'vqfx1' state.apply provision_infrastructure
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('salt1', this)">Run this snippet</button>

Finally, let's check if the configurations were successfully loaded and committed.

```
show configuration | compare rollback 1
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>

