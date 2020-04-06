With all of the hubbub about automation and programmability, one thing you've probably heard a lot about is APIs, or "Application Programming Interfaces". However, if you don't have any experience with these, it may not be immediately obvious why these are important and why you as a network engineer should learn about them.

<div style="text-align:center;margin-top:30px;"><img src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/v1.1.1/lessons/fundamentals/lesson-19-restapis/rest.png" width="250px"></div>

In much the same way that the CLI was built for humans to consume, an API is intended to be consumed by software. In the modern data center alone, there are a virtually unlimited number of interactions taking place between the various IT systems, such as sharing information, updating databases, performing configurations, and more.

These are all happening without **direct** human intervention - _but_, in order to get there, a human had to write that software. And this is why automation doesn't mean humans are out of a job; it just means their job shifts a bit, as they employ software to make decisions on their behalf.

APIs are all around you. They're embedded in the very web browser you're using to view these words. They're nestled deep within your operating system. They're even found on most modern network operating systems. And there are many types of APIs, each aimed at accomplishing different things. For this lesson, we'll be exploring APIs that interact over the network, using HTTP as a transport. Through these APIs, we'll do things like read data, send data, and eventually, work with network devices in a whole new way.

### But What is REST?

A slight detour into terminology before we get started. You'll find it will be very easy to fall into the trap of referring to any HTTP-based API as RESTful. REST is actually an [architectural pattern that holds six guiding principles](https://restfulapi.net/), and while most APIs we'll explore are both RESTful (meaning they adhere to these principles), and use HTTP as a transport, the two are not tightly coupled.

For this lesson, you can think of the APIs we'll explore as HTTP APIs that respect and adhere to the REST principles.

### REST Basics on the Command-Line

To start, in this section we'll cover some of the basic interactions you can expect to have with a REST API using command-line
tools available on nearly all modern operating systems (sometimes by default). In future sections, we'll cover how to write your own software to consume APIs, but as an introductory exercise, working directly with a command-line for now is appropriate.

We'll be using a custom, simple REST API server for these examples, to keep things simple for now. It's written in Python using the `flask` framework. We will only be focusing on how to **use** a REST API, and not how to **write** one in this lesson, but it's written as a simple Python script and part of this lesson if you wish to look at it and learn.

It's **really important** that you run this command in `linux1-cli2` first; if you don't, the rest of this section won't work. Start the API server with this snippet:

```
python /antidote/server.py
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1-cli2', this)">Run this snippet</button>

We'll come back to this tab frequently during this exercise, as it will provide helpful output from the server's perspective on how we interacted with it via some client software tools.

REST APIs generally make specific resources available via a URL, just like you'd go to a sub-page on a website. Our REST API houses information about network devices, and we can query the path `/api/v1/switches/all` to get access to a list of network switches that it knows about. In API-speak, this path is commonly referred to as an "API endpoint". It's a specific path to a resource that should produce some kind of expected result.

One of the most popular tools for working with APIs on the command-line is [cURL](https://curl.haxx.se/). This is available in nearly every modern Linux distro, but can also be used in Mac or Windows. We can use the `curl` command to append the aforementioned path to the protocol and location of the API server we started in the last step. `curl` will send an HTTP request to that server at that location, and output the response from the server to our terminal screen:

```
curl http://linux1:5000/api/v1/switches/all
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1-cli', this)">Run this snippet</button>

Congratulations - you've officially made your first REST API call! While some API interactions are much more complicated than this, there are a lot of things you can do with a REST API and a simple tool like `curl`.

You may be asking yourself, that URL looks an awful lot like a website. And you wouldn't be wrong? In fact, what we just did is extremely similar to what your browser does - it sends an initial HTTP request for some information, and the server sends back a response. However, the key difference is that we're not receiving (or expecting) HTML code in the response, but rather a JSON document. It is in this JSON document that we can find the information we're looking for.

If you're not super familiar with JSON, have no fear - we'll keep it simple for now, and in a future section, we'll dive deeper into tools that allow us to easily parse this data and make use of it.

## HTTP Verbs

If you're familiar with HTTP as a protocol, you may know that there are several [verbs](https://www.restapitutorial.com/lessons/httpmethods.html) you can use to retrieve or send data. We'll cover a few of them here. `curl` allows us to specify the type of HTTP request we wish to make. Selecting the right one will largely depend on what we want to do, and what the API endpoint we're calling requires.

By default, if no verb is provided, `curl` tries to infer the HTTP verb you're trying to use. In this case, it defaults to `GET` - but we can also specify it ourselves using the `-X` flag:

```
curl -X GET http://linux1:5000/api/v1/switches/all
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1-cli', this)">Run this snippet</button>

This API also provides an endpoint for looking up a specific switch by name. This endpoint is available by dropping `/all` from the path we used previously. We also need to provide a parameter `name` via a query string, so the API knows which switch we're trying to retrieve. Let's look up `sw01`:

```
curl -X GET http://linux1:5000/api/v1/switches?name=sw01
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1-cli', this)">Run this snippet</button>

> Try passing in other values for `name`! Or try leaving it out entirely and see what the API does.


