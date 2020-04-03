# Introduction to BASH
## Part 1 - Introduction to Variables

BASH is by far the most common UNIX shell in production systems.  In this series of lessons, you'll learn how to build simple but functional BASH scripts.  At the end, you'll have a repeatable way to customize your scripts with variables from both a configuration file and from the command-line.

Let's get some preliminary stuff out of the way.  Specifically, we're going to start with an introduction to variables in BASH.

We'll start by creating a variable and echoing its value back to us.


```
foo="FiddlyFoo and BASH too!"
echo $foo
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Note the syntax of these commands.  The first line is pretty straightforward, as we've simply assigned a string to 'foo.'  In the second line, however, we have a '$' preceding the variable name.  This tells BASH to perform *parameter expansion*.  This means that the value of 'foo' will be substituted for '$foo'.

What if you no longer need a variable you have created?  You can delete a variable with the 'unset' command.

```
unset foo
echo $foo
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Sometimes you'll need to place a variable into a string.  Let's try doing that by running the snippet below.

```
foo=beer
echo "I like drinking many $foos!"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Hey!  Where did my beers go?  In this case, the BASH parser was looking for a variable called 'foos'.  In order to fix this, we should enclose 'foo' with curly braces.  Curly braces are the formal, unambiguous way of referring to a variable in BASH.

```
echo "I like drinking many ${foo}s!"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>


There we go!  There are many things to know about BASH variables such as naming conventions, variable scope, parameters, and much more.  We'll discuss a lot of these things as we move through this lesson.

So we'll finish this virtual beer, and move on to.. variable scope!









