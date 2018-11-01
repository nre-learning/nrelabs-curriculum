<style type="text/css">
.btn-alert {
  color: #FFFFFF;
  background-color: #C27C78;
  border-color: #C27C78;
}
.btn-alert:hover {
  color: #FFFFFF;
  background-color: #B65D5D;
  border-color: #B65D5D;
}
</style>
## Junos Automation with PyEZ

*Contributed by Raymond Lam @jnpr-raylam*

---

### Part 3 - Parse information

#### 1. Display the output as XML string

In previous section, we assigned `intf` variable with the returned object from `get_interface_information()` RPC function call.

Let's connect to Junos device and assign this variable again, this time we use `terse=True` argument to get `show interfaces terse` output.

```
python
from jnpr.junos import Device
dev = Device('vqfx', user='root', password='VR-netlab9', port=22)
dev.open()
intf = dev.rpc.get_interface_information(terse=True)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 0)">Run this snippet</button>

From `type()` function output, we know the object type is `lxml.etree._Element`:

```
type(intf)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 1)">Run this snippet</button>

To display the `xml.etree` object as XML string, we have to import `etree` module, and then use `tostring()` function to convert XML etree object to a XML string.

```
from lxml import etree
etree.tostring(intf)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 2)">Run this snippet</button>

Do you aware there are `\n` newline characters in the XML element text? The returned XML format sometimes is different across Junos version and RPC request, some include the leading and trailing newline character, some are not.

The unexpected newline character will affect our query result. For below query, `name` equal to `em3`, you would expect to return something, but the result is a empty list. 
*(To filter data from XML object, give the condition inside a square bracket. We will explain the details later, no worries)*

```
intf.xpath('physical-interface[name="em3"]')
```
<button type="button" class="btn btn-alert btn-sm" onclick="runSnippetInTab('linux', 3)">Run this snippet and get empty list</button>

To make the matching success, you have to use query string with newline character, `name` equal to `\nem3\n`

```
intf.xpath('physical-interface[name="\nem3\n"]')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 4)">Run this snippet</button>

Here comes another best practice recommendation when using `open()` function - besides the `port=22`, provide `normalize=True` argument as well.

The usage of this argument is to ask PyEZ to strip out all leading and trailing white spaces and newline characters when constructing XML object.  After reconnect to the device with normalization and collect data again, there is no more new line characters in the XML output.

```
dev = Device('vqfx', user='root', password='VR-netlab9',
             normalize=True, port=22).open()
intf = dev.rpc.get_interface_information(terse=True)
etree.tostring(intf)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 5)">Run this snippet</button>

The query string `name` equal to `em3` should return expected result now:

```
intf.xpath('physical-interface[name="em3"]')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 6)">Run this snippet</button>

There are two options to display XML string in a better format for debugging purpose - provide the argument `pretty_print=True` in the `etree.tostring()` function call, or call the `etree.dump()` function.

  - `etree.tostring()` produces the string object, for you to use `print()` to display it on screen, assign it to another variable, or save it to a file

    ```
    uptime = dev.rpc.get_system_uptime_information()
    print(etree.tostring(uptime, pretty_print=True))
    ```
    <button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 7)">Run this snippet</button>

  - `etree.dump()` displays the output to the screen, useful only when you're using Python interactive prompt

    ```
    etree.dump(uptime)
    ```
    <button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 8)">Run this snippet</button>

XML output of both functions contain auto-indent based on the XML tag hierarchy, it's easier to trace the element path when constructing the xpath statement.




#### 2. xpath tutorial

We just use `xpath()` function to query data on XML object. xpath is a powerful and highly flexible tool for data parsing.

To illustrate the `xpath()` function, we use an simplified and customized interface information XML object from Junos device as shown below:

```
    <interface-information>
      <ifd>
        <name>ge-0/0/0</name>
        <mtu>1514</mtu>
        <ifl>
          <name>ge-0/0/0.0</name>
          <family>inet</family>
        </ifl>
      </ifd>
      <ifd>
        <name>ge-0/0/1</name>
        <mtu>9216</mtu>
        <ifl>
          <name>ge-0/0/1.100</name>
          <family>bridge</family>
        </ifl>
        <ifl>
          <name>ge-0/0/1.200</name>
          <family>inet</family>
        </ifl>
      </ifd>
    </interface-information>
```
You may use below code snippet to assign that XML object to `xml` variable. We will use this `xml` variable throughout this section to illustrate `xpath()` function.

