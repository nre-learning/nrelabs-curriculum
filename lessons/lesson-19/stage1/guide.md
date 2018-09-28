# Working with Network APIs
## Part 1 - Your First API Call

You've undoubtedly heard a lot about APIs in recent years. 

The truth is, APIs aren't really that scary. Think of it this way - the network CLI was built so that you have a way to interface with your favorite router or switch. The commands you type, and the output you see have been optimized with you in mind: the human network engineer.

These days, no technology exists in a vacuum. All kinds of interactions are taking place between systems all around us, and we don't even realize it. Your IT infrastructure is no different. With the world becoming more and more software-defined, the need for your network devices to talk to, and be talked to by, other systems, has never been greater. However, the CLI that works for you isn't exactly an ideal interface for a software system, or script, that's looking to get information from your network devices. Enter, the API.

APIs are 

For this exercise, we'll be working with the [Junos REST API](https://www.juniper.net/documentation/en_US/junos/topics/concept/rest-api-overview.html), but it should be noted that nearly every network operating system these days has their own REST API. The kind of information you have to put into them, as well as what you get out of them, won't all be the same, but they'll follow the same general ideas we'll explore here.


```
curl \
    -u "root:VR-netlab9" \
    http://vqfx1:8080/rpc/get-interface-information \
    --header "Accept: application/json"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 1)">Run this snippet</button>
