# Introduction to YAML
## Part 1 - Lists

lists are cool

```
cd /antidote/lessons/lesson-14/stage1/
cat list.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 0)">Run this snippet</button>

In this lesson, we'll work with this YAML data using the interactive Python shell. Run the below snippet to load up our YAML file in Python:

```
python
import yaml
import sys
yamlFile = open('list.yaml', 'r')
yamlList = yaml.load(yamlFile)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 1)">Run this snippet</button>

At this point, `yamlDict` is a Python dictionary that contains the key-value pairs that were in our YAML file. We can start by checking this dictionary's length:

```
print("There are %d values in this YAML file" % len(yamlList))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 2)">Run this snippet</button>
