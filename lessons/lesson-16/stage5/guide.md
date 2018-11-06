# Using Jinja for Configuration Templates
## Part 5 - Jinja2 templates as external files

You might be wondering that the template creation and loading the data is cool but what if you want to use the same template for multiple scripts or want to import multiple templates in the same script? In that case you can store a template in a .j2 file and then import that file in your script.  
Let us see the below example:

### Example: 1  

We have already created a sample template file in sub-directory `dir1` for our use. Run the below snippet to view the template file.

```
cd /antidote/lessons/lesson-16/stage5/
cat dir1/static_route.j2
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 0)">Run this snippet</button>

Start the interactive python and import the `FileSystemLoader` and `Environment` for loading the Jinja2 template. The `env` allows you to use an external Jinja2 template.
```
python
from jinja2 import FileSystemLoader, Environment
loader = FileSystemLoader('./dir1')
env = Environment(loader=loader, trim_blocks=True, lstrip_blocks=True)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 1)">Run this snippet</button>

We will now store our template in `route_template` and provide the required values to it. Run the below snippet to see how it looks.
```
route_template = env.get_template('static_route.j2')
render_route = route_template.render(route='172.28.0.0/16',
                                     next_hop='10.13.106.1')
print(str(render_route))

```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 2)">Run this snippet</button>

Quit the interactive python to view the other two templates that we are going to use for the next example.
```
quit()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 3)">Run this snippet</button>

### Example: 2  
Below is the `l3_interface.j2` template stored in dir2 sub-directory.  

```
cat dir2/l3_interface.j2
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 4)">Run this snippet</button>

Below is the `device_config.j2` template stored in our local directory. We will treat `device_config.j2` as our main template and include `l3_interface.j2` and `static_route.j2`.  

```
cat device_config.j2
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 5)">Run this snippet</button>

Notice the keyword `include`, it is used to include the other external template files into a Jinja2 template. Below is the syntax for `include`:

```
{% include 'your_external_template_filename' %} 
```

```
python
from jinja2 import FileSystemLoader, Environment
loader = FileSystemLoader(['.','./dir1','./dir2'])
env = Environment(loader=loader, trim_blocks=True, lstrip_blocks=True)

device_template = env.get_template('device_config.j2')
render_device = device_template.render(route='172.28.0.0/16',
                                       next_hop='10.13.106.1',
                                       name='ge-0/0/0',
                                       unit='0',
                                       ip_address='10.13.106.2',
                                       hostname='qfx1')

print(str(render_device))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 7)">Run this snippet</button>


Good Job! You are now ready to render your first network configuration template!  
If you would like to provide Jinja2 tempalates and variables to PyEz and push these configs on to a remote Junos device, checkout out Intro to PyEZ lesson(coming soon)!
