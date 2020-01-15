# Automated STIG Compliance Validation
## Part 3  - STIG Compliance Validation with custom Python scripts

In the previous labs, we used NAPALM and JSNAPy to check the [STIG for Juniper devices](https://stigviewer.com/stig/infrastructure_router__juniper/) were found to be in compliance for the V-3969 finding.  NAPALM and JSNAPy are great for many compliance checks like looking for the existence of a configuration setting, but they may fall short when the check requires more detailed analysis of the network devices configuration and operational state or we need some "glue" to bind mutiple compliance checks together or report back findings in a specific manner.  

In this lab, we'll look at what it takes to automate a STIG compliance check using python scripts and leveraging the [PyEZ framework](https://labs.networkreliability.engineering/labs/?lessonId=24&lessonStage=1) and [PyEZ Tables and Views] (https://labs.networkreliability.engineering/labs/?lessonId=24&lessonStage=5). We'll write our own custom table to retrieve specific configuration items to make it easier to deal with XML formatted data.  

Custom Op and Config tables are written in [YAML](https://labs.networkreliability.engineering/labs/?lessonId=14&lessonStage=1), their usage wth PyEZ is documented [here](https://pyez.readthedocs.io/en/latest/TableView.html).

We'll begin by starting up the python interpretter, defining a PyEZ device and connecting to 'vqfx1'.

```
python -Wi
from jnpr.junos import Device
dev = Device('vqfx1', user='antidote', password='antidotepassword')
dev.open()


``` 
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>


Because there isn't an operational Junos command to tell us what SNMP communities are in use on a device, we'll have to examine the configuration to glean this information.  We'll take a look at the SNMP stanza in XML format to examine the elements we need to inspect with our script.   

```
show configuration snmp | display xml
``` 
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>

Since we are examining the configuration, we need to use a ConfigTable, which maps XML paths, elements and attributes into easier to understand and parse YAML syntax.  We need a list of communities, and their authorization level.  All of the relevant configuration we need to check is located under the XML element `community` with a parent of `snmp`.  We can translate this into an XPATH of `snmp/community` to use in our queries.  The communities are all listed at the XPATH `snmp/community`, so we will define a table called `SNMPTable`, and instruct it to fetch the configuration that matches this XPATH statment with a `get` instruction.  This will create a nested dictionary of element names to their values starting at our XPATH.

We can save this in python to a variable we'll call `SNMPYAML`.

```
SNMPYAML = """
---
SNMPTable:
    get: snmp/community
"""
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Next we need to define a view, which contains all of the XML element we're interested in, and map their names and values into a nested dictionary which is easy to query and manipulate with python.  We can concatenate this onto our `SNMPYAML` variable.

```
SNMPYAML += """
    view: SNMPTableView

SNMPTableView:
    fields:
        name: name
        authorization: authorization
"""
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Then we bind this to our device as a new table definition.  We'll need the yaml python module, and the FactoryLoader python module from PyEZ.

```
import yaml
from jnpr.junos.factory.factory_loader import FactoryLoader
globals().update(FactoryLoader().load(yaml.load(SNMPYAML)))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

We can then fetch the configuraiton from the device. After the following snippet is run, you should see that we successfully retrieved 1 item, matching the number of communities that we have defined on vqfx1.

```
SNMPTable(dev).get()
```

<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Checking the type of the object, we can see that this is a `jnpr.junos.factory.CfgTable.SNMPTable` class.

```
type(SNMPTable(dev).get())
```

<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Using the builtin python `dir` function, we can take a quick peek at all of the attributes and objects that are part of our SNMPTable.

```
dir(SNMPTable(dev).get())
```

<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

This has all of the elements required for a dictionary, so we should be able to iterate over our `SNMPTable` object, just like a dictionary.   Incorporating this into a loop function, we can check the access level of each community and print out a nasty message if it's not `read-only`.

<pre>
for mydev in SNMPTable(dev).get():
    if mydev.authorization != "read-only":
        print "VIOLATION: SNMPv2 COMMUNITY {} HAS {} ACCESS".format(mydev.name,
                                                                    mydev.authorization)

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

We'll can apply a quick fix to our device.

```
configure
set snmp community antidote authorization read-only
commit and-quit
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>

And rerun our check.  Nothing should be reported back if we correctly fixed everything.
<pre>
for mydev in SNMPTable(dev).get():
    if mydev.authorization != "read-only":
        print "VIOLATION: SNMPv2 COMMUNITY {} HAS {} ACCESS".format(mydev.name,
                                                                    mydev.authorization)

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Running this from a python shell every time, on multiple devices can be tedious and error prone.  To make this easier we can package the logic up in a python script, and save the ConfigTable YAML definition to a file to be loaded at runtime.

We'll start by exiting the python shell, and making a directory to keep our Config and Op tables in called simply `tables`.  We'll be able to import these files into a python script (with a bit of preparation). We'll also create an `__init__.py` file since we're using Python2 to allow us to treat the directory as a python package.
```
exit()
cd /antidote/stage3/
mkdir tables
touch tables/__init__.py
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

We'll drop our YAML definition from above into a file called `config_tables.yml` in the directory we just created.  
```
cat > tables/config_tables.yml << EOF
---
SNMPTable:
    get: snmp/community
    view: SNMPTableView

SNMPTableView:
    fields:
        name: name
        authorization: authorization
EOF
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>


We'll create an accompaning python file to allow us to import this YAML file as a module, doing the work of `FactoryLoader` above.  

```
cat > tables/config_tables.py << EOF
import jnpr.junos
if jnpr.junos.__version__[0] == '1':
    from jnpr.junos.factory import loadyaml
    from os.path import splitext
    _YAML_ = splitext(__file__)[0] + '.yml'
    globals().update(loadyaml(_YAML_))
else:
    from jnpr.junos.factory import loadyaml
    from os.path import splitext
    _YAML_ = splitext(__file__)[0] + '.yml'
    catalog = loadyaml( _YAML_ )
    globals().update(loadyaml(_YAML_))
EOF
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

We'll start to assemble our python script.  As a nod to the name of the vulnerability we're checking, we'll call this script `V_3969.py`.  Since we're running this in a Linux container, we'll start off our script with a [shebang](https://en.wikipedia.org/wiki/Shebang_%28Unix%29) line `#!/usr/bin/env python` to provide some flexibility and run the first python executable in our bash environments `PATH` variable.

```
cat > V_3969.py << EOF
#!/usr/bin/env python

EOF
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Next, we'll import all of the python modules needed to run our script, starting with the `Device` module from the `jnpr.junos` package.  We'll also import our `SNMPTable` ConfitTable we created earlier and placed in the `tables` directory, as well as a `warnings` module which we'll use to clean up some of our output at runtime.

```
cat >> V_3969.py << EOF
from jnpr.junos import Device
import warnings
warnings.filterwarnings("ignore")
from tables.config_tables import SNMPTable

EOF
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

We'll turn the brunt of our code into a Python function for the checking done above.  This check is for a STIG Rule called `NET0984`, which is a component of the STIG vulnerability `V-3969`.  A STIG vulnerability can consist of multiple rules, however in this case the only rule that we need to check is `NET0984`.  It will operate on any PyEZ `junpr.junos` Device which we'll pass to the function as an argument.  We'll add in a variable `check_pass` to keep track if we had any communties that violated our check for an overall pass/fail grade, some comments, and print statements that give some more information about what we've found, and what we need to do to fix any security vulnerabilities encountered.

At the end of our function, we'll return our pass/fail grade.

```python
cat >> V_3969.py << EOF
def NET0894(device):
    """
    Check for SNMP write access for STIG Rule NET0894
    device should be a PyEZ jnpr.junos.Device object
    """

    # Variable to keep track of if the check has passed for all 
    # of our communities
    check_pass = True

    # Some extra information on what the script is doing
    print "CHECKING NET0894: This examines the configuration for",
    print "SNMPv2 communties with write access."

    # Retrieve the SNMP configuration table
    snmp = SNMPTable(device).get()

    # Loop through all the communties configured on the device
    for mydev in snmp:
        # check that the authorization is 'read-only'
        if mydev.authorization != "read-only":
            # print a violation message
            print "VIOLATION: SNMPv2 COMMUNITY {}".format(mydev.name)
            print "IS NOT RESTRICTED TO READ-ONLY ACCESS"

            # print some informaiton on how to fix the problem
            print "JUNOS FIX: set snmp community {}".format(mydev.name)
            print "authorization read-only"
            print "\n"

            # set our pass/fail grade to false
            check_pass = False

    # print the overall outcome of our rule check
    if check_pass:
        print "NET0894 PASSED"
    else:
        print "NET0894 FAILED"

    return check_pass

EOF
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Then we'll add the main loop.  First it will define our PyEZ Device for `vqfx1`, then call our function using this device as the argument.  Then depending on what we receive back from our function, we'll print an overall pass/fail grade, and finallly nicely close the connection to `vqfx1`.

```python
cat >> V_3969.py << EOF
# define a PyEz junos device for vqfx1
dev = Device(host="vqfx1",
             user="antidote",
             password="antidotepassword")

# open the device
dev.open()

# Evaluate it and save the results in a variable pass_fail
pass_fail = NET0894(dev)
print "VULNERABILITY ASSESSMENT FOR {}".format(dev.hostname)
print "FOR V-3969: ",
if pass_fail:
    print "PASSED"
else:
    print "FAILED!!!"

# close the device
dev.close()

EOF
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

We can take a look at our completed script which we built with a series of cat commands and [here](http://tldp.org/LDP/abs/html/here-docs.html) documents.  Normally you'd use your favorite editor like vi, Atom, IDLE, PyCharm, etc.  

```
cat V_3969.py
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>


Finally, again since we're running this from a Linux container, we'll mark our script executable so we can run it directly from the bash shell.

```
chmod a+x V_3969.py
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

To make things interesting, we'll add in some new SNMP community vulnerabilies onto `vqfx1`.
```
configure
set snmp community public 
set snmp community what_me_worry authorization read-write
set snmp community no_problem authorization read-write
commit and-quit
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>

And at last we can run our script.
```
./V_3969.py
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>


So let's fix our problems that we introduced, and re-run our script.  Note that our script actually told us the commands we 
need in order to fix the issues that were found.

```
configure
set snmp community public authorization read-only
set snmp community what_me_worry authorization read-only
set snmp community no_problem authorization read-only
commit and-quit
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>

```
./V_3969.py
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

This check is relatively simple, but can be used as a starting point or a building block to do much more complicated security assessments.

