# Using Jinja for Configuration Templates
## Part 1 - Intro

I am sure at some point you might have heard the word “Jinja2” before. So, what is Jinja2?? Why do you need to invest your time in learning Jinja2 and go through these lessons? We will answer all your questions in this lesson!

Let’s start with 
What are Templates?  
•	A template is a text document where some or all of the content is automatically generated.  
•	Data is automatically loaded to the templates with the help of template variables. You can say that templates are reusable text files.  

What is Jinja2? Why do we use it?  
•	Jinja2 is a modern and designer-friendly templating language for Python.  It is prevalent in the DevOps/NetOps community.   
•	It has gained a lot of popularity as it has a lot of information published and is supported by Ansible and SaltStack.  
•	Template Inheritance: It allows you to build a base “skeleton” template that contains all the common elements of your site and defines blocks that child templates can override.   

 
So, let’s start with our first example and get you started with your Jinja2 Adventure!!

First, we need to install Jinja2 (which is preinstalled on this linux machine). Next, run the below snippet to open a python shell and import the template material from Jinja2.
```
python
from jinja2 import Template
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 0)">Run this snippet</button>

Run the below snippet to see what we want to see as the output after using the Jinja2 template that you will be creating. 

```
print('ge-0/0/0 has IP address 192.168.1.1')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 1)">Run this snippet</button>

Below is the Jinja2 template to print the same sentence by using the jinja2 template variables.

Example: 1 
```
ipaddr_template = Template('{{interface}} has IP address {{ip_address}}')
render_1 = ipaddr_template.render(interface='ge-0/0/0',
                                  ip_address='192.168.1.1')
print(str(render_1))
```

<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 2)">Run this snippet</button>

As you can see in the above template, the template variables must be in {{}} when used inside the template.  You can push these variable values to the template by using the render function. In our example the render_1 will hold the template with the template variables replaced with the supplied values assigned to it using render function. We can see the output using the print statement in the snippet.

Example: 2
```
render_2 = ipaddr_template.render(interface='ge-0/0/1',
                                  ip_address='10.10.1.1')
print(str(render_2))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 3)">Run this snippet</button>

Here is one more example of the variable substitution to use a different value for the template variables.
Here we are just treating the template as a text file showing the basic layout of the output you want to see. So we can reuse the template from Example 1 and provide our new variables. 
