## Vendor-Neutral Network Configuration with OpenConfig

**Contributed by: [@valjeanchan](https://github.com/valjeanchan) and [@jnpr-raylam](https://github.com/jnpr-raylam)**

---
### Preface
While many network operating systems run on industry standard protocols such as OSPF / BGP, network device provisioning across multiple vendors' device is still challenging as configuration syntax and methods are different across vendors. Industry once tried to solve this problem using snmp (remember SNMP set?) without much success, a more flexible approach on data schema is required to solve this problem. Enter YANG and OpenConfig.

### Chapter 1 - Install OpenConfig Yang module on Junos box

#### What is YANG?
[YANG](https://tools.ietf.org/html/rfc6020) is a data modeling language used to
model configuration and state data manipulated by [Netconf Protocol](https://tools.ietf.org/html/rfc4741#section-1.1) (rpc and notifications). However as YANG is protocol independent, YANG data models can be used independent of the transport protocols and can be converted into any encoding format supported by the network configuration protocols (such as GRPC).

#### What is OpenConfig
[OpenConfig](http://www.openconfig.net/) is an informal working group of network operators focusing on developing a consistent set of **vendor-neutral** data models using YANG based on actual operational needs from use cases and requirements from multiple network operators. These data models define the configuration and operational state of network devices for common network protocols or services.

#### Junos and YANG/OpenConfig
Junos OS supports the YANG data models configuration by importing a third-party schema package, such as OpenConfig. The package contains translation logic between the YANG schema and the Junos configuration. Juniper offers OpenConfig package starting with Junos Release 16.1.

#### Junos Openconfig package
To use OpenConfig to provision configurations, we have to install the OpenConfig package. Firstly, download the OpenConfig package from [Juniper support website](https://support.juniper.net/support/downloads/?p=openconfig).

_Starting in Junos 18.3R1, the OpenConfig package is bundled with Junos image and therefore you do not need to install it separately._

After that, copy the file to the Junos device and install the package using the following command:

```request system software add junos-openconfig-XX.YY.ZZ.JJ-signed.tgz no-validate```

> **Note:** Normally it takes less than a minute to complete the installation with physical or virtual Junos devices.  However, in NRE Labs, the vQFX run over container with limited virtualization capability, so it will take additional time to install. **Therefore, we prepared an vQFX image with OpenConfig package pre-installed.**

You can verify it with the `show version` command.

```
show version
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 0)">Run this snippet</button>

After installing the OpenConfig package, a few config stanzas with prefix `openconfig-` are added automatically. Let's take a look on the new config knob:

```
show configuration openconfig-
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 1)">Run this snippet</button>

This verifies the OpenConfig package is installed properly.

In next lesson, we will provision the vQFX using OpenConfig format with both CLI and Netconf.
