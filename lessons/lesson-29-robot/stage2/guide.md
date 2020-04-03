## Using Robot Framework for Automated Testing

**Contributed by: [@saimkhan92](https://github.com/saimkhan92) and [@lara29](https://github.com/lara29)**

---

### Chapter 2 - Writing Test Cases for Junos Devices

Now that we have covered how to write a simple test case using Robot framework, let's use our knowledge to form test cases that verify the state of Juniper devices.

In this section, we'll:

1. Understand the environment used for communicating with Junos devices
2. Use keywords from Junos private library
3. Pass command line arguments to Robot, and access them from inside the test case
4. Pass arguments for private functions/keywords

For our next example, we have a vQFX (virtual QFX) device `vqfx1` connected to a Linux machine. We will run our test-cases using Robot on the Linux machine, and talk to the vQFX via NETCONF to fetch information like its model name, OS version, hostname, and serial number.

For simplicity, Robot framework will use the PyEZ library to communicate with Junos devices. PyEZ is a NETCONF library written in Python and can be used to communicate with devices running Junos. We cover PyEZ in <a href="/labs/?lessonId=16&lessonStage=1" target="_blank">it's own lesson</a> - check it out!

PyEZ can be installed on Linux based machines using the command  `pip install junos-eznc`. We've already done this in this lesson environment.

Similar to the example in the previous chapter, we will create a python file (Robot private library), where we will define functions that use the PyEZ library to open a connection to our device, fetch the necessary information, and close the connection to our device.

Let's examine the file `JunosDevice.py` and understand the different functions.:
```
cat /antidote/stage2/JunosDevice.py
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Here's some detail around the functions we'll be using in our Robot tests from this library:

---

<table style="width:100%">
  <tr>
    <th>Function</th>
    <th>Description</th>
    <th>Keyword in Robot</th>
  </tr>
  <tr>
    <td>connect_device</td>
    <td>Initiates a connection to the Juniper device</td>
    <td>Connect Device</td>
  </tr>
  <tr>
    <td>gather_device_info</td>
    <td>Fetches device facts from the Juniper</td>
    <td>Gather Device Info</td>
  </tr>
  <tr>
    <td>close_device</td>
    <td>Gracefully closes the PyEZ connection, once an operation is completed</td>
    <td>Close Device</td>
  </tr>
  <tr>
    <td>get_hostname</td>
    <td>Fetch hostname from the device</td>
    <td>Get Hostname</td>
  </tr>
  <tr>
    <td>get_model</td>
    <td>Fetch model name from the device</td>
    <td>Get Model</td>
  </tr>
</table>

---

Observe that theses python functions are exposed as Robot keywords inside the Robot files. Also note that the robot keywords, unlike the python functions, don't contain the underscore and are case insensitive. If you don't understand the implementation of these functions, do not worry! You only need to understand the functionality to use them in the Robot Framework.

Okay, let's start developing our test cases! We will write two test cases, one for fetching and verifying the hostname, and another for the device model. We will use the keywords from our private library, `JunosDevice.py`, to achieve this.

Let's examine our Robot test-case file `chapter2_eg1.robot`:

```
cat /antidote/stage2/chapter2_eg1.robot
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

In the `Settings` table, we define our private custom library `JunosDevice.py`:

>```
>*** Settings ***
>Library    JunosDevice.py
>```

In the `Test Cases` table, we have the `Check Hostname` and `Check Model` test cases.

The `Check Hostname` test-case verifies if the hostname of the device is 'vqfx1':

>```
>Check Hostname
>    Connect Device    host=${HOST}    user=${USER}    password=${PASSWORD}
>    ${hostname}=    Get Hostname
>    Should Be Equal As Strings    ${hostname}    vqfx1
>    Close Device
>```

The `Check Model` test-case verifies if the device model name is `VQFX-10000`:

>```
>Check Model
>    Connect Device    host=${HOST}    user=${USER}    password=${PASSWORD}
>    ${model}=    Get Model
>    Should Be Equal As Strings    ${model}    VQFX-10000
>    Close Device
>```

Here, each test case consists of four keywords - `Connect Device`, `Get Hostname`, `Should Be Equal As Strings`, and `Close Device`

`Connect Device`, `Get Hostname`, and `Close Device` are keywords which are picked from our private Library `JunosDevice.py`.

The keyword `Should Be Equal As Strings` is a "built-in" keyword that can be used in any Robot test case, and does not require any library to be imported. This keyword checks if two strings variables passed to it are the same.

The IP address of the vQFX, the username, and password for login, are provided to Robot by passing as command line arguments. These arguments can be accessed within the .robot file by referencing them using their names, as shown below:

>```
>Connect Device    host=${HOST}    user=${USER}    password=${PASSWORD}
>```

Execute this test suite by running the below command (note the command line variables passed using the flag --variable)

```
robot --variable HOST:vqfx1 --variable USER:antidote --variable PASSWORD:antidotepassword /antidote/stage2/chapter2_eg1.robot
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

If both the test-cases succeed, the entire test-suite passes. If any of them fails, then the corresponding test-case raises an Exception which displays why the test case failed.

To get a detailed report, we can also inspect the files log.html, report.html, and output.html, which are auto-generated for each run.
