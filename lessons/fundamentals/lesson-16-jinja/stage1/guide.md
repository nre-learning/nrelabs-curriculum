## Using Jinja for Configuration Templates

**Contributed by: [@ShrutiVPawaskar](https://github.com/ShrutiVPawaskar) and [@shahbhoomi](https://github.com/shahbhoomi)**

---

## Part 1 - Introduction to Jinja

I am sure at some point you might have heard the word “Jinja”, or specifically "Jinja2" (the newest version of Jinja). So, what is Jinja? Why do you need to invest your time in learning Jinja and go through these lessons? We will attempt to answer these questions in this lesson.

First, let's talk about templates in general. A template in this context is a text document where some or all of the content is dynamically generated. Data is automatically loaded to the templates with the help of template variables. You could also say that the templates are reusable text files.

So what is Jinja, and why are we using it for templating in the world of network automation?

* Jinja is a modern and designer-friendly templating language for Python.  It is prevalent in the DevOps/NetOps community.
* Jinja has gained a lot of popularity as it has a lot of information published and is supported by tools like Ansible, StackStorm, and Salt.
* Template Inheritance: Jinja allows you to build a base “skeleton” template that contains all the common elements of your site and defines blocks that child templates can override.

So, let’s begin with our first example and get you started with your Jinja Adventure!

First, we need to install Jinja using `pip install jinja2`(it is preinstalled for these lessons). Next, open an interactive python shell by running the snippet below and import the template module from Jinja.

```
python
from jinja2 import Template
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

As our first example, let's try to print the text `ge-0/0/0 has IP address 192.168.1.1`, but instead of simply printing this string,
let's make the interface name and IP address more dynamic, by making them Jinja template variables.

Jinja uses double curly braces (`{{` and `}}`) to indicate a portion of the template that should be replaced with a variable. The text we want to print
will look like this after we've substituted in our variables:

```
{{interface}} has IP address {{ip_address}}
```

In one of the following sections, we'll cover how to import templates from a file - for now, we'll use string variables to store our templates. Let's pass a string
variable into the `Template()` function to create our template object:

```
ipaddr_template = Template('{{interface}} has IP address {{ip_address}}')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Now that our template is ready, we want to load the data in it. This can be done with the help of the `template.render()` function. `template.render()` will take the data you supply to the template variables and load it to the template. Check that out by running the below snippet.

```
interface_1 = ipaddr_template.render(interface='ge-0/0/0',
                                  ip_address='192.168.1.1')
print(str(interface_1))
```

<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Since we've parameterized this template, we can put any values we want:

```
render_2 = ipaddr_template.render(interface='ge-0/0/1',
                                  ip_address='10.10.1.1')
print(str(render_2))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

So, in summary:

* Jinja is a templating tool
* Jinja templates are the text files that set the format of your output
* `{{}}` shows the template variables and can be loaded to the template using the `render()` function.
* Jinja templates can be “reused” with a different set of variables.

Next, we will look into how to use a list or dictionary of variables to populate the template.
