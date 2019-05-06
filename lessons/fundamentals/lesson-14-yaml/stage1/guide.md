# Introduction to YAML
## Part 1 - Lists

Welcome to this introduction to YAML! From the very first moment you started looking into network automation, chances are you keep
hearing about YAML. The reason for this is that YAML is a simple way to describe common data structures in a format that's both
easily understood by humans, as well as easily parseable by machines. As a result, it powers a large number of automation tools,
both inside and outside of networking.

To prepare you for more advanced lessons that might use YAML, we want to spend some time covering the basics, so you're able to
look at an existing YAML document and understand it, or even create your own. This will allow you to do things like write Ansible playbooks,
JSNAPy tests, and much more.

As mentioned, YAML lets us represent simple data structures in a text format. One such data structure is the `list`. Most of YAML's capabilities
closely mirror Python's data structures, and the `list` is a prime example. Let's take a look at a sample YAML list:

```
cd /antidote/lessons/fundamentals/lesson-14/stage1/
cat list.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

In this lesson, we'll work with this YAML data using the interactive Python shell. Run the below snippet to load up our YAML file in Python:

```
python
import yaml
import sys
yamlFile = open('list.yaml', 'r')
yamlList = yaml.load(yamlFile)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

At this point, `yamlList` is a Python list that contains values (in this case, strings) that were in our YAML file. We can start by checking this list's length:

```
print("There are %d values in this YAML file" % len(yamlList))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>
