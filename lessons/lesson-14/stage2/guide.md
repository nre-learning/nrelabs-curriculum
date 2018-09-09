# Introduction to YAML
## Part 1 - Dictionary

In this lesson, we'll give a quick overview of YAML - what it is, why we use it, and some of the basic concepts you'll need to know in order to use it in your network automation journey.

One of the most basic but still very useful aspects of using YAML for network automation is that we can use it to store some basic key/value pairs in a file. Let's look at the contents of this file now:

```
cd /antidote/lessons/lesson-14/stage1/
cat basicdict.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 0)">Run this snippet</button>

In this lesson, we'll work with this YAML data using the interactive Python shell. Run the below snippet to load up our YAML file in Python:

```
python
import yaml
import sys
yamlFile = open('basicdict.yaml', 'r')
yamlDict = yaml.load(yamlFile)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 1)">Run this snippet</button>

At this point, `yamlDict` is a Python dictionary that contains the key-value pairs that were in our YAML file. We can start by checking this dictionary's length:

```
print("There are %d key-value pairs in this YAML file" % len(yamlDict))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 2)">Run this snippet</button>

We can also use a loop to iterate through this dictionary, and print out each key-value pair, and look at their type:

> This example uses strings for all keys and values but both YAML and Python are quite flexible, and can use a variety of other data types as values and even keys, including integers, lists, dictionaries, and more.

```
for key, value in yamlDict:
    print("The key %s is of type %s and its value %s is of type %s" % (key, type(key), value, type(value)))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 3)">Run this snippet</button>
