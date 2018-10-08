# Linux Basics
## Part 1 - Using the Bash Shell

Welcome to "Linux Basics". While it's fun to talk about complex config management tools like Ansible, or get into scripting with Python, there's a more fundamental skill that underlies all of these. Knowing your way around a Linux system is becoming more than just a good idea, it's becoming table stakes if you want to get **anything** done in network automation or reliability engineering, and soon, it will be a given for all of networking.

So, if you want to future-proof not only your network automation skills but also your networking skills as a whole, you've come to the right place. While a comprehensive overview of Linux is best saved for the massive amount of learning materials available on the subject, this lesson will focus on the really important aspects of knowing your way around a Linux system, especially as it pertains to being able to use Linux on your journey to Network Reliability Engineering.

In this part of the lesson, we'll learn about Bash, which is an incredibly popular shell, present on nearly every *nix system. Think of it as the Cisco IOS CLI of Linux - it really is that pervasive. If you've ever looked at the command-line of a linux system, it was likely Bash that you saw.

Let's learn a few important commands. We have a `linux1` system spun up in the terminal to the right, and the first thing we should do is get familiar with our filesystem. First, the `pwd` command tells us which directory we're in right now:

```
pwd
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 0)">Run this snippet</button>

This is our "home" directory - the directory we start in by default when logged in as this user. Let's create a new directory called `mydirectory` by using the `mkdir` command:

```
mkdir newdirectory
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 1)">Run this snippet</button>

No matter which directory you're currently in, you'll periodically want to know what it contains. For instance, we're still in our home directory, so we can use `ls` with a few flags to list all the files in this directory.

```
ls -lha
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 2)">Run this snippet</button>

You may notice the flags `l`, `h`, and `a` are used here. These are optional, but a very common addition to `ls` because they do a few useful things for us:

- `l` - output in list view in long format, instead of the usual "paragraph-style" view
- `h` - provide human-readable values for filesize. E.g. instead of `6158` (which is bytes), we'll see `6.1K`)
- `a` - show all files, including those that begin with a dot (`.`)

Many systems alias this command to `ll` so you don't have to type out all the flags. Ours doesn't, but we can add an alias for it ourselves:

```
alias ll="ls -lha"
ll
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 3)">Run this snippet</button>

Note that by default, `ls -lha` (or our new alias `ll`) assumes you want to list the files (and directories) in the directory you're currently in, but we can provide a directory after the command to list the files in that location (assuming we have permissions to do so):

```
ll /
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 4)">Run this snippet</button>

This command listed all the files in the directory `/`, which is known as the "root directory". This is the highest point in the directory structure - there's nothing above this. All of the files and directories you see in this output

While we were able to list the contents of the root directory, our present working directory is still our home directory. We've been camping out in the home directory for a while - let's change to the new directory we created earlier:

```
cd newdirectory/
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 5)">Run this snippet</button>

This is an empty directory (hint: try running `ll` here) so let's create a file. The `touch` command creates a new, empty file with the name you specify:

```
touch newfile.txt
ll
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 6)">Run this snippet</button>

Let's take a closer look at the output of `ll`. We can see the file we created, but we see three entries, instead of just one.

The other two entries are present in nearly every directory. `.` is a shortcut for the current directory, and `..` is a shortcut for the parent directory.

```
antidote@linux1:~/newdirectory$ ll
total 0
drwxrwxr-x. 2 antidote antidote 25 Oct  8 09:08 .                      <---- Current Directory
drwxr-xr-x. 1 antidote antidote 40 Oct  8 09:08 ..                     <---- Parent Directory
-rw-rw-r--. 1 antidote antidote  0 Oct  8 09:08 newfile.txt
```

The latter, `..`, is super useful for being able to just "go up a directory", without having to use the absolute path we saw before (remember the output of `pwd`?). Every directory except the root directory has a parent, so we can use the shortcut `..` as an argument to `cd` to return to the home directory, as well as the parent of any other directory we may find ourselves in:

```
cd ..
ll
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 7)">Run this snippet</button>
