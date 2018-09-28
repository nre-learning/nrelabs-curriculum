# Unit Testing Networks with JSNAPy
## Part 2 - BGP Configured Correctly - Tests Pass

In Part 1, we noticed that the router configuration didn't quite match up with what our [JSNAPy](https://github.com/Juniper/jsnapy) tests were stating should be true.

```
cd /antidote/lessons/lesson-12/
cat jsnapy_tests.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 0)">Run this snippet</button>

To review, these tests assert:

- There must be one BGP group configured
- There must be two BGP peers configured
- There must not be any "down" BGP peers

In this part (Part 2), our routers have been configured with the correct BGP peers. We can verify this by checking on the current BGP summary:

```
cli
show bgp summary
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', 1)">Run this snippet</button>

It *looks* good, but as they say, "successful tests or it didn't happen". Let's re-run JSNAPy to make sure our tests are passing with the new configuration:

```
jsnapy --snapcheck -f jsnapy_config.yaml -v
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 2)">Run this snippet</button>

This time, our network is behaving the way we've declared in the tests, so they pass. It's important to note that our tests not only assert that the right configuration exists, but that the operational state of each router's BGP peer status is correct. This is a nice feature of JSNAPy - it can make assertions over anything in the entire Junos data model.

This was a lightning-quick introduction to JSNAPy. Please see the [wiki](https://github.com/Juniper/jsnapy/wiki) for more details - there's a lot more capability than we covered here.
