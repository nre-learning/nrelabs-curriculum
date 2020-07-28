<!-- TODO - this stage has been deprecated for now, will be improved in a future release -->

Hopefully APIs don't seem so scary anymore. However, there's only so much we can get done on the bash shell. It's time to move into the world of Python to up-level our API game.

Python is very interesting for network automation, because it doesn't have the heavy feel of a full-blown programming language, but it's just as powerful. You can get a **lot** of work done in a small Python script you might only take a few minutes to write. Hopefully you'll find this to be true as we go through these examples.

Another benefit of Python is that it's an **interpreted** language, which means we don't have to go through the whole "compiling" process; we can even run one-off commands in the Python interpreter, and not even have to write a script file. For simplicity, we'll be working within the Python interpreter for the remainder of this lesson. Just remember, anything you run in the interpreter can also be moved into a script for you to run later.

First, we want to start the Python interpreter:

```
python3
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

You'll notice the prompt has changed to `>>>` to indicate that we're no longer in the Bash prompt, but rather in the Python interpreter. From now on, every command we run is valid Python we can also place into a `.py` file and run as a script.

The best Python library to query a REST API is `requests`. In the following snippet, we'll import `requests`, set the headers so the network device returns JSON instead of XML, and finally, send a `GET` request to the same URL we queried via `curl` earlier. 

```
import requests
headers = {'Accept': 'application/json'}
resp = requests.get('http://vqfx1:8080/rpc/get-interface-information', headers=headers, auth=('antidote', 'antidotepassword'))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

That's it - in three lines of Python, you queried the REST API of a network device, and we can now work with the data returned to us.

Now - instead of printing the response to the screen (hint, you can still do this if you wish - try typing `print(resp.text)`) we loaded the response text into a variable called `resp`.

Since we asked for JSON formatting, we can use the `json` package to load this raw text into a Python data type, and then navigate through this data structure to get what we want - namely the list of network interfaces on this network device:

```
import json
interfaces = json.loads(resp.text)['interface-information'][0]['physical-interface']
for interface in interfaces:
  print(interface['name'][0]['data'])

print("There are %d interfaces in this device" % len(interfaces))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

In the next stage, we'll dive a little deeper into a specific API and figure out what other kinds of information we can send or retrieve.
