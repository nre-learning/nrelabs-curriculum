# Terraform & Junos
## Part 5 - Bonus Material

Working declaratively with Terraform is an excellent way to work and can significantly remove brain cycles thanks to easy resource life-cycle management.

Before we do any more, let's make sure we're in the correct working directory.

```
cd /antidote/lessons/lesson-31/terraform/bonus/
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('terraform1', this)">Run this snippet</button>

__Implicit vs Explicit Graph Dependencies__

In [stage3](https://labs.networkreliability.engineering/labs/?lessonId=31&lessonStage=3) of this lesson, you learned about how explicit dependency creation using the `depends_on` key. The second way is to use variable interpolation. Complex graphs can be created using this methodology. It's also possible to pass in static data resources too and we won't cover that here.

Instead we'll explore creating an implicit dependency between a VLAN and a Layer Two access port.

Let's go ahead and see if we can create an implicit dependency using variables!

```
terraform init
terraform plan
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('terraform1', this)">Run this snippet</button>

What you should see is a plan that looks like the following:

```
------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  + junos-qfx_vlan.vlan42_deep_thought
      id:            <computed>
      resource_name: "vlan_42_deep_thought"
      vlan_desc:     "Connected To DT, REMOVE and face angry mice"
      vlan_name:     "Magrathea"
      vlan_num:      "42"

  + junos-qfx_vlan-access-port.xe_0_0_0
      id:            <computed>
      port_desc:     "DT access port mapped to VLAN 42"
      port_name:     "xe-0/0/0"
      port_vlan:     "Magrathea"
      resource_name: "deep_thought_uplink"


Plan: 2 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------
```


Notice that the VLAN resource is at the top? We can guarantee this order by forming dependencies. Let's take a look at the Terraform configuration files that enabled this graph to be composed.

```
cat vlan_42_dt.tf
cat access_port_dt.tf
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('terraform1', this)">Run this snippet</button>

You should see variables being used which refers to the resource name and the key within the resource like:

```
${junos-qfx_vlan.vlan42_deep_thought.vlan_num}
```

The plan that was generated should make more sense now. Take the access port description key which in the `.tf` file looks like this: `port_desc = "DT access port mapped to VLAN ${junos-qfx_vlan.vlan42_deep_thought.vlan_num}"`. On the plan Terraform interpolated the variable to be the number 42, which was what we required!

__Human Errors__

When humans get involved in troubleshooting, we have a tendency to change a bunch of stuff without clearing up 100% afterwards. When this happens with Terraform configured resources, the Terraform state cache could get out of sync with reality and luckily there is a way to sync it back up.

```
terraform refresh
```

Refresh performs a read of the resources and updates the state cache. If something has changed and you re-run `terraform plan`, the execution plan will reflect that of the Terraform resources and not the human changes. Great for golden state checking, but not great in what should be a fully automated set of infrastructure.

The Junos provider doesn't quite support this, yet, but will soon!

__Partial Delete__

What happens if you don't want to destroy everything in a set of Terraform configurations? Hashicorp thought about this and it's possible to delete single resources.

```
terraform destroy -h
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('terraform1', this)">Run this snippet</button>

See the `-target` argument?

## Close Out

There is so much to explore with Terraform and for every scenario you can find yourself in, Terraform has probably got it covered. The help argument `-h` works with Terraform at all levels and we highly recommend exploring it in more depth!

Welcome to the world of declarative infrastructure and application management and we hope you enjoyed this lesson as much as we enjoyed creating it!

*The Terraform terraform-provider-junos-qfx is covered by a BSD-3-Clause license and copyrighted by Juniper Networks*
