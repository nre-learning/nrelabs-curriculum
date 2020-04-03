# Version Control with Git
## Part 2 - Adding and Comitting Files

A Git repository is nothing without some files to manage. We have a sample configuration for a Junos device's
network interfaces, and we can copy this file into our new repository after entering into it:


```
cd ~/myfirstrepo/
cp /antidote/stage2/interface-config.txt .
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

We can use `git status` to see Git's current view of the repository:

```
git status
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Note that the file exists, but Git is listing it as "untracked". This means Git knows the file is there, but is otherwise not paying attention to it. The first thing we need to do is add this file to a special Git environment known as "staging". This is a temporary bucket to place changes to files before we're ready to make a commit. This is done using `git add`:

```
git add interface-config.txt
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

If we re-run `git status`, we'll now see the file is now colored green, and is in the section labeled "Changes to be committed".

```
git status
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

The term for this area in Git is called "staging". It's a sort of "waiting room" for changes that are about to be committed.

We can use the `git diff` comand with the `--cached` flag, which allows us to see the change we just staged:

```
git diff --cached
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

The key concept with Git, especially when compared with other version control systems, is that it works on **changes** to files. We've added the file `interface-config.txt` to staging, which was previously untracked, and therefore every line in that file is now in our staging environment. However, watch what happens when we add additional configuration to our file using some bash-foo, and then re-run `git status`:

```
cat <<EOT >> ~/myfirstrepo/interface-config.txt
vlans {
    default {
        vlan-id 1;
    }
}
EOT

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
git checkout interface-config.txt
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

As we can see, we're back to our original change, and we're ready to move on to the next step.

```
git status
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

## Your First Commit

Now that we have all our desired changes in staging we can create our first commit! A commit is a way of marking a particular state of a repository, saying "I would like to remember what things were like at this point in time, so I can go back to it if I need to". Often, a commit is made when a developer makes a meaningful change to some code, or an NRE updates a YAML file with a new set of variables for a switch install. No matter the use case, **the commit is king** - if it's not in a commit, Git isn't permanently tracking that change yet.

Once we've used `git add` to include all the changes we want to commit into staging, we can use `git commit` to save those changes in a commit.

```
git commit -m "Adding new interface configuration file"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

> Note the use of the `-m` flag to specify the commit message inline - you can omit this if you wish, and Git will open a text editor for you to specify your commit message. You can specify which text editor Git uses in your Git configuration.

Now that we've made a commit, we can use the `git log` command to see a list of the commits in this repository:

```
git log
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

The `--oneline` flag is a very helpful addition to this command, and lets us see each commit on its own line. This is very
useful if there are a lot of commits, and you want to see a high-level view of them:

```
git log --oneline
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

At this point, you may be wondering what those jumbled letters and numbers are to the left of the screen. Each commit gets its own cryptographic hash that uniquely identifies it. This is made using a combination of the date/time the commit was made, the contents of the commit, the parent commit (the commit before this one, if any), and a few other things.

If you look carefully at the output of the command `git commit`, which we ran a few steps ago, it actually gives you an abbreviated form of this commit ID right away - in this case, the ID is `bdb4902`:

```
antidote@linux1:~/myfirstrepo$ git commit -m "Adding new interface configuration file"
[master (root-commit) bdb4902] Adding new interface configuration file
...
```

The commit ID you see above, and in the `git log` output, will of course be different.

You can use this hash, or an abbreviated form as long as they're unique, to look up this commit in all kinds of git commands. For instance, the `git show <commit_id`> is a good way to see the details about a specific commit. Why don't you try running the following command yourself, substituting `<commit_id>` for the commit ID you got in the output of `git log` or even the output of the `git commit` command?

```
git show <commit_id>
```

## Commands Reference

To summarize, the commands we learned in this section were:

- `git status` - view the current status of files within a Git repository
- `git add` - add a file(s) or entire directory into staging
- `git checkout` - this command does quite a few things, as we'll explore in future chapters, but for now, we used it to revert a file back to what was last tracked in Git.
- `git commit` - Create an officially-tracked record of a change in Git
- `git diff` - View changes between two refs in Git - in this case, between two different versions of a file
- `git log` - View the log of commits in this Git repo.

