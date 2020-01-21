# Version Control with Git
## Part 2 - Adding and Comitting Files

A Git repository is nothing without some files to manage. Within our new repo, let's create a text file and add some text to it:

```
cd ~/myfirstrepo/ && echo "this is some text" > newfile.txt
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

We can use `git status` to see Git's current view of the repository:

```
git status
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Note that while the file exists, Git is listing it as "untracked", meaning Git knows the file is there, but is otherwise not paying attention to it. The first thing we need to do is add this file to a special Git environment known as "staging". This is a temporary bucket to place changes to files before we're ready to make a commit. This is done using `git add`:

```
git add newfile.txt
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

If we re-run `git status`, we'll now see the file is in staging. Git refers to this in the output as `Changes to be committed`:

```
git status
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

We can use the `git diff` comand with the `--cached` flag, which allows us to see the change we just staged:

```
git diff --cached
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

The key concept with Git, especially when compared with other version control systems, is that it works on **changes** to files. We've added the file `newfile.txt` to staging, which was previously untracked, and therefore every line in that file is now in our staging environment. However, watch what happens when we add another line to the file:

```
echo "this is even more text!" >> newfile.txt
git status
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

It looks like there are now two copies of the file, doesn't it? This isn't actually true, however. Remember that Git works on **changes** to files, and we staged the first change, and haven't staged the second. We can use the `git diff` command with the `--cached` flag as before to see that our staged change is still there. If we also run `git diff` without any flags, it will show us what has changed **outside** of staging:

```
git diff --cached
git diff
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

There are a few things we can do at this point, depending on what we wanted to do with the additional change. Let's say we want to get rid of the second change, but keep the first in staging. In this case, the `git checkout` command can help us. By specifying this command with the name of the file, we're telling Git to revert back to the last known change for that file, which in this case is the one in staging:

```
git checkout newfile.txt
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

As we can see, we're back to our original change, and we're ready to move on to the next step.

```
git status
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

## Your First Commit

Now that we have all our desired changes in staging we can create our first commit! A commit is a way of marking a particular state of a repository, saying "I would like to remember what things were like at this point in time, so I can go back to it if I need to. Often, a commit is made when a developer makes a meaningful change to some code, or an NRE updates a YAML file with a new set of variables for a switch install. No matter the use case, **the commit is king** - if it's not in a commit, Git isn't permanently tracking that change yet.

Once we've used `git add` to include all the changes we want to commit into staging, we can use `git commit` to save those changes in a commit.

```
git commit -m "My first commit!"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

> Note the use of the `-m` flag to specify the commit message inline - you can omit this if you wish, and Git will open a text editor for you to specify your commit message. You can specify which text editor Git uses in your Git configuration.

See what you did:

```
git log
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>



## Commands Reference

To summarize, the commands we learned in this section were:

- `git status` - view the current status of files within a Git repository
- `git add` - add a file(s) or entire directory into staging
- `git checkout` - 
- `git commit` - 
- `git diff` - 
- `git log` - 