```
xml = etree.fromstring('<interface-information><ifd><name>ge-0/0/0</name><mtu>1514</mtu><ifl><name>ge-0/0/0.0</name><family>inet</family></ifl></ifd><ifd><name>ge-0/0/1</name><mtu>9216</mtu><ifl><name>ge-0/0/1.100</name><family>bridge</family></ifl><ifl><name>ge-0/0/1.200</name><family>inet</family></ifl></ifd></interface-information>')
print(etree.tostring(xml, pretty_print=True))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 10)">Run this snippet</button>

---

First, to find out where is current node, use `xpath()` function with a single dot `'.'` as argument. Like Linux directory structure, single dot means current node.

```
xml.xpath('.')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 11)">Run this snippet</button>

**Result:** Return `interface-information`, which indicates where are you now.

---

To query all IFD nodes, call `xpath()` function with argument `'ifd'`.  The argument means search and return all `<ifd>` nodes that are child of current node `<interface-information>`.

```
xml.xpath('ifd')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 12)">Run this snippet</button>

**Result:** Two node elements are returned, represent `ge-0/0/0` and `ge-0/0/1` interface.

---

Go deeper in the XML hierarchy, to query all IFL nodes, call `xpath()` function with argument `'ifd/ifl'`.  The concept is quite similar to Linux directory structure, use the slash `/` to go to next level.

```
xml.xpath('ifd/ifl')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 13)">Run this snippet</button>

**Result:** Return three element nodes, one under IFD `ge-0/0/0` and the other two under IFD `ge-0/0/1`.

---

Now, let's provide filtering conditions to `xpath()` function. To get all IFDs that have MTU 1514, provide the argument `'ifd'`, and this time append a extra square bracket enclosing condition `mtu="1514"`.

Square bracket in `xpath()` means a condition statement.  It will return all `<ifd>` elements that have a child node called `<mtu>`, and the value of that `<mtu>` element is equal to 1514.

```
xml.xpath('ifd[mtu="1514"]')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 14)">Run this snippet</button>

**Result:** One node element is returned which corresponds to `ge-0/0/0`.

---

How about to get all IFL nodes, in which MTU of parent IFD is 9216?  Please note that the target node is a child but condition is applied to parent node.

Same as 'get all IFL node' scenario, query `xpath()` function with argument `'ifd/ifl'`, but now condition is applied onto `<ifd>`, so adding a square bracket after `ifd`, with the condition `mtu="9216"` inside the bracket.


```
xml.xpath('ifd[mtu="9216"]/ifl')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 15)">Run this snippet</button>

**Result:** Two `<ifl>` element nodes returned, correspond to two `<ifl>` under `ge-0/0/1`.

---

For multiple conditions filtering, to get all IFD `<name>` nodes which fulfill two conditions:
  - MTU equal to 1514
  - contains more than one `<ifl>` child

Requirement is to get IFD `<name>` node, so xpath argument is `'ifd/name'`.

First condition is MTU equal to 1514, add a first square bracket `[mtu="1514"]` after `ifd`, because `<mtu>` is child of `<ifd>`.

Second condition is more than one `<ifl>` child, use xpath function `count()`, put a second square bracket `[count(ifl)>1]` just after the first one.

Below is the result xpath function call:

```
xml.xpath('ifd[mtu="1514"][count(ifl)>1]/name')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 16)">Run this snippet</button>

In `xpath()`, two consecutive square brackets means both conditions have to be fulfilled before extraction.

**Result:** Return empty list, because there is no IFD matching both conditions.

---

Change a little bit on the condition, from AND to OR, to get all IFD `<name>` that matches either one condition.

To do that, put both condition statements inside the same square bracket, and put a `or` operator between them:

```
xml.xpath('ifd[mtu="1514" or count(ifl)>1]/name')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 17)">Run this snippet</button>

**Result:** Two `<ifd>` element nodes returned, because both `ge-0/0/0` and `ge-0/0/1` meet either conditions.

---

There are two methods to get actual text string, e.g., `'ge-0/0/0'` from the XML object.

  1. Get to the `<name>` node directly, so there is `/name` at the end of the `xpath()`, and then use list index `[0]` to get the element and access its `text` attribute:

    ```
    xml.xpath('ifd/name')[0].text
    ```
    <button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 18)">Run this snippet</button>

    Use index `[0]` here to get the first element, so result is `ge-0/0/0`.

  2. Get to the `<ifd>` node, specify the list index `[1]`, and then use the `findtext()` function to query the text attribute of the `<name>` element node:

    ```
    xml.xpath('ifd')[1].findtext('name')
    ```
    <button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 19)">Run this snippet</button>

    Use index `[1]` here to get the second element, result is `ge-0/0/1`.

First method looks simple, but if you want to get multiple attributes, e.g., get the name, operational status, SNMP index, description, etc. from the IFD, you should use second method - assign the `<ifd>` element node to a variable, and use multiple `findtext()` function to extract the text of its children.

