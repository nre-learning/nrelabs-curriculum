# Terraform & Junos
## Part 3 - Applying the Execution Plan

Here we go with the exciting bit! We're going to apply our Terraform configuration resources to device `vqfx01`.

What happens we do this is:

- Terraform applies the execution plan in dependency order (interface -> bgp session) per dependency.
- Terraform provider functions import the device data `junos-qfx.tf`.
- In turn the Terraform configuration is read from the `.tf` file for each resource being created.
- The provider opens a NETCONF session to the target device, passes the XML for each resource and does a lazy close on the connection allowing other resource providers in the same provider to re-use it.
- Once complete, the connection is closed, cache data is updated and Terraform exits.

First we need to make sure we're in the correct working directory.

```
cd /antidote/lessons/lesson-31/terraform/
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('terraform1', this)">Run this snippet</button>

Now let's apply the previously created execution plan.

```
terraform apply -auto-approve
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('terraform1', this)">Run this snippet</button>

When this completes, not only are the resources created on Junos but also Terraform creates a state file which can be inspected really easily.

We can check on Junos that both the BGP peer is established and the interface is configured correctly.

```
show interfaces em4
show bgp summary
ping 10.31.0.13 count 10
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>

```
cat terraform.tfstate
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('terraform1', this)">Run this snippet</button>

At this point we can also check to make sure that the cache reflects the plan:

```
terraform plan
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('terraform1', this)">Run this snippet</button>

You've just created some resources on Junos using Terraform! How cool is this? There are two view points here worth a brief discussion on (don't fear, it will be super brief so you can get back at it!). 

__Immutable Infrastructure__

Terraform allows us to create resources that can be destroyed cleanly when we're done with them. As network engineers, we know designs change over time, which can prove to be a challenge come removal time (if removed). Terraform uses named configuration group resources to provide this resource type management.

You can check the resources created by Terraform by checking the current contents of the configuration group stanza on `vqfx1`.

```
show configuration groups
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>

Like container and cloud approaches to applications, the ideas is we can just destroy the resources when we don't need them, without having to figure out dependencies like we traditionally would.

__Mutability__

Ok, so this isn't entirely immutable. We can update resources too. This is useful for developing a set of template resources or providing updates to in-situ deployments resulting in low risk changes against typos and input variables.

This is a user exercise and you're next challenge is to change the IP address on the BGP peer resource to `.15` instead of `.13`. You can use `vim` or `nano` to achieve this on the Linux VM interface provided for you. Exit using the escape sequence: `esc` then `:wq!` then hit return.

```
vim bgp_peer_1.tf
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('terraform1', this)">Run this snippet</button>

Once you've done this, run terraform plan again!

```
terraform plan
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('terraform1', this)">Run this snippet</button>

Here's an example of what you should be seeing.

```bash
------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  ~ junos-qfx_native_bgp_peer.vqfx01_peer1
      bgp_neighbor: "10.31.0.13" => "10.31.0.15"


Plan: 0 to add, 1 to change, 0 to destroy.

------------------------------------------------------------------------
```

Let's go ahead and apply the change.

```
terraform apply -auto-approve
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('terraform1', this)">Run this snippet</button>

Now the BGP session remote peer address has been changed and you're free to check the configuration group configuration entry on `vqfx` to gain evidence of this wizardy.

Peaking under the hood, the Junos Terraform provider destroys the group by NETCONF then re-creates it with the same ID. In the grand scheme of things, it looks like an edit, but it's actually a full resource re-build.

```
show configuration groups
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>

__Idempotency__

Terraform provides an idempotent and safe way to create, update and destroy resources, so you can make execution plans and apply them as frequently or infrequently as you like and re-apply over and over again without worry about affecting state negatively.

*The Terraform terraform-provider-junos-qfx is covered by a BSD-3-Clause license and copyrighted by Juniper Networks*
