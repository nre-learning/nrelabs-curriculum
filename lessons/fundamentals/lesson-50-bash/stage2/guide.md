# Introduction to BASH
## Part 2 - Variable Scope

This is the least exciting part of the lesson, but it's an important piece to understand.  Variable scope is commonly misunderstood in BASH.  If you're going to write BASH scripts, you must have a firm grasp on how variables are scoped.

There are two kinds of variables in BASH: *Environment* and *Shell*.  The difference is whether or not the variable is visible to scripts or applications that are run from the current shell.

Like the first lesson, we'll start by creating a variable and echoing its value back to us.


```
foo="FiddlyFoo and BASH too!"
echo $foo
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Easy enough... now let's see if we can echo the value of 'foo' back to us from within a script.  Let's have a look at the script first:


```
cat /antidote/stage2/echofoo.sh
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

This seems like it should work.  Let's run it.

```
/antidote/stage2/echofoo.sh
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

As you can see from the output, 'foo' is not visible to the script.  This is because 'foo', at this point, is only visible from within the shell it was created.  When you execute 'echofoo.sh', a child shell is launched to do the work.  Since 'foo' was not created in this child shell, this script can not see it.  Let's fix that.

```
export foo
/antidote/stage2/echofoo.sh
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

The export command sets the "export" attribute of the variable.  This makes 'foo' an *environment variable*.  This just means that child processes of the current shell can access these variables.  The shell that is created to execute 'echofoo.sh' is a child process.  Without the export attribute being set, 'foo' is just a *shell variable.*

---
> **_NOTE:_**  Environment variable names should be all uppercase.  Shell variables should be all undercase.  It is possible to start a variable name with something other than a letter, but don't do that.  It's not recommended.  In either case, you should use underscores to separate words in a variable's name.

---

---
> **_NOTE:_**  You can view a list of environment variables in the login shell by typing the 'env' command.  On a given system, there could be many environment variables.  Some of them are system, application, special, or otherwise reserved variables, and you should not use their names for your own variables.

---

Let's explore this a little further by running a script that creates and exports a variable, then calls yet another script to echo the value of that variable back to us.  First, we'll examine the contents of the script.

```
cat /antidote/stage2/exportvar.sh
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Ok, so we're going to create 'bar' then call a script to echo it's value back to us.  We know this won't work.  Then we export 'bar' and call that script again and of course we should now see the value of 'bar' echoed back.

```
/antidote/stage2/exportvar.sh
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Working as expected!  Since we exported 'bar' we should now see it if we try to echo it from the command-line, right?

```
echo $bar
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Nope!  Why is that?  Exported variables are only visible for the current shell and *child* processes.  Remember that a child shell is invoked to execute 'exportvar.sh'  This means the login shell from which we are launching 'exportvar.sh' is the *parent* shell.  Variables created in 'exportvar.sh' will not be visible, therefore, in the login shell.

Can we run 'exportvar.sh' in the context of the current shell?  That is, can we run it without invoking a child shell?  Yes we can!  This is called **sourcing** a script.

```
source /antidote/stage2/exportvar.sh
echo $bar
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

You can also source a script by simply using a dot.


```
unset bar
. /antidote/stage2/exportvar.sh
echo $bar
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

It is considered more correct to use a dot to source a file, as it is POSIX compliant.  This just means all shells, not just BASH shells, should understand what the dot means.  You can bore yourself to death by reading the current POSIX standard at [The Open Group website.](https://publications.opengroup.org/standards/unix/t101)  You'll need to create a free account to view it.

Again, variable scope is an important concept to understand in BASH.  Now that you have a basic understanding of scope, let's move on to positional parameters...







