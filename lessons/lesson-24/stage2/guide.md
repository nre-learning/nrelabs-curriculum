## Junos Automation with PyEZ

### Part 2 - Collect and Parse information from Junos Devices

#### 1. Connect to Junos device

Below is the boilerplate of PyEZ code from most PyEZ introduction

```
from jnpr.junos import Device
from pprint import pprint
dev = Device('vqfx1', user='root', password='VR-netlab9')
dev.open()
pprint(dev.facts)
```

To gather information from Junos, first import the `jnpr.junos.Device` module

```
python
from jnpr.junos import Device
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 1)">Run this snippet</button>

Create the Device object by providing the hostname, username and password, and then call the `open()` function

```
dev = Device('vqfx1', user='root', password='VR-netlab9')
dev.open()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 2)">Run this snippet</button>

Use the pretty print `pprint()` function to print device's basic info

```
from pprint import pprint
pprint(dev.facts)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 3)">Run this snippet</button>

The `dev.facts` consolidates the output of multiple RPC get requests, e.g. show chassis routing-engine, show version, show virtual-chassis, etc.

By default, PyEZ requires Junos device to enable port 830 by `set system services netconf ssh` config, but not all customer applied that since they don't use Netconf in their daily operation

Recommend adding the argument `port=22` to Device object for using port 22, instead of the default Netconf TCP port 830 for connecting to the device

```
dev = Device('vqfx1', user='root', password='VR-netlab9', port=22)
dev.open()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 4)">Run this snippet</button>

Almost every devices have SSH enabled. With this setting, the connection protocol is still Netconf over SSH, but over port 22, not port 830

#### 2. Collect data

##### 2.1 Figure out the RPC XML tag

After connected, to collect information, you have to figure out the XML tag for the request

First method is issue the command in Junos CLI, and add the `| display xml rpc` pipe, from the output, the `show system uptime` command XML tag is `<get-system-uptime-information>`

```
cli
show system uptime |display xml rpc
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', 5)">Run this snippet</button>

Second method is call the `display_xml_rpc()` function of Device object

```
print(dev.display_xml_rpc('show system uptime', format='text'))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 6)">Run this snippet</button>

After got the RPC tag, convert all the hyphens to underscores, as Python doesn't allow hyphen in the function name

Finally, append it to the `dev.rpc` object, it will return the XML object containing the `show system uptime` response in XML format

```
uptime = dev.rpc.get_system_uptime_information()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 7)">Run this snippet</button>

##### 2.2 Provide the RPC call arguments

In Junos CLI, you can provide a number of arguments, e.g., in `show interfaces`, specify the interface to be displayed, whether showing the statistics, or whether showing the data in brief format

To convert the arguments for PyEZ RPC call, first identify if it is key-value pair or just a flag to turn on some features

```
root@vqfx1> show interfaces ?
Possible completions:
  <[Enter]>            Execute this command
  <interface-name>     Name of physical or logical interface
...
  em3
...
  brief                Display brief output
...
  statistics           Display statistics and detailed output
```

In above sample output, interface name is key-value pair, key is the `interface-name`, value is the actual name of the target interface

Statistics is just a flag to ask the Junos to display the interface statistics data, there is no value associated

Brief is another flag to ask Junos to display the data in brief format

After identified all the necessary key-value pair and flag, you can provide them in the RPC call

For key-value pair, just give it as function argument, in the format of `key=value`, but again convert all the hyphens to underscores. E.g., convert `interface-name` to `interface_name` as below

```
print(dev.display_xml_rpc('show interfaces em3', format='text'))
intf = dev.rpc.get_interface_information(interface_name='em3')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 9)">Run this snippet</button>

For argument flag, provide it in the RPC call by assigning the flag as True value - `flag=True`

```
print(dev.display_xml_rpc('show interfaces statistics', format='text'))
intf = dev.rpc.get_interface_information(statistics=True)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 10)">Run this snippet</button>

If you want to combine multiple arguments in a single RPC call, e.g., show the statistics of em3 interface, provide both arguments to the call, separated by a comma

```
print(dev.display_xml_rpc('show interfaces em3 statistics', format='text'))
intf = dev.rpc.get_interface_information(interface_name='em3', statistics=True)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 11)">Run this snippet</button>

##### 2.3 Specify the output format

