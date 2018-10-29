# Chapter 1 - Introduction to Robot Framework

Robot Framework is a Python based test automation framework, which is extensively used by the mobile, web, and embedded systems industry to perform acceptance testing. It provides a simple interface to write test-cases that can be arranged into a test-suite, and is easy to implement.

Robot is a `keyword`-driven testing framework, where keywords refer to the functions defined in any library or software that is being tested. The libaries can be written in Python or Java, but is not limited to these two.

A generic architecture of the Robot framework is show below:


![RobotFramework]()

*Reference: http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#id413* 

Let's move on to the various concepts used in Robot Framework

## Anatomy of a Robot file
A typical Robot file is shown below:
>```
>*** Settings ***
>Library    myLibrary.py
>
>*** Variables ***
>${name1}=    Jane
>${name2}=    Jane Smith
>@{namelist}=    Steve   Walt    Craig   Zac
>&{namedict}=   
> 
>*** Keywords ***
>Print Log
>   Log ${name}
>
>*** Test Cases ***
>Check Name
>   Should Be Equal ${name1}    Jane 
>```

The different sections `Settings`, `Variables`, `Keywords`, and `Testcases` are called *tables*. They are a way to arrange the different components of Robot in a neat, orderly manner.

### Syntax Rules
1. Spaces and underscores are ignored
2. Case insensitive
3. There should be a minimum of two spaces, or a tab

Let's delve into the different components in detail.
### Settings
This section is used to import external libraries, resource files, and specify the Setup/Teardown keywords(described later)

### Variables
This section defines the variables used in the test-cases. There are four types of variables:

* *Scalar variable*: A scalar varibale is replaced by its value in test-cases. They are mostly used to hold strings, but they can also hold objects like lists. They are represented using the variable identifier `$`. Eg:
>```
>*** Variables ***
>${NAME}         Jake Doyle
>```

* *List variables*: Used to store lists (Eg: Python lists). The list variables can be used to reference the whole list, or can be used to access individual list elements using the index. They are represented using the variable identifier `@`. Eg:
>```
>*** Variables ***
>@{NAMES}         Jake    Tinny    Des
>```

*   *Dictionary variables*: Used to dictionary like objects (like, Python dict()), and they are referenced using the identifier `&`. Eg:

>```
>*** Variables ***
>&{Employees}         firstname=Jake    lastname=Doyle
>```

* *Environment variables*: Used to store string environment variables, and are referenced using the identifier `%`. Eg:
>```
>*** Test Cases ***
>Log    %{HOME}
>```


### Keywords
Keywords refer to the functions supplied by a library or a test tool. 


A few example of keywords are -
+ Built-in
>```
>Should Be Equal    Jane    John
>```
This built-in keyword `Should Be Equal` will check if the next two arguments are the same, and will throw an Exception if they are unequal. Built-in is a standard library which is part of the Robot framework, and they supply a list of useful functionalities for string comparison, logging, etc.

+ User-defined
>```
>*** Keywords ***
>Print Log
>   Log ${name}
>```

Print Log is a user-defined keyword, which internally uses the keyword *Log* to print the variable *name*. In order to use this keyword inside test-cases, this has to be defined inside the Keyword table explicitly.

+ External library

Suppose we have a custom Python file, which contains the below function -
```
def is_a_substring(str1,str2)
```
This function maps into the keyword `Is A Substring` automatically, and can be invoked in Robot test-cases as below -
```
Is A Substring    Jane    Janet
```
### Test Cases
This section contains the test-cases we would like to execute, using the keywords, variables, and the libararies that we imported earlier.

The test cases are executed in the same order that they occur in the test-file.

In the below example, `Check Name` is the name of the test case, which uses the built-in keyword `Should Be Equal` to compare two strings - the scalar variable name1, and "Jane".

>```
>*** Test Cases ***
>Check Name
>   Should Be Equal ${name1}    Jane 
>```

## Running your first Robot file

In our first example, we have a Robot file `chapter1_eg1.robot`, and a python file `substring.py`.

Let's examine our python file `substring.py` -
```
cat /antidote/lessons/lesson-29/stage1/substring.py
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 10)">Run this snippet</button>

It contains a single function `is_a_substring` that takes in two strings arguments - str1 and str1. It then returns True if str1 is a substring of str2.

Let's checkout our Robot file now - 
```
cat /antidote/lessons/lesson-29/stage1/chapter1_eg1.robot
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 11)">Run this snippet</button>

Under the Settings, we import our python file `substring.py` as a Library.

We have five test-cases in total, and these will be executed one after the other. The first three test cases perform string comparison, while the last two check for substring.

We'll go ahead and start our test-cases - 
```
robot --variable HOST:10.1.0.15 --variable USER:root --variable PASSWORD:VR-netlab9 /antidote/lessons/lesson-29/stage1/chapter1_eg1.robot
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 12)">Run this snippet</button>

As expected, test-cases `Check Equal1`, `Check Equal2`, `Check Substring2` fails, and `Check Equal1`, `Check Substring1` passes. Since all the test-cases did not pass, the test-suite result is "Fail".