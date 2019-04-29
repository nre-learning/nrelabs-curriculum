# Terraform & Junos
## Part 4 - Destroying Plans

We're making great progress here. If you've followed each lesson stage sequentially, you have new or refreshed knowledge on declarative resource management using Terraform and in the field of networking, which is cool and super useful. We've created some resources and Terraform has accurate state. 

The pointy haired boss comes along and says "Hey, that customer left and we need to remove the config". Did you prepare for this day when you implemented your configuration manually? Or do you have to back to your spreadsheets and text notes?

If you did this using Terraform, you're in luck! It's as easy as destroying the resources using Terraform. First, let's acknowledge that the resources are present and then we'll delete them.

First we need to make sure we're in the correct working directory.

```
cd /antidote/lessons/lesson-31/terraform/
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('terraform1', this)">Run this snippet</button>

```
show configuration groups
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>

```
terraform destroy -auto-approve
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('terraform1', this)">Run this snippet</button>

What we did here was just remove the resources Terraform has cache data for. You might be thinking how you approach multiple customer data and multiple devices and the answer is through using directories. Each directory contains specific cache data and unless you've built your Terraform configurations to use global data, by design the data is isolated.

What if someone came along and manually changed the configuration during the lifetime of the customer? It's not unreasonable given a customer could upgrade or downgrade whatever service they have, or your organization could experience a merger or more exciting, an acquisition. In engineering land, attrition is a real issue and knowledge walks out of the door. With Terraform, you're covered. Even if the manual entries were changed, providing they haven't destroyed the ID of the group, Terraform will remove everything it knows about given the last cache entry.

On to the bonus material!

*The Terraform terraform-provider-junos-qfx is covered by a BSD-3-Clause license and copyrighted by Juniper Networks*