In Junos CLI, you can specify the output format in either default text, XML or JSON

```
root@vqfx1> show interfaces |display ?
Possible completions:
  json                 Show output in JSON format
  xml                  Show output as XML tags
```

Similar function exists in PyEZ, by default, the output format of PyEZ RPC call is XML

You can add a dictionary object as the first argument of the call to specify the desired format

The value of the format could be text or json. For text, it will return the same output as Junos CLI

```
intf = dev.rpc.get_interface_information({'format':'text'}, interface_name='em3', statistics=True)
print(intf.text)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 13)">Run this snippet</button>

Recommend to keep at default XML format, unless your program just simply displays the CLI output to user

XML is easier for data parsing and manipulation

The `format` dictionary **MUST** be placed in the first argument due to Python coding syntax, otherwise error will be prompted

#### 3. Parse information

Common question in using PyEZ is how to extract useful information from the collected XML data

From the `type()` function output, the returned object type is `lxml.etree._Element`

```
intf = dev.rpc.get_interface_information()
type(intf)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 14)">Run this snippet</button>

##### 3.1 Display the output as XML string

Import the etree module, use `tostring()` function to convert XML etree object to a XML string

```
from lxml import etree
etree.tostring(intf)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 15)">Run this snippet</button>

Please note that there are `\n` newline characters in the XML element text. Unfortunately, the returned XML format is different across Junos version and RPC request, some include the leading and trailing newline character, some are not

The unexpected newline character will affect our query result

For below query, `name` equal to `em3`, you would expect to return someting, but the result is a empty list

```
intf.xpath('physical-interface[name="em3"]')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 16)">Run this snippet</button>

To make the matching success, you have to use query string with newline character, `name` equal to `\nem3\n`

```
intf.xpath('physical-interface[name="\nem3\n"]')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 17)">Run this snippet</button>

Here comes another best practice recommendation when using `open()` function - besides the `port=22`, provide `normalize=True` argument as well

The usage of this argument is to ask PyEZ to strip out all the leading and trailing white spaces and newline characters when constructing the XML object

After reconnect to the device with normalization and collect data again, there is no more new line characters in the XML output

```
dev = Device('vqfx1', user='root', password='VR-netlab9', normalize=True, port=22).open()
intf = dev.rpc.get_interface_information()
etree.tostring(intf)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 18)">Run this snippet</button>

The query string `name` equal to `em3` returns result as expected now

```
intf.xpath('physical-interface[name="em3"]')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 19)">Run this snippet</button>

There are two options to display the XML in a better format for debugging purpose - provide the argument `pretty_print=True` in the `etree.tostring()` function call, or call the `etree.dump()` function

XML output of both functions contain auto-indent based on the XML tag hierarchy - easier to trace the element path when constructing the xpath statement

`etree.tostring()` produces the string object, for you to use `print()` to display it on screen, assign it to another variable, or save it to a file

`etree.dump()` must display the output to the screen, useful only when you're using Python interactive prompt

```
uptime = dev.rpc.get_system_uptime_information()
print(etree.tostring(uptime, pretty_print=True))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 20)">Run this snippet</button>

```
etree.dump(uptime)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 21)">Run this snippet</button>


##### 3.2 xpath tutorial

To illustrate the `xpath()` function, refer to below simplified and customized interface information XML object from Junos device

```
from lxml import etree
xml = etree.fromstring('<interface-information><ifd><name>ge-0/0/0</name><mtu>1514</mtu><ifl><name>ge-0/0/0.0</name><family>inet</family></ifl></ifd><ifd><name>ge-0/0/1</name><mtu>9216</mtu><ifl><name>ge-0/0/1.100</name><family>bridge</family></ifl><ifl><name>ge-0/0/1.200</name><family>inet</family></ifl></ifd></interface-information>')
print(etree.tostring(xml, pretty_print=True))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 22)">Run this snippet</button>

Find out where is the current node, use `xpath()` function with a single got `'.'` as the argument. Like Linux directoy structure, single dot means current node, and the result is `interface-information`, which indicates where are you now

```
xml.xpath('.')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 23)">Run this snippet</button>

To query all IFD nodes, call the `xpath()` function with argument `'ifd'`

```
xml.xpath('ifd')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 24)">Run this snippet</button>

