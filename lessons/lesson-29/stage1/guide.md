# Chapter 1 - Introduction to Robot Framework

Robot Framework is a Python based test automation framework, which is extensively used by the mobile, web, and embedded systems industry to perform acceptance testing. It provides a simple interface to write test-cases that can be arranged into a test-suite and is easy to implement.

Robot is a `keyword-driven` testing framework, where all the actions and functions of the test suite are performed using simple, human-understandable keywords.

A generic architecture of the Robot framework is shown in the lesson diagram.

Reference: [Robot Framework User Guide](http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#id413)

Let's move on to the various concepts used in Robot Framework

---

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

### Settings
This section is used to import standard libaries, external libraries, resource files, variable files, and Setup/Teardown settings. The purpose of these libraries and files has been explained in the later sections.

### Variables
This section defines the variables used in the test cases. There are four types of variables:

* *Scalar variable*: A scalar variable is replaced by its value in test-cases. They are mostly used to hold strings, but they can also hold objects like lists. They are represented using the variable identifier `$`. Eg:
>```
>*** Variables ***
>${NAME}         Jake Doyle
>```

* *List variables*: Used to store lists (Eg: Python lists). The list variables can be used to reference the whole list or can be used to access individual list elements using the index. They are represented using the variable identifier `@`. Eg:
>```
>*** Variables ***
>@{NAMES}         Jake    Tinny    Des
>```

*   *Dictionary variables*: Used to store dictionary-like objects (like Python dict()), and they are referenced using the identifier `&`. Eg:

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

Keywords are used to implement the real testing capability of the Robot framework. These keywords are provided by various test libraries which are a part of the Robot Ecosystem. These libraries, which expose keywords to the robot files are of the following types:
  * Standard Library - Consists of a set of libraries come bundled-in as part of the Robot Framework. Example: OperatingSystem, Collections, DateTime etc.
  * External Library - Can be downloaded using pip. Example: Android library, HTTP library etc.
  * Private Library - Can be a self created Python or Java file. Example: JunosDevice.py, a private library, described in stage2 of this tutorial.
  * Built-in keyword Library - This is a part of the standard library which provides a set of frequently used generic keywords used for string comparison, logging, etc.

To use the keywords defined by the standard, external, and private libraries, the respective libraries first need to be imported in the Settings table of a Robot file. Built-in keywords can be used out-of-the-box without the need to import any library in the *Settings* section. Also, it should be noted that the keywords behave like functions - they can take in arguments and can return values back.

A few examples of keywords are -
+ Built-in keywords
>```
>Should Be Equal    Jane    John
>```
This built-in keyword `Should Be Equal` will check if the next two arguments are the same, and will throw an Exception if they are unequal.

+ Private library keywords

Suppose we have a custom Python file, which contains the below function -
>```
>def is_a_substring(str1,str2)
>```
This function maps into the keyword `Is A Substring` automatically, and can be invoked in Robot test-cases as below -
>```
>Is A Substring    Jane    Janet
>```

### Test Cases
This section contains the test-cases we would like to execute, using the keywords, variables, and the libraries that we imported earlier.

The test cases are executed in the same order that they occur in the test-file.

In the below example, `Check Name` is the name of the test case, which uses the built-in keyword `Should Be Equal` to compare two strings - the scalar variable name1, and "Jane".

>```
>*** Test Cases ***
>Check Name
>   Should Be Equal ${name1}    Jane 
>```

### General Syntax rules

1. There should be atleast two spaces between the following:
    - Keywords and Keywords
    - Keywords and Arguments
    - Arguments and Arguments
2. Keywords and variables are case-insensitive

---

## Running your first Robot file

In our first example, we have a Robot file `chapter1_eg1.robot`, and a python file `substring.py`.

Let's examine our python file `substring.py` -
```
cat /antidote/lessons/lesson-29/stage1/substring.py
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 9)">Run this snippet</button>

It contains a single function `is_a_substring` that takes in two strings arguments - str1 and str1. It then returns True if str1 is a substring of str2.

Let's checkout our Robot file now - 
```
cat /antidote/lessons/lesson-29/stage1/chapter1_eg1.robot
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 10)">Run this snippet</button>

Under the Settings, we import our python file `substring.py` as a Library.

We have five test-cases in total, and these will be executed one after the other. The first three test cases perform string comparison, while the last two execute the substring function.

We'll go ahead and start our test-cases - 
```
robot /antidote/lessons/lesson-29/stage1/chapter1_eg1.robot
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 11)">Run this snippet</button>

As expected, test-cases `Check Equal1`, `Check Equal2`, `Check Substring2` fails, and `Check Equal1`, `Check Substring1` passes. Since all the test-cases did not pass, the test-suite result is "Fail".