---

Let's try much more complicated condition here, get all IFD `<name>` nodes that:
  - has MTU 9216
  - has child IFL that is:
      - unit 100
      - family bridge

First condition is MTU equal to 9216, second one is having a child IFL, and that particular IFL node should be unit 100 and family bridge.

```
xml.xpath('ifd[mtu="9216"][ifl[contains(name,".100")][family="bridge"]]/name')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 20)">Run this snippet</button>

Rewrite the `xpath()` statement in a hierarchical format for easier trace:

```
xml.xpath('ifd \
  [mtu="9216"] \
  [ifl \
    [contains(name,".100")] \
    [family="bridge"] \
  ] \
/name')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 21)">Run this snippet</button>

To decode the xpath, first is ignoring all square brackets, and the resulting xpath is `'ifd/name'`, that means this xpath will return the `<name>` element node under `<ifd>`.

1st condition is MTU equal to 9216, put that in square bracket `[mtu="9216"]` and place it just after `ifd`.

2nd condition is it should contain at least one child IFL, so second bracket follows and starts with `ifl`.

Next condition is related to IFL, it should be configured as unit 100, use `contains()` function to check if the name of IFL contains `.100`, which represents the unit number. This condition is again put into another bracket, and this bracket is put after `ifl` because the `<name>` element is child of `<ifl>`.

Here, it shows that `xpath()` function supports nested condition by embedding a bracket inside another bracket.

Last condition is the unit 100 IFL should be configured as family bridge, put another bracket `[family="bridge"]` next to the first one.

**Result:** The `xpath()` statement returns a single `<name>` element node `ge-0/0/1.100` which is the only IFL fulfill all criteria.

---

Last thing for `xpath()` function is double slash `//`.  It means finding all elements under nodes, in any hierarchy, not just searching its direct children.

First, use single slash `/` in query, it will return all `<name>` element nodes which are directly under `<ifd>`.

```
xml.xpath('ifd/name')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 22)">Run this snippet</button>

**Result:** Two elements returned - `ge-0/0/0` and `ge-0/0/1`.

Second, use double slash `//`, it will return all `<name>` element nodes under `<ifd>`, or all its children (e.g., `<ifl>`).

```
xml.xpath('ifd//name')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 23)">Run this snippet</button>

**Result:** Five elements including all IFD and IFL name are returned.

Further verification with below for loop snippet, all `ifd/name` and `ifd/ifl/name` are displayed.

<pre>
for name in xml.xpath('ifd//name'):
    print(name.text)

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 24)">Run this snippet</button>

#### 3. xpath for Junos output

Back to actual XML output from Junos device, to get `show system uptime` output, you have to call `get_system_uptime_information()` function, and save the result to a variable.

```
uptime = dev.rpc.get_system_uptime_information()
uptime = uptime.find('.//system-uptime-information')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 25)">Run this snippet</button>

To get system time, use below `xpath` and since the return type is a list, further give list index `[0]` and then get the text attribute.

```
uptime.xpath('uptime-information/date-time')[0].text
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 26)">Run this snippet</button>

---

Similarly get `show interfaces` output and save to a variable.

```
intf = dev.rpc.get_interface_information()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 27)">Run this snippet</button>

To extract all `<physical-interface>` elements, use `xpath()` function with argument `'physical-interface'`, and the result is a list contains all `<physical-interface>` element nodes.

```
intf.xpath('physical-interface')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 28)">Run this snippet</button>

---

We can use Python `len()` function to count the number of elements in a list.

To check how many physical interface is in the Junos device, query `len()` of the `xpath()` function result.

```
len(intf.xpath('physical-interface'))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 29)">Run this snippet</button>

**Result:** 28 physical interfaces

---

By the `xpath()` condition feature, we can count how many physical interface has MTU 1514.

```
len(intf.xpath('physical-interface[mtu="1514"]'))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 30)">Run this snippet</button>

**Result:** 15 physical interfaces

---

Out of 28 physical interfaces with 1514 MTU, how many has configured at least one logical interface.

```
len(intf.xpath('physical-interface[mtu="1514"]/logical-interface'))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 31)">Run this snippet</button>

**Result:** 5 logical interfaces

---

After determined the xpath, use a for loop to iterate over the returned list, and then print IFD name, IFL name and family of those 5 logical interfaces

<pre>
for ifl in intf.xpath('physical-interface[mtu="1514"]/logical-interface'):
    print('IFD: %s, IFL: %s, family: %s' % (
        ifl.findtext('../name'),
        ifl.findtext('name'),
        ifl.findtext('address-family/address-family-name')
    ))

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 32)">Run this snippet</button>