For `xpath()` function, it will start searching from the child of its current node - `<interface-information>` here

The argument means search and return all the `<ifd>` nodes that is the child of current node `<interface-information>`

Two node elements are returned, represent `ge-0/0/0` and `ge-0/0/1` interface

Go deeper in the XML hierarchy, to query all IFL nodes, call the `xpath()` function with argument `'ifd/ifl'`

```
xml.xpath('ifd/ifl')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 25)">Run this snippet</button>

The concept is quite similar to Linux directory structure, use the slash `/` to go to next level

It returns three element nodes, one under ifd `ge-0/0/0` and the other two under ifd `ge-0/0/1`

To get all IFDs that have MTU 1514, provide the argument `'ifd'`, but after the `'ifd'`, now put a square bracket enclosing the condition `mtu="1514"`

```
xml.xpath('ifd[mtu="1514"]')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 26)">Run this snippet</button>

Square bracket in `xpath()` means a condition statement, above `xpath()` function returns all the `<ifd>` elements, that has a child node called `<mtu>`, and the value of that `<mtu>` element is equal to 1514

Although the `xpath()` function returns single `ifd` element above, it is still enclosed in square bracket meaning it is list type

To get all the IFL nodes, in which the MTU of the parent IFD is 9216?

The target node is a child but the condition is applied to the parent node

Same as 'get all IFL node' scenario, query the `xpath()` function with argument `'ifd/ifl'`, but now condition is applied onto the `<ifd>`, so adding the square bracket after the `ifd`, with the condition inside the bracket `mtu="9216"`

The result of below `xpath()` is two `<ifl>` element nodes, correspond to two `<ifl>` under `ge-0/0/1`

```
xml.xpath('ifd[mtu="9216"]/ifl')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 27)">Run this snippet</button>

For multiple conditions filtering, to get all IFD `<name>` nodes which fulfill two conditions:
  - MTU equal to 1514
  - contains more than one `<ifl>` child

Identify the requirement is to get IFD `<name>` node, so the xpath is `'ifd/name'`

First condition is MTU equal to 1514, add the first square bracket `[mtu="1514"]` after `ifd`, because `<mtu>` is the child of `<ifd>`

Second condition is more than one `<ifl>` child, use the xpath function `count()`, put the second square bracket `[count(ifl)>1]` just after the first one

```
xml.xpath('ifd[mtu="1514"][count(ifl)>1]/name')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 28)">Run this snippet</button>

In `xpath()`, two consecutive square brackets means both conditions have to be fulfilled before extraction

Result is empty list, because there is no IFD matching both conditions

Change a little bit on the condition, from AND to OR, to get all the IFD `<name>` that matches either one condition

Put both condition statements inside the same square bracket, and put a `or` operator between them

```
xml.xpath('ifd[mtu="1514" or count(ifl)>1]/name')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 29)">Run this snippet</button>

Result is two `<ifd>` element nodes, because both `ge-0/0/0` and `ge-0/0/1` meet either conditions

Two methods to get the actual text string, e.g., `'ge-0/0/0'` from the XML object

1st, get to the `<name>` node directly, so there is `/name` at the end of the `xpath()`, and then use list index `[0]` to get the element and access its `text` attribute

```
xml.xpath('ifd[mtu="1514" or count(ifl)>1]/name')[0].text
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 30)">Run this snippet</button>

2nd, get to the `<ifd>` node, specify the list index `[1]`, and then use the `findtext()` function to query the text attribute of the `<name>` element node

```
xml.xpath('ifd[mtu="1514" or count(ifl)>1]')[1].findtext('name')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 31)">Run this snippet</button>

Use `[0]` in 1st example to get the first element, so return `ge-0/0/0`; use `[1]` in 2nd example to get the second element, so return `ge-0/0/1`

First one looks simple, but if you want to get multiple attributes, e.g., get the name, operation status, SNMP index, description, etc. from the IFD, you should use second method
  - Get the `<ifd>` element node
  - Use multiple `findtext()` function to extract the text of its childen

Let's try much more complicated condition here, get all IFD `<name>` nodes that:
  - has MTU 9216
  - has child IFL that is:
      - unit 100
      - family bridge

First condition is MTU equal to 9216, second one is having a child IFL, and that particular IFL node should be unit 100 and family bridge

```
xml.xpath('ifd[mtu="9216"][ifl[contains(name,".100")][family="bridge"]]/name')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 32)">Run this snippet</button>

