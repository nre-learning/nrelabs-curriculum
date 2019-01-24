## Junos Automation with PyEZ

**Contributed by: [@jnpr-raylam](https://github.com/jnpr-raylam)**

---

### Part 3 - Parse Information

#### Display as XML string

In previous section, we assigned `intf` variable with the returned object from `dev.rpc.get_interface_information()`.

Let's quickly connect to Junos device again and re-assign this variable.

```
python
from jnpr.junos import Device
dev = Device('vqfx', user='antidote', password='antidotepassword', normalize=True)
dev.open()
intf = dev.rpc.get_interface_information()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 0)">Run this snippet</button>

From the `type()` function output, we know the object type is `lxml.etree._Element`:

```
type(intf)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 1)">Run this snippet</button>

To display the `xml.etree` object as XML string, we have to import the `etree` module from the `lxml` library (a popular Python library for dealing with XML),
and then use the `dump()` function to convert our XML etree object to an XML string.

```
from lxml import etree
etree.dump(intf)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 2)">Run this snippet</button>

#### Extract data

Now that we have the `intf` variable for storing the etree object of `show interfaces terse` output, we will use the `xpath()` function to extract data from it.

XPath is a query language for allowing us to search for specific elements within an XML document. We can use the `xpath()` function attached
to our `xml.etree` object stored in `intf` to search for physical interfaces within the returned XML data.

To extract all `<physical-interface>` elements, use the `xpath()` function with argument `'physical-interface'`, and the
result is a list contains all `<physical-interface>` element nodes.

```
intf.xpath('physical-interface')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 3)">Run this snippet</button>

---

We can use the Python `len()` function to count the number of elements in a list.

To check how many physical interface is in the Junos device, query `len()` of the `xpath()` function result.

```
len(intf.xpath('physical-interface'))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 4)">Run this snippet</button>

**Result:** 28 physical interfaces

---

Using the `xpath()` condition feature, we can filter on only physical interfaces have have been configured with an MTU of 1514.

```
len(intf.xpath('physical-interface[mtu="1514"]'))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 5)">Run this snippet</button>

**Result:** 15 physical interfaces

---

Out of 15 physical interfaces with an MTU of 1514, how many have been configured with at least one logical interface?

```
len(intf.xpath('physical-interface[mtu="1514"]/logical-interface'))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 6)">Run this snippet</button>

**Result:** 5 logical interfaces

---

Now that we have a pretty good handle on the XPath query we want to use, we can use a `for` loop to iterate over the
returned list, and then print the IFD name, IFL name and family of those 5 logical interfaces.

<pre>
for ifl in intf.xpath('physical-interface[mtu="1514"]/logical-interface'):
    print('IFD: %s, IFL: %s, family: %s' % (
        ifl.findtext('../name'),
        ifl.findtext('name'),
        ifl.findtext('address-family/address-family-name')
    ))

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 7)">Run this snippet</button>

Now that you've learned how to extract the desired information from RPC responses, in the next section we'll talk about configuration provisioning using PyEZ.
