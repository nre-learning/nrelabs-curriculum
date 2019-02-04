## Automating with Openconfig

**Contributed by: [@valjeanchan](https://github.com/valjeanchan) and [@jnpr-raylam](https://github.com/jnpr-raylam)**

---

### Chapter 1 - Install Openconfig Yang module on Junos box

[Placeholder to introduce OpenConfig / Yang, and what's their benefits]

To use OpenConfig to provision configurations, we have to install OpenConfig package. First, you can download the OpenConfig package from [Juniper support website](https://support.juniper.net/support/downloads/?p=openconfig).

_Starting in Junos 18.3R1, the OS image includes the OpenConfig package and therefore you do not need to install it separately._

After that, copy the file to Junos device and install the package by `request system software add junos-openconfig-XX.YY.ZZ.JJ-signed.tgz no-validate`

Normally it takes below 1 minute to complete the installation if you're using physical boxes or virtual devices in fully virtualized environment.  However, in NRE Labs, we run the vQFX over container with limited virtualization capability, so it takes pretty long time to install the package.

Therefore, we prepare an vQFX image with OpenConfig package pre-installed. You can verify it by `show version` command.

```
show version
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 0)">Run this snippet</button>


After installed the OpenConfig package, few config stanzas with prefix `openconfig-` are added. Let's take a look on the new config knob.

```
show configuration openconfig-
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 1)">Run this snippet</button>

In next lesson, we will provision the vQFX in OpenConfig format using both CLI and Netconf.