Rewrite the `xpath()` statement in a hierarchical format for easier trace

```
xml.xpath('ifd \
  [mtu="9216"] \
  [ifl \
    [contains(name,".100")] \
    [family="bridge"] \
  ] \
/name')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 33)">Run this snippet</button>

To decode the xpath, first is ignoring all the square brackets, and the resulting xpath is `'ifd/name'`, that means this xpath will return the `<name>` element node under `<ifd>`

1st condition is MTU equal to 9216, put that in square bracket `[mtu="9216"]` and place it just after `ifd`

2nd condition is it should contain at least one child IFL, so second bracket follows and put `ifl` here

Next condition is related to IFL, it should be configured as unit 100, use `contains()` function here to check if the name of IFL contains `.100`, which represents the unit number

This condition is again put into another bracket, and this bracket is put after `ifl` because the `<name>` element is the child of `<ifl>`

Here, it shows that `xpath()` function supports nested condition by embedding the bracket inside another bracket

Last condition is the unit 100 IFL should be configured as family bridge, put another bracket `[family="bridge"]` next to the first one

Whole `xpath()` statement will return a single `<name>` element node, which should be `ge-0/0/1.100` that is the only one fulfill all criteria

Last thing for `xpath()` function is double slash `//`

It means finding all the elements under the nodes, in any hierarchy, not just searching its direct children

First, use single slash `/`, it will return all `<name>` element nodes which are directly under the `<ifd>`, result is two elements - `ge-0/0/0` and `ge-0/0/1`

```
xml.xpath('ifd/name')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 34)">Run this snippet</button>

Second, use double slash `//`, it will return all `<name>` element nodes under `<ifd>`, or all its children (e.g., `<ifl>`), result is five elements including all IFD and IFL name

```
xml.xpath('ifd//name')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 35)">Run this snippet</button>

As shown in the for loop output, all `ifd/name` and `ifd/ifl/name` are returned

<pre>
for name in xml.xpath('ifd//name'):
    print(name.text)

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 36)">Run this snippet</button>


##### 3.3 xpath for Junos output

Back to actual XML output from Junos device, to get the `show system uptime` output, you have to call the `get_system_uptime_information()` function, and save the result to a variable

```
uptime = dev.rpc.get_system_uptime_information()
uptime = uptime.xpath('//system-uptime-information')[0]
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 37)">Run this snippet</button>

Current node of the uptime XML object is `<system-uptime-information>`

```
uptime.tag
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 38)">Run this snippet</button>

To get the system time, use below `xpath` and since the return type is a list, further give the list index `[0]` and then get the text attribute

```
uptime.xpath('uptime-information/date-time')[0].text
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 39)">Run this snippet</button>

Get the `show interfaces` output and save to a variable

```
intf = dev.rpc.get_interface_information()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 40)">Run this snippet</button>

Current node is the top XML element `<interface-information>`

```
intf.tag
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 41)">Run this snippet</button>

To extract all the `<physical-interface>` elements, use `xpath()` function with argument `'physical-interface'`, and the result is a list contains all the `<physical-interface>` element nodes

```
intf.xpath('physical-interface')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 42)">Run this snippet</button>


Use Python `len()` function to count the number of elements in a list

Check how many physical interface is in the Junos device

```
len(intf.xpath('physical-interface'))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 43)">Run this snippet</button>

By the `xpath()` condition feature, count how many physical interface has MTU 1514

```
len(intf.xpath('physical-interface[mtu="1514"]'))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 44)">Run this snippet</button>

Out of those MTU 1514 physical interfaces, how many has configured at least one logical interface

```
len(intf.xpath('physical-interface[mtu="1514"]/logical-interface'))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 45)">Run this snippet</button>

After determined the xpath, use a for loop to iterate over the returned list, and then print the IFD name, IFL name and the family of those 9 logical interfaces

<pre>
for ifl in intf.xpath('physical-interface[mtu="1514"]/logical-interface'):
    print('IFD: %s, IFL: %s, family: %s' % (
        ifl.findtext('../name'),
        ifl.findtext('name'),
        ifl.findtext('address-family/address-family-name')
    ))

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 46)">Run this snippet</button>

