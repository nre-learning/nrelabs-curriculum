# Working with Network APIs
## Part 1 - Your First API Call

<!-- <div class="alert alert-warning" role="alert">
  This course comes with a video, and it's highly recommended that you watch this first. Click the "Lesson Video" button above to watch!
</div> -->

You've undoubtedly heard a lot about APIs in recent years. But what are they all about? And why should you as, a network engineer, care?

In much the same way that the CLI was built for humans to consume, an API is intended to be consumed by software. In the modern data center alone, there are a virtually unlimited number of interactions taking place between the various IT systems, such as sharing information, updating databases, performing configurations, and more. These are all happening without **direct** human intervention, even though a human at some point, probably long ago, told the software how to do that.

In this lesson we'll start actually working with REST APIs, so we can better understand **what** they are, and then we'll move into some practical examples that will show you how you can use REST APIs in your day-to-day.

For this exercise, we'll be working with the [Junos REST API](https://www.juniper.net/documentation/en_US/junos/topics/concept/rest-api-overview.html), but it should be noted that nearly every network operating system these days has their own REST API. The kind of information you have to put into them, as well as what you get out of them, won't all be the same, but they'll follow the same general ideas we'll explore here.

If you've ever worked on a Linux system, or maybe an Apple computer, you might have run into a command called `curl`. This is a simple tool for fetching the contents of a web page. A simple example would be to request the front page of `google.com`:

```
curl https://google.com
```
<!-- <button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 0)">Run this snippet</button> -->

This is effectively the same as what your browser would do if you were to navigate to Google there - it requests a resource from the remote server, and the server responds with the HTML you see in your terminal. Of course, the intention is that the browser would then render this HTML into something we can look at. `curl` performs no such function, so we just get the raw HTML.

What if, instead, we were to query a resource somewhere that wasn't even intended to be rendered visually in a browser? Remember, machines don't care what things "look" like, they just need the information in as efficient a manner as possible. If we add a few parameters, and change the URL, we can query a resource from one of our vQFX switches that fits this description:

```
curl \
    -u "root:VR-netlab9" \
    http://vqfx1:8080/rpc/get-interface-information \
    --header "Accept: application/json"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 1)">Run this snippet</button>

This output is a bit different than the first output. This isn't HTML at all - it's a very efficient format called JSON, or "Javascript Object Notation". It's the de-facto standard for the vast majority of REST APIs.
