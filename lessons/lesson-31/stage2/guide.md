# Terraform & Junos
## Part 2 - Planning the Resource Graph

This lesson introduces the planning phase of Terraform. Some exciting things happen here and Terraform beautifully deals with the complex stuff so you get the simple and effective outcomes.

As we discovered in the first stage of the lesson, Terraform gives us the ability to approach configuration in an immutable declarative way, which is relatively unheard of for the kind of networking we're dealing with here. Just for the record, Terraform can also update named resources, but more on that later.

Terraform deals with resources in a dependency graph manner, both implicitly and explicitly. This means the order of resource creation can be controlled along with order of updates. Some people refer to this as a 'blast radius' and a negative anecdote would be that of sawing the branch of the tree you happen to be sitting on. Terraform can help here.

So long as you know what depends on what, Terraform will reflect that knowledge and deal with the creation of resources reflecting the dependency tree. This might not seem like a big deal at first and hopefully in this stage of the lesson some of the usefulness is exposed for your gain and benefit.

To keep things easy.

```
cd /antidote/lessons/lesson-31/terraform
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('terraform1', 0)">Run this snippet</button>

## Planning

Terraform once initialized, is ready to plan what needs to be done. Once Plan is invoked, the resources are inspected in the directory along with a reconciliation against the plugin to ensure that at pre-run it's likely to work. It's often used not only to create the Terraform execution plan, but also to check if it will work before checking in a Terraform configuration in to a repository and committing.

Let's go ahead and run Terraform plan and see what's going to happen.

```
terraform plan
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('terraform1', 1)">Run this snippet</button>

What you should see is two resources being described and in what order; an interface inet configuration followed by a BGP peer. There is an explicit dependency made in the file `bgp_peer_1.tf`.

```
cat bgp_peer_1.tf
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('terraform1', 2)">Run this snippet</button>

Cool huh?

It's also possible to view the data graphically (providing you have `graphviz` installed).

Here's an example of the `graphviz dot` output for this Terraform execution plan.

```
terraform graph -type=plan
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('terraform1', 3)">Run this snippet</button>

You can feed the output of this operation to `dot` and generate graphics.

This next step creates a PNG file containing the output. However, other than creating the file, you cannot currently view it dynamically using the lab system. Instead we've embedded the file for you to view at your convenience below.

```
terraform graph -type=plan | dot -Tpng > plan_graph.png
```

<div style="text-align:center;"><img src="https://raw.githubusercontent.com/nre-learning/antidote/master/lessons/lesson-31/stage2/plangraph.png"></div>

*The Terraform terraform-provider-junos-qfx is covered by a BSD-3-Clause license and copyrighted by Juniper Networks*
