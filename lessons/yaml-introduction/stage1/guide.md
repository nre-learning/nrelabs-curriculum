In this lesson, we'll give a quick overview of YAML - what it is, why we use it, and some of the basic concepts you'll need to know in order to use it in your network automation journey.

Often, being able to represent an ordered list of values isn't enough. Sometimes we need to be able to look up certain configuration properties by name. For instance, in the previous example, in order to be able to look up the SNMP community string, you'd have to know which item that value was located in the list in order to look it up programmatically. 

A better option for this problem is a Dictionary. They're similar to lists, but instead of storing an ordered sequence of values, they represent an unordered sequence of key/value pairs:

```
cd /antidote/stage1/
cat basicdict.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

In this lesson, we'll work with this YAML data using the interactive Python shell. Run the below snippet to load up our YAML file in Python:

```
python
import yaml
import sys
yamlFile = open('basicdict.yaml', 'r')
yamlDict = yaml.load(yamlFile, Loader=yaml.FullLoader)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

At this point, `yamlDict` is a Python dictionary that contains the key-value pairs that were in our YAML file. We can start by checking this dictionary's length:

```
print("There are %d key-value pairs in this YAML file" % len(yamlDict))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

We can also use a loop to iterate through this dictionary, and print out each key-value pair, and look at their type:

> This example uses strings for all keys and values but both YAML and Python are quite flexible, and can use a variety of other data types as values and even keys, including integers, lists, dictionaries, and more.

<pre>
for key, value in yamlDict.items():
    print("The key %s is of type %s and its value %s is of type %s" % (key, type(key), value, type(value)))

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

As mentioned before, dictionaries are useful for looking up a specific value if you know the key, rather than having to know which item in a list that value is found in. In this case, we can simply look up the SNMP community string by referencing the key `snmpcommunity`:

```
yamlDict['snmpcommunity']
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

YAML and Python are quite liberal with the types that can be stored in a dictionary. We have a second YAML file that has a list (Python's version of an array), a string, and an integer, all stored as different values in the same dictionary:

<pre>
yamlFile = open('complexdict.yaml', 'r')
yamlDict = yaml.load(yamlFile, Loader=yaml.FullLoader)
for key, value in yamlDict.items():
    print("The key %s is of type %s and its value %s is of type %s" % (key, type(key), value, type(value)))

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>
