# Chapter 3 - Developing Test cases using Robot framework - Part 2

Now that we have covered how to write robot files which verify the state of Juniper devices, let's delve into more advanced concepts and discuss some best practices.

## Defining User Keywords

While writing more complex network validation robot files, you'll soon realize that you end up repeating and rewriting some fixed series of keywords and logical statements over and over again. These are usually common across all the test cases. To avoid doing this and also to decrease the overall length of the robot file, we define *user keywords*.  User keywords are new, high-level keywords which club together multiple preexisting keywords and logical statements. In a robot file, the user keywords are defined under the *Keywords* table. The use of user keywords has been demonstrated in Test Case 1.

## Using Resource Files

All the *variables* and *user keywords* defined inside a robot file can only be used within the file in which they were created. In order to reuse these variables and keywords across multiple robot files, we create resource files. Resource files have the same syntax as robot files, the only difference being, they cannot contain the *Test Case* table. Also, the *Settings* table can only contain the imported files (Library, Resource, Variables) and the documentation. The use of separate resource files also helps in separating test cases from auxiliary data. This helps in keeping the test cases file uncluttered and better organized, with only the relevant test cases being a part of it. Resource files can be imported by the other robot files inside the *Settings* table using the *resource* setting. The use of user keywords has been illustrated in Test Case 2.

## Variable Files

Variable files, like resource files, can be used to share variables across multiple test case robot files. Variable files are implemented as a Python module. All the variables declared inside a Python module can be directly imported by a robot file, under the settings table with the variable keyword. For more information on Variable files, refer [More Info](http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#variable-files)

## Setup and Teardown

The robot framework supports two types of setup and teardown functions. The first ones are "Test Setup" and "Test Teardown" and the second ones are "Suite Setup" and "Suite Teardown". The keywords defined under the *Test* Setup and Teardown settings are run before and after every test case. The keywords defined under the *Suite* Setup and Teardown settings are run before and after every test suite(multiple test cases). Suppose a NETCONF/SSH connection is initialized and terminated, before and after every test case. In this scenario, the size of the robot file can be reduced by using the Setup and Teardown settings, as required.
\
\
Now it's time to roll up your sleeves and jump on to tackling the final two test cases of this tutorial. Are you as thrilled as I am? Let's roll!

## Test Case 1
Let's examine our Robot test-case file `chapter3_eg1.robot`. Execute the below command to open the file *chapter3_eg1.robot*
```
cat /antidote/lessons/lesson-29/stage3/chapter3_eg1.robot
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 0)">Run this snippet</button>

You must have noticed the new *Keywords* table in our robot file. Inside this table, two new keywords have been defined, Log Facts and Validate Facts. Allow me to explain each of these separately.

>```
>Log Facts
>    &{facts}=	Gather Device Info
>    :FOR  ${key}  IN  @{facts.keys()}  
>    \  Log  ${facts["${key}"]}
>```

In this example, the *Gather Device Info* keyword returns a python dictionary, consisting of some basic device properties like serial number and the hostname, in a key-value format. Notice that we are using a FOR loop to parse a python dictionary which was stored in the *facts* variable. Observe that the syntax declaring a FOR loop in the robot framework is similar to that in Python. In the end, we are using the *Log* keyword to log the values for every key in the returned dictionary. All these functions defined under the *Log Facts* keyword get executed whenever this keyword is called inside the robot file. 

Let's now examine the second user keyword in the settings table.

>```
>Validate Facts
>	 &{facts}=	Gather Device Info
>    Should Be Equal As Strings  ${facts["hostname"]}  vsrx-robot
>    Should Be Equal As Strings  ${facts["model"]}  VSRX
>```

In this user keyword, we are first gathering the device information, storing it in a variable and then comparing whether the value pertaining to the *hostname* key of *facts* variable is equal to the string "vsrx-robot" or not. We do the same for the *model* key of *facts* variable.

Let's now have a look at the test cases:

>```
>*** Test Cases ***
>Log Device Facts
>	Connect Device  host=${HOST}	user=${USER}	password=${PASSWORD}
>	Log Facts
>	Close Device
>
>Verify Facts
>	Connect Device  host=${HOST}	user=${USER}	password=${PASSWORD}
>	Validate Facts
>	Close Device
>```

Notice that both of the test cases are using the previously defined user keywords from the Keywords section of the robot file. Execute these test cases by running the robot script using the following command (note the command line variables passed using the flag --variable)
```
robot --variable HOST:10.1.0.15 --variable USER:root --variable PASSWORD:VR-netlab9 /antidote/lessons/lesson-29/stage2/chapter3_eg1.robot
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 4)">Run this snippet</button>



## Test Case 2

Let's examine our Robot test-case file `chapter3_eg2.robot`. Execute the below command to open the file *chapter3_eg2.robot*
```
cat /antidote/lessons/lesson-29/stage3/chapter3_eg2.robot
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 5)">Run this snippet</button>

Note that the robot file has only got two sections and inside the *Settings* section, a separate robot file has been imported using the *Resource* setting. This file is called the resource file. Also observe that there are two other settings present inside the *Settings* table, namely "Test Setup" and "Test Teardown". These settings call keywords which have been originally defined in the resource file.

Let's now check out our resource file. Execute the below command to open the file *chapter3_resource.robot*
```
cat /antidote/lessons/lesson-29/stage3/chapter3_resource.robot
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 6)">Run this snippet</button>

Notice that this time, we have declared all the required variables in the "Variables" section of the resource file. What this means is that we will no longer have to pass the variable names while running the robot file. Also, observe that three user keywords have been defined under the "Keywords" section in the resource file. Two of these keywords, "Setup Actions" and "Teardown Actions", have been used by the Setup and Teardown settings of our master robot file. The third keyword, Validate Facts, has been used by a test case inside the robot file. Execute the robot script by running the below command
```
robot /antidote/lessons/lesson-29/stage2/chapter3_eg2.robot
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 7)">Run this snippet</button>

