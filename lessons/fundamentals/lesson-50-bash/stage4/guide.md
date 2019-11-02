# Introduction to BASH
## Part 3 - Positional Parameters

You can pass values to a BASH script in two ways.  You can use *positional parameters* or you can use *options*.  Positional parameters are the easiest, so we'll start with that.  Let's have a look at a script that takes two parameters and echos them back to us.

```
cat /antidote/stage3/echoparms.sh
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

This script takes two arguments, '$1' and '$2'. These represent the first and second parameters passed to the script, respectively.

```
/antidote/stage3/echoparms.sh beer drink
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Sounds like great advice to me.  What about '$0' though?  In the case of bash, it's always '-bash'.  See for yourself:

```
echo $0
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

You can have more than 9 positional parameters, but any position number that requires multiple digits to reference (10 and above), must be enclosed with curly braces.  See what happens with and without the curly braces by running the snippet below:

```
/antidote/stage3/echo10parms.sh one two three four five six seven eight nine ten
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Without the curly braces, the BASH parser stops at the first digit after the '$'.  As we saw in part 1, curly braces are the formal, unambiguous way to reference a variable.

---
> **_NOTE:_** It is possible to use a number for the first character in a variable name.  However, this is not recommended for a variety of reasons, including the example presented here.

---

There are three special variables you should be aware of when working with positional parameters:  '$@', '$*', and '$#'.  The first two each contain all the parameters passed to the script.  We'll ignore these two for now.

The variable '$#', however, has at least one easily understood purpose.  It contains the number of parameters passed to the script.  If you are expecting a certain number of parameters, then you can check that you have the right number using '$#'.

Let's look at a script that does this.

```
cat /antidote/stage3/checkparms.sh
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

For now, don't worry about all the code here.  We'll cover conditional logic in a later part of the lesson.  The important thing here is that the script is expecting four parameters.

Now let's run it with just three parameters to see what happens.

```
/antidote/stage3/checkparms.sh one two three
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>


Excellent!  Now let's try another way you can pass parameters to a BASH script with the 'getopts' built-in BASH utility.

