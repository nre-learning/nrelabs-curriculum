## Example Lesson

---

### This is a Test

This lesson is meant to be a test of the various features of the Antidote platform.

Run the below snippet to test the `linux-cli1` presentation:

```
date
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux-cli1', this)">Run this snippet</button>

Next, run this command in the second presentation for that same endpoint. This will also test that the influxdb endpoint, which has no presentations in the UI,
is still reachable from the lesson endpoints.

```
curl http://influxdb:8086/query?pretty=true --data-urlencode "q=show databases" | jq
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux-cli2', this)">Run this snippet</button>


