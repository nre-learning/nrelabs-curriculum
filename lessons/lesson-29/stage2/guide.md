## Chapter 2 - Testing Junos Device using Robot framework

Now that we have covered how to write a simple test case using Robot framework, let's use our knowledge to form testcases that verify the state of Juniper devices.

### Learning Objectives
1.  Understand the environment used for communicating with Junos devices
2.  Use keywords from junos private library
3.  Passing command line arguments to robot, and accessing them from inside the test case
3.  Passing arguments for private functions/keywords

-----
### Topology & Environment
For our next example, we have a vSRX (virtual SRX) which is our state-of-the-art firewall, connected to a linux machine. We will run our test-cases using Robot on the linux machine, and talk to the vSRX to fetch information like its modelname, OS verison, hostname, and serial number.

![Topology](https://github.com/lara29/antidote/blob/master/lessons/lesson-29/stage2/chapter2.png)

The Robot framework will use the PyEZ library to communicate with Junos devices. The PyEZ library is a wrapper written in Python, and has APIs that can be used to communicate with devices running Junos. PyEZ can be installed on Linux based machines using the command  `pip install junos-eznc`

Similar to the example in our previous chapter, we will create a python file, where we will define functions that use PyEZ library to open a connection to our device, fetch the necessary information, and close the conenction to our device.

Execute the below command to open the file *JunosDevice.py*
```
cat /antidote/lessons/lesson-29/stage2/JunosDevice.py
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 0)">Run this snippet</button>


Let's examine the file *JunosDevice.py* and understand the different functions. The main functions we will use are the below:

| Function | Description |Keyword in Robot|
| ------ | ----------- | -------------------|
| `connect_device`   | Initiates connection to the Juniper device.| `Connect Device`|
| `gather_device_info` | Fetches device facts from the Juniper |`Gather Device Info`|device, and returns the serial number, model, hostname and the OS version of the device. |
| `close_device`    | Gracefully closes the PyEZ connection, once an operation is completed. |`Close Device`|
| `get_hostname`    | Fetch hostname from the device.    |`Get Hostname`|
|   `get_model` | Fetch model name from the device.  |`Get Model`|

------

If you don't understand the implementation of these functions, do not worry! You only need to understand the functionality to use them in the Robot Framework. 

***We also have a PyEZ primer tutorial on NRE-Labs which you can refer, in case you would like to learn more about the awesome PyEZ library.*

----
### Developing test-cases

Okay, let's start developing our test cases! We will write two test cases, one for fetching and verifying the hostname, and another for the device model. We will use the functions from our custom *JunosDevice.py* file to achieve this.

Let's examine our Robot test-case file `chapter2_eg1.robot`. Execute the below command to open the file *chapter2_eg1.robot*
```
cat /antidote/lessons/lesson-29/stage2/chapter2_eg1.robot
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 1)">Run this snippet</button>

In the `Settings` table, we define our private custom library *JunosDevice.py*.

>```
>*** Settings ***
>Library	JunosDevice.py
>```


In the `Testcases` table, we have the `Check Hostname` and `Check Model` testcases.

>```
>Check Hostname
>	Connect Device	host=${HOST}	user=${USER}	password=${PASSWORD}
>	${hostname}=	Get Hostname
>	Should Be Equal As Strings	${hostname}	vsrx-robot
>	Close Device
>```
*The Check Hostname test-case verifies if the hostname of the device is 'vsrx-robot'.*

>```
>Check Model
>	Connect Device	host=${HOST}	user=${USER}	password=${PASSWORD}
>	${model}=	Get Model
>	Should Be Equal As Strings	${model}	VSRX
>	Close Device
>```
*The Check Model test-case verifies if the device model name is VSRX.*

Here, each test case consists of four keywords - `Connect Device`, `Get Hostname`, `Should Be Equal As Strings`, and `Close Device`

Here, `Connect Device`, `Get Hostname`, and `Close Device` are "user keywords" which are picked from our Library *JunosDevice.py*

The keyword `Should Be Equal As Strings` is a "built-in" keyword that can be used in any Robot testcases, and does not explictly require any library to be imported. This keyword checks if two strings variables passed to it are the same.

The IP address of the vSRX, the username and password for login, are provided to Robot by passing as command line arguments. These arguments can be accessed within the .robot file by referencing them using their names, as shown below.

>```
>Connect Device	host=${HOST}	user=${USER}	password=${PASSWORD}
>```

Execute this script by running the below command (note the command line variables passed using the flag --variable)
```
robot --variable HOST:10.1.0.15 --variable USER:root --variable PASSWORD:VR-netlab9 /antidote/lessons/lesson-29/stage2/chapter2_eg1.robot
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 3)">Run this snippet</button>

If both the test-cases succeed, the entire test-suite passes. If any of them fails, then the corresponding test-case raises an Exception which displays why the test-case failed.

To get a detailed report, we can also inspect the files log.html, report.html, and output.html, which are auto-generated for each run.