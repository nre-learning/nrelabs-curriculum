## Chapter 1 - Introduction to Robot Framework

Robot Framework is a Python based test automation framework, which is extensively used by the mobile, web, and embedded systems industry to perform acceptance testing. It provides a simple interface to write test-cases that can be arranged into a test-suite, and is easy to implement.

Robot is a `keyword`-driven testing framework, where keywords are the functions defined in any library or software that is being tested. The libaries can be written in Python or Java, but is not limited to these two.

A generic architecture of the Robot frame work is show below:


![RobotFramework]()

*Reference: http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#id413* 

Let's move on to the various concepts used in Robot Framework

### Anatomy of a Robot file
A typical Robot file is shown below:
>```
>*** Settings ***
>Library myLibrary.py
>
>*** Variables ***
>${name1}=  Jane
>${name2}=  Jane Smith
>@{namelist}=   Steve   Walt    Craig   Zac
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

The different sections `Settings`, ``
#### Keywords
Keywords are the functions supplied by a library or a test tool. The libraries can be external libraries, or a user-defined python or java files. Built-in is a standard library which is part of the Robot framework, and they supply a list of useful functionalities like string compare.