##### 3.4 find(), findall() & findtext() function

Sometimes you may see `find()`, `findall()`, and `findtext()` function in other's Python code

They all produce the same output

```
uptime.xpath('uptime-information/date-time')[0].text
uptime.findall('uptime-information/date-time')[0].text
uptime.find('uptime-information/date-time').text
uptime.findtext('uptime-information/date-time')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 47)">Run this snippet</button>

For `findall()`, it has the simple subset function of `xpath()`; same as `xpath()`, it returns list object

`findall()` doesn't support `OR` operator, nested conditions, and xpath function inside the square brackets

Supported queries:

```
xml.findall('ifd/ifl/name')
xml.findall('ifd[mtu="1514"]')
xml.findall('ifd[mtu="1514"][ifl]')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 48)">Run this snippet</button>

Unsupported `OR` operator:

```
xml.findall('ifd[mtu="1514" or ifl]')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 49)">Run this snippet</button>

Unsupported nested conditions:

```
xml.findall('ifd[ifl[family="bridge"]]')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 50)">Run this snippet</button>

Unsupported xpath function inside conditions:

```
xml.findall('ifd[count(ifl)>1]')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 51)">Run this snippet</button>

Suggest to use `xpath()` function in querying data as it has much more features compared to `findall()`

Main discrepancy between `xpath()`, `find()`, and `findtext()` is the return object type. `find()` will return XML element, and `findtext()` will return a string

```
type(uptime.xpath('uptime-information/date-time'))
type(uptime.find('uptime-information/date-time'))
type(uptime.findtext('uptime-information/date-time'))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 52)">Run this snippet</button>

`xpath()` is mainly used in a for loop to iterate over the elements; `find()` is used for getting the desired element node directly

If there is more than one element matching the `find()` function, it returns the first element only

```
intf.xpath('physical-interface')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 53)">Run this snippet</button>

```
intf.find('physical-interface')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 54)">Run this snippet</button>

Sometimes if you're sure that the result contains one element only, e.g., the system uptime `<date-time>` node, use `find()` function to avoid adding extra `[0]` list index

`find()` and `findtext()` inherit the same capability as `findall()`, advanced searching and filtering are not supported

`findtext()` function is actually a short form of `find().text`

```
uptime.find('uptime-information/date-time').text
uptime.findtext('uptime-information/date-time')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 55)">Run this snippet</button>


##### 3.5 Recommend: xpath() + findtext()

Recommend to use the combination of `xpath()` and `findtext()` - use `xpath` in a for loop and use `findtext` to get the element data

Why don't standardize all the call to use `xpath()` given that it has the most advanced feature, but use `findtext()` instead to extract the element text attribute?

As in below output, `xpath()` returns a list object, if you use `xpath()` function to get the element text, you have to use `[0]` list index here

Not all physical interface contains the MAC address, in below example, once the loop hit an interface without MAC, accessing to its `[0]` list index will throw the list index out of range exception, because `xpath('hardware-physical-address')` may return a empty list which doesn't have any index value

<pre>
for ifd in intf.xpath('physical-interface'):
    name = ifd.xpath('name')[0].text
    mac = ifd.xpath('hardware-physical-address')[0].text
    print('%s has MAC address %s' % (name, mac))

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 56)">Run this snippet</button>

To avoid the exception, write extra if statement for each xpath result, to check the length of the returned list, if it's greater than zero, access the list index to get the text attribute

<pre>
for ifd in intf.xpath('physical-interface'):
    name_xpath = ifd.xpath('name')
    if len(name_xpath):
        name = name_xpath[0].text
    else:
        name = None
    mac_xpath = ifd.xpath('hardware-physical-address')
    if len(mac_xpath):
        mac = mac_xpath[0].text
    else:
        mac = None
    print('%s has MAC address %s' % (name, mac))

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 57)">Run this snippet</button>

So it's recommended to use `findtext()` function here, if there is no element returned, the `findtext()` function simply returns `None` value and will not throw any exception

<pre>
for ifd in intf.xpath('physical-interface'):
    name = ifd.findtext('name')
    mac = ifd.findtext('hardware-physical-address')
    print('%s has MAC address %s' % (name, mac))

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 58)">Run this snippet</button>