Before continuing on, it might be useful to see the log messages on the server - it's pretty fun to see these messages come in when we make requests from the client. Head over to the `linux1-cli2` tab to see what the server has processed thus far:

<button type="button" class="btn btn-primary btn-sm" onclick="switchToTab('linux1-cli2')">Go to "linux1-cli2"</button>

Obviously we don't normally get to see this if we're just interacting with an API as a client, but since we're running a sample server ourselves, we get to sneak a peek under the covers. Note that the server outputs not only the requests it received, but also the HTTP status code it sent back to the client all of which should be `200` thus far.

This API also allows us to add to the list, by sending a blob of JSON data representing a switch object. The idiomatic way for APIs to provide this functionality is by accepting a `POST` request verb.

Before we do this, let's break down the command we're about to run:

- `curl -X POST http://linux1:5000/api/v1/switches \` - This should look mostly familiar. We're calling the `/api/v1/switches` endpoint, but we're using the `POST` verb instead of the default `GET`, because we want to tell the server to create a new switch.
- `-H "Content-type: application/json" \` - This is a special header we're passing to the API to give it a sort of heads-up (get it?) that we're going to be sending it some data in JSON format.
- `-d '{"name":"sw05","operating_system":"Junos"}'` - This is a JSON blob containing the data we are telling the server to create. In this case, we're sending the two fields we know this API expects - `name`, and `operating_system`.

We'll provide each section on its own line for readability - bash allows us to do this by ending each line (except the last line) with a backslash (`\`), meaning there's more to come.

```
curl -X POST http://linux1:5000/api/v1/switches \
  -H "Content-type: application/json" \
  -d '{"name":"sw05","operating_system":"Junos"}'
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1-cli', this)">Run this snippet</button>

You'll notice that the response from the server contained exactly what we sent. This is a fairly common practice for API endpoints that accept `POST` requests - it's a way of letting you know what it just created. However, the sure-fire way of making sure everything is okay is by looking at the HTTP status code in the response. Let's create another switch object `sw06`, but this time using the `-v` flag, which instructs `curl` to output more detailed information to the screen:

```
curl -v -X POST http://linux1:5000/api/v1/switches \
  -H "Content-type: application/json" \
  -d '{"name":"sw06","operating_system":"Cumulus"}'
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1-cli', this)">Run this snippet</button>

The output from this command is definitely more verbose. From the top we see the details of the request we sent to the API server. After that, we see a space, and the following information is about the response we received back. In that text, we
see the following:

```
HTTP/1.0 201 CREATED
```

`201` is a status code dedicated for this purpose - it lets us know that everything is okay, and the resource we wanted to create was created successfully.

Now, we can query either `sw05` and `sw06` and get a successful response, since they exist now:

```
curl -X GET http://linux1:5000/api/v1/switches?name=sw05
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1-cli', this)">Run this snippet</button>

The last verb we'll cover in this section is `DELETE`. As you might expect, it allows us to request that an API delete a resource. Like we did with previous `get` requests, in order to specify which record we want to delete, we'll need to pass in a `name` identifier. Of course, like almost everything else, the specific parameter(s) required (and how we provide them) will vary by API. In our case, we can delete a `switch` by sending the following request:

```
curl -v -X DELETE http://linux1:5000/api/v1/switches?name=sw01
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1-cli', this)">Run this snippet</button>

Note that we provided the `-v` flag once more for additional verbosity. This is because it's common for `DELETE` requests to provide no data in the response at all, and we need to know what the status code is to ensure the deletion occurred successfully. In this case, `204 NO CONTENT` is still a 2xx error code, which means that everythings fine, there's just no data to return to the client - the resource was deleted. Some APIs will do this, others will respond with a `200 OK` and a message indicating successful deletion in the response body - it really just depends on the API.

Note that when we try to get `sw01` now, the request fails since it's no longer there.

```
curl -X GET http://linux1:5000/api/v1/switches?name=sw01
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1-cli', this)">Run this snippet</button>

Finally, take a look at `linux1-cli2` once more and see all of the requests that have been processed thus far. Quite a few!

<button type="button" class="btn btn-primary btn-sm" onclick="switchToTab('linux1-cli2')">Go to "linux1-cli2"</button>

## Takeaway

As you can see, calling a REST API can be very simple. Once you know the various verbs and syntaxes for making a REST call, either with a command-line client, or some other method, and how to handle the data returned by a call, you're able to do a lot with that knowledge.

The biggest challenge from that point will be to become familiar with the specifics of an API, such as what parameters to send, and what data to expect in return. Particularly with REST APIs, there is no widely-accepted "standard" for this, which means that every API is going to do things a little differently. Therefore, it's very important, before writing a line of code or running any commands, to find that API's documentation. We know how to call our sample API server here because it's simple and it's built in to the lesson, but often, the API you're calling is hosted by someone else, and the only way you'll have a hope of knowing how to interact with that API is if there's accompanying documentation.

These days, API documentation is a must-have; it's responsible for telling you what kind of endpoints are available, how to call them, what parameters they need, and what to expect in return from them. Without documentation, we're just shooting in the dark.

This covers the very basics of working with a REST API using command-line tools. In future sections, we'll cover how to parse the resulting data, how to authenticate to a REST API, how to work with an API in Python - and more! So stay tuned.
