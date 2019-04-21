## Using Jinja for Configuration Templates

**Contributed by: [@ShrutiVPawaskar](https://github.com/ShrutiVPawaskar) and [@shahbhoomi](https://github.com/shahbhoomi)**

---

## Part 5 - Importing a Jinja Template from a File

In the previous section, we loaded data from a YAML file and used that data in our templates. You are likely wondering if you can do the same thing with your templates too, so that you can focus on logic in your Python scripts, and maintain data (YAML) and templates (Jinja) separately? You can, and we'll do that in this section.

We have already created a sample template file called `static_route.j2` in the sub-directory `dir1` for our use. Run the below snippet to view the template file:

```
cd /antidote/lessons/lesson-16/stage5/
cat dir1/static_route.j2
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Start the python shell and import the `FileSystemLoader` and `Environment` for loading the Jinja template. The `env` instance allows you to use an external Jinja template using FileSystemLoader:

```
python
from jinja2 import FileSystemLoader, Environment
loader = FileSystemLoader('./dir1')
env = Environment(loader=loader, trim_blocks=True, lstrip_blocks=True)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

We will now store our template in the `route_template` variable and render it with the required values:

```
route_template = env.get_template('static_route.j2')
render_route = route_template.render(route='172.28.0.0/16',
                                     next_hop='10.13.106.1')
print(str(render_route))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Quit the interactive python shell to view the other two templates that we are going to use for the next example.

```
quit()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

### Example: 2
Below is the `l3_interface.j2` template stored in dir2 sub-directory.

```
cat dir2/l3_interface.j2
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Below is the `device_config.j2` template stored in our local directory. We will treat `device_config.j2` as our main template and include `l3_interface.j2` and `static_route.j2`.

```
cat device_config.j2
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Notice the keyword `include`, it is used to include the other external template files into a Jinja template. Below is the syntax for `include`:

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
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Good Job! You are now ready to render your own network configuration templates!

You may want to check out the lesson on using <a href="/labs/?lessonId=24&lessonStage=1" target="_blank">PyEZ for Junos Automation</a>. Instead of just printing these configs, you can pass them into the PyEZ Python library to push them automatically to your network devices!
