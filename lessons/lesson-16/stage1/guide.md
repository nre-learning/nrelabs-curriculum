# Using Jinja for Configuration Templates
## Part 1 - Intro

I am sure at some point you might have heard the word “Jinja2”. So, what is Jinja2?? Why do you need to invest your time in learning Jinja2 and go through these lessons? We will answer all your questions in this lesson!  
  
*Let’s start with what are Templates?*  
* A template is a text document where some or all of the content is automatically generated.  
* Data is automatically loaded to the templates with the help of template variables. You can also say that the templates are reusable text files.  
  
*What is Jinja2? Why do we use it?*    
* Jinja2 is a modern and designer-friendly templating language for Python.  It is prevalent in the DevOps/NetOps community.  
* It has gained a lot of popularity as it has a lot of information published and is supported by Ansible and SaltStack.  
* Template Inheritance: It allows you to build a base “skeleton” template that contains all the common elements of your site and defines blocks that child templates can override.  
  
So, let’s begin with our first example and get you started with your Jinja2 Adventure!!  
  
First, we need to install Jinja2 using “pip install jinja2”(it is preinstalled for these lessons). Next, open an interactive python shell by running the snippet below and import the template module from Jinja2.  
```
python
from jinja2 import Template
```  
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 0)">Run this snippet</button>  
  
Run the below snippet to see the sample output we plan on achieving using our Jinja2 Template.  
```
print('ge-0/0/0 has IP address 192.168.1.1')
```  
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 1)">Run this snippet</button>  

*Template Syntax:*  
template_name = Template('some_text {{template_variable1}} some_text')  
where {{template_variable1}} is the template variable and template_name is the name of the template. Template() function converts your text into a reusable jinja2 template.  

Let us look at Example 1 to learn how to use these templates. Here ipaddr_template is the Jinja2 Template and {{interface}}
and {{ip_address}} are the template variables.  

*Example: 1*  
```
ipaddr_template = Template('{{interface}} has IP address {{ip_address}}')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 2)">Run this snippet</button>

Now that our template is ready, we want to load the data in it. This can be done with the help of the template.render() function. template.render() will take the data you supply to the template variables and load it to the template. Check that out by running the below snippet.  

```
interface_1 = ipaddr_template.render(interface='ge-0/0/0',
                                  ip_address='192.168.1.1')
print(str(interface_1))
```

<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 3)">Run this snippet</button>

let’s look at Example 2 and supply the different variable values to our Jinaj2 templaye aka "Resuable Text File".  

*Example: 2*  

```
render_2 = ipaddr_template.render(interface='ge-0/0/1',
                                  ip_address='10.10.1.1')
print(str(render_2))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 4)">Run this snippet</button>

That’s all for stage-1, in coming lessons we will look into how to use a list or dictionary of variables to populate the template. But before that we expect you to have the following take away from stage-1.  
  
*Take Away from stage-1:*  
* Jinja2 is a templating tool  
* Jinja2 templates are the text files that sets the format of your output  
* {{}} shows the template variables and can be loaded to the template using the render() function.  
* As seen from example 1 and 2, Jinja2 templates can be “reused” with a different set of variables.  
That’s all for stage-1, in coming lessons we will look into how to use a list or dictionary of variables to populate the template. But before that we expect you to have the following take away from stage-1.  

Hope you enjoyed it!! See you in stage-2!
