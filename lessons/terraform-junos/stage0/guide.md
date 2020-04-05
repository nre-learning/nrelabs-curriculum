In this lesson, we will introduce Terraform, what it is and show you how it works.

Terraform enables you to easily and predictably plan, create, update and destroy infrastructure resources in a graph based and network CLI free way. The strange thing for Terraform is it's mostly thought as of an application or cloud provisioner and not really focussed on the networking space. You'll see that thought is just not true!

Infrastructure-as-Code Terraform resources are declarative versions of the networking resources and can be version controlled and passed about without other system resources. With Terraform, you can stop thinking about how things are built and just worry about the what. All Terraform configurations are expressed in [Hashicorp Configuration Language](https://www.terraform.io/docs/configuration/syntax.html) (HCL) which in itself is very powerful.

Don't forget your network chops in this lesson. You'll configure an interface, a BGP peer, a VLAN and a L3 interface for the VLAN. You can exercise your networking powers here and validate what Terraform does as it does it on `vqfx1`.

![Terraform](https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/v0.3.2/lessons/lesson-31/stage1/terraformbasics.png)

*Image borrowed from [https://terraform.io](https://terraform.io)*

Terraform for traditional networking is relatively unchartered ground because we don't think about switches, routers or firewalls as a set of immutable resources, or put in another way, things that can be created and destroyed easily. Imagine cutting out the bits you don't use and soldering them back in? Mentally it feels like a step, but in reality we can deal with this as an abstracted construct. This makes us think about things tangentially from what we're used to, but with little effort and thanks to NRE Labs, you can get a feel for how this works!

Before we proceed, we need to move to the right directory. Terraform is ran in a separate directory so we can move between stages within this lesson and knowledge build.

```
cd /antidote/terraform/
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('terraform1', this)">Run this snippet</button>


__Terraform Init__

Terraform's first stage for any roll-out of resources starts with init and before we do that, let's just get a measure for what's currently in our working directory.

```
ls -la
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('terraform1', this)">Run this snippet</button>

What you can see are several Terraform resources which are configuration text files with the extension `.tf`. These configuration files make use of Terraform providers and in our case, these providers reside in the binary file `terraform-provider-junos-qfx`. This binary file contains an experimental and limited set of implementations focussed on the Juniper QFX switch. We'll cover the contents of the Terraform resource files in the next lesson.

We just want you to know that the Terraform provider isn't ready yet for production and you're getting an early sneaky peak in this lesson! It will be very soon so keep an eye out for release information.

Terraform needs to be initialized still, so let's go ahead and do that now. As you would expect, this is idempotent and can be done multiple times and safely.

```
terraform init
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('terraform1', this)">Run this snippet</button>

Terraform maintains state files for resource state. This is a source of truth that can inspected and manipulated through the Terraform application. Terraform from a virgin launch, doesn't have any state and by initializing Terraform, these things happen:

- Backend init: We have a local backend for this lesson. WYSIWYG!
- Modules init: We're not using any modules. Think of these as macro Terraform configurations.
- Plugin init: Terraform plugins are downloaded if not included and plugins from the local working directory are loaded as well as in other file locations. 

The eagle eyed amongst you might have checked the directory content after doing the Terraform init. If you haven't, explore this now.

```bash
ls -la
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('terraform1', this)">Run this snippet</button>

__Bonus material__

If you want to quickly see what's inside the new directory created by Terraform, you can try the `tree` tool which displays the contents of a directory in a tree structure! This directory contains some very basic Terraform initialization.

```
tree .terraform
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('terraform1', this)">Run this snippet</button>

Terraform is very feature rich and if you're interested in reading more, the documentation is excellent which can be found [here](https://www.terraform.io/docs/index.html).

*The Terraform terraform-provider-junos-qfx is covered by a BSD-3-Clause license and copyrighted by Juniper Networks*
