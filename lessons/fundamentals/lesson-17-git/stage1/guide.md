# Version Control with Git
## Part 1 - Your First Commit

Software developers have been using version control systems like Git to improve the way they manage changes to their code. Instead of just relying on the "undo" button, version control maintains a detailed history of every change to a file, so that you can roll back changes, maintain different versions, and more. 

However, there's **nothing** about Git or version control in general that requires you to be a software developer, or even that you manage code of any kind with it. At the end of the day, as long as you're managing some kind of text format, you should be using version control to record changes to it.

Incidentally, in the world of Network Reliability Engineering, not only do we have a need for using Git as a version control system for scripts or other kinds of code we might write for automation-related purposes, we can also use it to version-control things like YAML files, network configs, and more.

In this lesson, we'll learn the very basics of Git, especially as it pertains to network automation and network reliability engineering.

We refer to a group of directories and files managed by Git as a "repository" (or often, a "repo")

```
mkdir myfirstrepo/ && cd myfirstrepo/
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Right now, `myfirstrepo` is just a regular directory. We can "initialize" a new git repository in this directory using `git init`:

```
git init
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Before we go further, we should tell Git some information about us. At a minimum, in order to make commits, we need to provide a username and an email address:

```
git config --global user.email "jane@labs.networkreliability.engineering"
git config --global user.name "Jane Doe"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

The `--global` flag sets this in your Git configuration for the entire machine. You can omit this flag to only set it for this repository. This information is used to identify who has made changes to the files in the repository.

A Git repository is nothing without some files to manage. Let's create a text file and add some text to it:

```
echo "this is some text" > newfile.txt
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

We can use `git status` to see Git's current view of the repository:

```
git status
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Note that while the file exists, Git is listing it as "untracked", meaning it's not actually part of the Git repo. In order to formally include a file in a Git repository, we must commit it. In order to commit it, we must first add it to "staging". This is done using `git add`:

```
git add newfile.txt
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Now that the file is in staging, we can create our first commit! A commit is a way of marking a particular state of a repository, saying "I would like to remember what things were like at this point in time, so I can go back to it if I need to. Often, a commit is made when a developer makes a meaningful change to some code, or an NRE updates a YAML file with a new set of variables for a switch install. No matter the use case, **the commit is king**.

Once we've used `git add` to include all the changes we want to commit into staging, we can use `git commit` to save those changes in a commit.

```
git commit -m "My first commit!"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1',5)">Run this snippet</button>

> Note the use of the `-m` flag to specify the commit message inline - you can omit this if you wish, and Git will open a text editor for you to specify your commit message

