# Using Jinja for Configuration Templates  
## Part 2 – For Loops 
 
Now that you know what is a template and how it works, let’s dive deep into using `for` loops for variable assignment.  
For loops are very useful if you have your data in the form of a list/dictionary or the combination of both. In this part we will take an example which has data stored as a list of dictionaries.  

First, we want to start the Python interpreter and import `Environment` module from Jinja2 library.  

```
python
from jinja2 import Environment
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 0)">Run this snippet</button>

### Python Syntax:

In case you haven’t worked with python lists and dictionaries, below is the syntax for them:  
List: `[a, b, c]`  
Where `a`, `b`, `c` are the elements of the list  

Dictionary: `{x: a, y: b, z: c}`    
where `x`, `y`, `z` are the keys and `a`, `b`, `c` are the values of the keys

In our example `interface` and `ip_address` are the keys and `ge-0/0/0` and `192.168.1.1` are the values of those keys. All these key value pairs are the list elements of the list `interfaces`.  

Run the below snippet to define `interfaces` which will later be used to populate our template.  

### Example: 1  
```
interfaces = [{'interface': 'ge-0/0/0', 'ip_address': '192.168.1.1'},
              {'interface': 'ge-0/0/1', 'ip_address': '10.10.1.1'},
              {'interface': 'fxp0', 'ip_address': '172.16.1.1'}]
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 1)">Run this snippet</button>

Now once we have our data, we will use `for` loop to iterate through our list of dictionary and populate the template. Below is the syntax of `for` loop:

```
{% for condition %}   
 ...   
{% endfor %}
```

Lets analyze the `for` loop in the snippet below,  
`{% for item in interfaces %}` iterates over each dictionary in the list `interfaces`.  
The `trim_blocks` is a optional Enviroment parameters, and is used to trim an extra new line characters between consecutive iterations.
Similarly, `lstrip_block` is a optional Enviroment parameter for striping an extra space/tab before a block.
We are using `env.from_string` which accepts a template in form of a string.
`{{ item.interface }} has IP address {{ item.ip_address }}` replaces the template variable `interface` with the value for the key `interface` and replace `ip_address` with the item’s value for the key `ip_address`.

```
env = Environment(trim_blocks=True, lstrip_blocks=True)
ipaddr_template = env.from_string('''
{% for item in interfaces %}
{{ item.interface }} has IP address {{ item.ip_address }}
{% endfor %}''')
render_1 = ipaddr_template.render(interfaces=interfaces)
print(str(render_1))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 3)">Run this snippet</button>


Now let us define one more list of dictionaries for vlans.  

### Example: 2  
```
vlans = [{'vlan': 'VLAN10', 'vlan_id': 10},
         {'vlan': 'VLAN20', 'vlan_id': 20},
         {'vlan': 'VLAN30', 'vlan_id': 20}]
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 4)">Run this snippet</button>

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
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 5)">Run this snippet</button>

After creating the template, lets supply the vlans data and see how it looks!
```
vlan_config = str(vlan_config.render(vlans=vlans))
print(vlan_config)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 6)">Run this snippet</button>

So far, we have been loading all the available data to the template.  
What if you don’t want to load everything and are only interested in loading a part of the data? That’s when template filters come in, check it out in next part!

