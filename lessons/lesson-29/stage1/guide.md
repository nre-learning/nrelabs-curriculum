# Chapter 1 - Introduction to Robot Framework

Robot Framework is a Python based test automation framework, which is extensively used by the mobile, web, and embedded systems industry to perform acceptance testing. It provides a simple interface to write test-cases that can be arranged into a test-suite, and is easy to implement.

Robot is a `keyword`-driven testing framework, where keywords are the functions defined in any library or software that is being tested. The libaries can be written in Python or Java, but is not limited to these two.

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
>*** Testcases ***
>Check Name
>   Should Be Equal ${name1}    Jane 
>```

The different sections `Settings`, `Variables`, `Keywords`, and `Testcases` are called tables. They are a way to arrange the different components of Robot in a neat, orderly manner.

### Syntax Rules
1. Spaces and underscores are ignored
2. Case insensitive
3. There should be a minimum of two spaces, or a tab

Let's delve into the different components in detail.
### Settings
This section is used to import external libraries, resource files, and specify the Setup/Teardown keywords(described later)

### Variables
This section defines the variables used in the test-cases. There are three types of variables:

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