#### 4. find(), findall() & findtext() function

Sometimes you may see `find()`, `findall()`, and `findtext()` function in someone's Python code

Below 4 query functions produce exactly the same result - uptime of the vQFX.

```
uptime.xpath('uptime-information/date-time')[0].text
uptime.findall('uptime-information/date-time')[0].text
uptime.find('uptime-information/date-time').text
uptime.findtext('uptime-information/date-time')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 33)">Run this snippet</button>

For `findall()`, it has simple subset function of `xpath()`; same as `xpath()`, it returns list object.

`findall()` doesn't support `OR` operator, nested conditions, and xpath function inside the square brackets.

Supported queries:

```
xml.findall('ifd/ifl/name')
xml.findall('ifd[mtu="1514"]')
xml.findall('ifd[mtu="1514"][ifl]')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 34)">Run this snippet</button>

Unsupported `OR` operator:

```
xml.findall('ifd[mtu="1514" or ifl]')
```
<button type="button" class="btn btn-alert btn-sm" onclick="runSnippetInTab('linux', 35)">Run this snippet and get SyntaxError</button>

Unsupported nested conditions:

```
xml.findall('ifd[ifl[family="bridge"]]')
```
<button type="button" class="btn btn-alert btn-sm" onclick="runSnippetInTab('linux', 36)">Run this snippet and get SyntaxError</button>

Unsupported xpath function inside conditions:

```
xml.findall('ifd[count(ifl)>1]')
```
<button type="button" class="btn btn-alert btn-sm" onclick="runSnippetInTab('linux', 37)">Run this snippet and get SyntaxError</button>

Suggestion is to use `xpath()` function in querying data as it has much more features compared to `findall()`.

Main discrepancy between `xpath()`, `find()`, and `findtext()` is the return object type. `find()` will return XML element, and `findtext()` will return a string

```
type(uptime.xpath('uptime-information/date-time'))
type(uptime.find('uptime-information/date-time'))
type(uptime.findtext('uptime-information/date-time'))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 38)">Run this snippet</button>

The output of above functions are `list`, `lxml.etree._Element`, and `str` respectively.

`xpath()` is mainly used in a for loop to iterate over the elements; `find()` is used for getting desired element node directly.  If there is more than one element matching `find()` function, it returns the first element only.

```
intf.xpath('physical-interface')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 39)">Run this snippet</button>

**Result:** Return a long list contains all physical interfaces.

```
intf.find('physical-interface')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 40)">Run this snippet</button>

**Result:** Return the first item of above list.

Sometimes if you're sure that the result contains one element only, e.g., system uptime `<date-time>` node, use `find()` function to avoid adding extra `[0]` list index.

`find()` and `findtext()` inherit same capabilities as `findall()`, advanced searching and filtering are not supported.

`findtext()` function is actually a short form of `find().text`.

#### 5. Recommend: xpath() + findtext()

Recommend to use the combination of `xpath()` and `findtext()` - use `xpath` in a `for` loop and use `findtext` to get element data.

Why don't standardize all function calls to use `xpath()` given that it has most advanced features, but instead use `findtext()` to extract the element text attribute?

As in below output, `xpath()` returns a list object, if you use `xpath()` function to get the element text, you have to use `[0]` list index.

Not all physical interface contains MAC address, in below example, once the loop hit an interface without MAC, accessing to its `[0]` list index will throw list index out of range exception, because `xpath('hardware-physical-address')` may return a empty list which doesn't have any index value.

<pre>
for ifd in intf.xpath('physical-interface'):
    name = ifd.xpath('name')[0].text
    mac = ifd.xpath('hardware-physical-address')[0].text
    print('%s has MAC address %s' % (name, mac))

</pre>
<button type="button" class="btn btn-alert btn-sm" onclick="runSnippetInTab('linux', 41)">Run this snippet and get IndexError</button>

To avoid above exception, write extra `if` statement for each xpath result to check the length of returned list, if it's greater than zero, access its list index to get the text attribute.

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
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 42)">Run this snippet</button>

So it's recommended to use `findtext()` function here, if there is no element returned, `findtext()` function simply returns `None` value and will not throw any exception.

Below code snippet produces same output as above, but is clearer and easier to read.

<pre>
for ifd in intf.xpath('physical-interface'):
    name = ifd.findtext('name')
    mac = ifd.findtext('hardware-physical-address')
    print('%s has MAC address %s' % (name, mac))

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 43)">Run this snippet</button>

Now you should be able to collect and parse information from Junos devices. In next section, you will learn how to provision Junos configuration using PyEZ.
