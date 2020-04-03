## Using Jinja for Configuration Templates

**Contributed by: [@ShrutiVPawaskar](https://github.com/ShrutiVPawaskar) and [@shahbhoomi](https://github.com/shahbhoomi)**

---

## Part 2 – For Loops

Now that you know what is a template and how it works, let’s dive deep into using `for` loops for variable assignment.
For loops are very useful if you have your data in the form of a list/dictionary or the combination of both. In this part we will take an example which has data stored as a list of dictionaries.

First, we want to start the Python interpreter and import `Environment` module from Jinja2 library.

```
python
from jinja2 import Environment
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

In case you haven’t worked with python lists and dictionaries, here's a quick primer on lists and dictionaries, which we'll be using to populate more advanced
template examples:

List: `[a, b, c]`
Where `a`, `b`, `c` are the elements of the list

Dictionary: `{x: a, y: b, z: c}`
where `x`, `y`, `z` are the keys and `a`, `b`, `c` are the values of the keys


In the below example, we'll define a list of dictionaries, called `interfaces` which will later be used to populate our template:

```
interfaces = [{'interface': 'ge-0/0/0', 'ip_address': '192.168.1.1'},
              {'interface': 'ge-0/0/1', 'ip_address': '10.10.1.1'},
              {'interface': 'fxp0', 'ip_address': '172.16.1.1'}]
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Each element in this list contains a dictionary with two keys: `interface` and `ip_address`.

Now once we have our data, we will use a `for` loop to iterate through our list of dictionary and populate the template. Below is the syntax of `for` loop:

```
{% for condition %}
 ...
{% endfor %}
```

We can create a template inside a string literal and pass this to the `from_string` function of our `Environment` instance to get a template object with some parameters added, which we'll explain next:

```
env = Environment(trim_blocks=True, lstrip_blocks=True)
ipaddr_template = env.from_string('''
{% for item in interfaces %}
{{ item.interface }} has IP address {{ item.ip_address }}
{% endfor %}''')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Let's talk a little bit about what we just did:

- We are first declaring an instance of `Environment` called `env`. With this instantiation, we're passing two optional parameters. `trim_blocks` is used to trim an extra new line characters between consecutive iterations. `lstrip_block` strips the extra space/tab before a block.
- The function `env.from_string` accepts a template in form of a string, which we're passing in directly as a string literal (no variable).
- `{% for item in interfaces %}` begins our "for" loop. It specifies we want to iterate over each dictionary in the list `interfaces`.
- `{{ item.interface }} has IP address {{ item.ip_address }}` replaces the template variable `interface` with the value for the key `interface` and replace `ip_address` with the item’s value for the key `ip_address`. Note that each starts with `item.`, which means we're accessing a value in the dictionary currently made available to us by our loop.

Once we have this template defined, we can render it like we did in previous sections, passing `interfaces` in as a parameter:

```
render_1 = ipaddr_template.render(interfaces=interfaces)
print(str(render_1))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Since all of our fields are keys of the dictionary `interfaces`, we only have to pass this in, and our template will access specific keys of that dictionary.

Now let us define one more list of dictionaries, this time for VLANs:

```
vlans = [{'vlan': 'VLAN10', 'vlan_id': 10},
         {'vlan': 'VLAN20', 'vlan_id': 20},
         {'vlan': 'VLAN30', 'vlan_id': 20}]
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Now we will learn how to use the `for` loop to format the template like a Junos CLI configuration.

```
vlan_config = env.from_string('''
vlans {
{% for item in vlans %}
    {{ item.vlan }} {
        vlan-id {{ item.vlan_id }};
        l3-interface irb.{{item.vlan_id}};
    }
{% endfor %}
}''')

```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

After creating the template, lets supply the vlans data and see how it looks!
```
vlan_config = str(vlan_config.render(vlans=vlans))
print(vlan_config)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

In the next section, we'll add more decision-making power to our templates by using `if` and `set` statements.
