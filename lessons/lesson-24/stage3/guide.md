## Junos Automation with PyEZ

**Contributed by: [@jnpr-raylam](https://github.com/jnpr-raylam)**

---

### Part 3 - Parse information

#### Display as XML string

In previous section, we assigned `intf` variable with the returned object from `dev.rpc.get_interface_information()`.

Let's connect to Junos device and assign this variable again.

```
python
from jnpr.junos import Device
dev = Device('vqfx', user='root', password='VR-netlab9', normalize=True)
dev.open()
intf = dev.rpc.get_interface_information()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 0)">Run this snippet</button>

From `type()` function output, we know the object type is `lxml.etree._Element`:

```
type(intf)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 1)">Run this snippet</button>

To display the `xml.etree` object as XML string, we have to import `etree` module, and then use `dump()` function to convert XML etree object to a XML string.

```
from lxml import etree
etree.dump(intf)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 2)">Run this snippet</button>

#### Extract data

Now, we have the `intf` variable stored the etree object of `show interfaces terse` output, we will use `xpath()` function to extract data.

To extract all `<physical-interface>` elements, use `xpath()` function with argument `'physical-interface'`, and the result is a list contains all `<physical-interface>` element nodes.

```
intf.xpath('physical-interface')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 3)">Run this snippet</button>

---

We can use Python `len()` function to count the number of elements in a list.

To check how many physical interface is in the Junos device, query `len()` of the `xpath()` function result.

```
len(intf.xpath('physical-interface'))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 4)">Run this snippet</button>

**Result:** 28 physical interfaces

---

By the `xpath()` condition feature, we can count how many physical interface has been configured with MTU 1514.

```
len(intf.xpath('physical-interface[mtu="1514"]'))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 5)">Run this snippet</button>

**Result:** 15 physical interfaces

---

Out of 15 physical interfaces with 1514 MTU, how many has been configured at least one logical interface.

```
len(intf.xpath('physical-interface[mtu="1514"]/logical-interface'))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 6)">Run this snippet</button>

**Result:** 5 logical interfaces

---

After determined the xpath, we use a `for` loop to iterate over the returned list, and then print IFD name, IFL name and family of those 5 logical interfaces.

<pre>
for ifl in intf.xpath('physical-interface[mtu="1514"]/logical-interface'):
    print('IFD: %s, IFL: %s, family: %s' % (
        ifl.findtext('../name'),
        ifl.findtext('name'),
        ifl.findtext('address-family/address-family-name')
    ))

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 7)">Run this snippet</button>

Now, you've learned how to extract desired information from RPC responses. In next week, we'll talk about configuration provisioning using PyEZ.