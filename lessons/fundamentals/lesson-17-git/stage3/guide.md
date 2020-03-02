# Version Control with Git
## Part 3 - Parallelizing Your Work With Git Branches

As Git is a distributed version control system, it's often the case that you want to work in parallel with either other engineer, or even yourself, as you work on different aspects of a given repository. Imagine you have two change windows, one of which is more complicated but happens a few weeks away, and another which is tomorrow night but is fairly simple. If you have your configurations or scripts for these changes in a Git repository, it's likely that you'll have to work on both at the same time at some point, which making sure the two changes don't step on each other in the process.

Enter the concept of "[branching](https://git-scm.com/book/en/v2/Git-Branching-Branches-in-a-Nutshell)" in Git, to solve this exact problem. Using branches, we can effectively manage two "versions" of the repository, making commits all along the way, and then only once we're ready, merge them back together (if that's what we want to do).

Now, it's worth mentioning that for most that are new to Git or version control in general, this is where things start to get complicated. Stay persistent, and re-run this lesson a few times if you have to. This is part of the Git workflow you'll need to develop for yourself that will take a few times to get right, but once you have it, you'll be unstoppable.

## Creating a Branch

Let's get back into our repository.

```
cd ~/myfirstrepo/
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Git's default branch is called `master`. This is the starting place for most Git repositories you might come across. It's typically used as the "official" copy of the repository. The `master` branch is often where you might find the latest, somewhat stable version of a codebase or other repository.

We can see our repository currently has the `master` branch checked out by using `git status` again (Note the text `On branch master`).

```
git status
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Generally, work-in-progress is not done here, but rather on other branches. Much of the reason we use branches in Git to do our work is in order to keep `master`  more pristine and stable. In fact, for many projects, it's okay to even have totally broken code in a branch as you work on it, but before it's merged back into `master`, it must pass tests, code review, etc. This gives us space to work on a problem without the restrictions of keeping things "working" for others that just want to use the code.

In the beginning of this section, we used the example of a change window where you want to make a change to a network configuration. Let's say you've opened a ticket with your change review board, and you've been assigned a change ID of 123. Since you've already started using Git to track changes to your configurations, you can use this ID in your commits for tracking purposes.

Remember that the idea is to keep `master` untouched until we're ready to proceed with the change. Perhaps your change review board wants to review your change before `master` is updated. This is a good use case for Git branching. To create a new branch, and check it out (so that commits go to this new branch), run:

```
git checkout -b change-123
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

If you went through the previous section, `git checkout` will look familiar to you. In this case, we're using this command with the `-b` flag to simultaneously create and switch to a new branch entitled `change-123`. This means that not only does the branch exist, but any commits we make will be made on this branch.

> By the way, Git is full of shortcuts. As you continue in your Git journey, you'll notice that many commands in Git, like the one we just ran are just shortcuts for common workflows that might require 2 or more git commands to perform.

Let's say that for change #123, we want to change the IP address of em3 from `10.31.0.11` to `10.31.0.12`.
You can do this yourself using one of the provided text editors like `vi` or `nano`, or you can run the below `sed` command to do it in in a one-liner:

```
sed -i s/10.31.0.11/10.31.0.12/ interface-config.txt
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

As mentioned in the previous section, Git works on **changes** to files. The full, original contents of the file were added in a previous commit, but since we've made changes since then, those changes will show up in the outputs of `git status` and `git diff`:

```
git status
git diff
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Again, we must first add this change to staging, and make a commit with a descriptive commit message:

```
git add interface-config.txt
git commit -m "Changed IP address of em3"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

We can analyze the contents of this commit using the `git show` command. Remember from the last exercise that we used the commit ID provided in the output as a parameter for this command. However, if you omit any commit ID, it will automatically show you details for the latest commit in the checked out branch. This is commonly referred to as the `HEAD`.

```
git show
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

## Playing Catch-Up

As was mentioned previously, Git branching is a powerful tool to have when multiple work streams are going on simultaneously. Let's say Fred is also working on his own change ticket (#124) which changes the IP address of em4, in branch `change-124`. Let's say that the change review board likes Fred better than you so his change gets approved before yours. Since we haven't managed to run fast enough to capture fred and upload his brain into this lesson, we built a script to simulate this taking place. Run this script to merge Fred's change into the `master` branch:

```
/antidote/stage3/change-approval.sh > /dev/null 2>&1
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Now, that suck-up Fred's change is present on the `master` branch while you're still working in `change-123`. This means your branch is actually simultaneously **behind** and **ahead** of `master`, in that your branch has commits that `master` doesn't have, but the reverse is also true.

One cool trick is that we can actually use the `git diff` command to compare entire branches, not just files, changes or commits. By comparing the `change-123` branch (our currently checked-out branch) with `master`, we can see that not only is our change to `em3` shown, but also Fred's change to `em4`:

```
git diff master change-123
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Fortunately, this is fairly easy to remedy, and a fairly common occurrence. Imagine you're working on a project with many other people, with changes going into the `master` branch all the time. You may have to "catch up" your working branch many times over the course of a given work cycle.

The simplest and most common way to integrate these changes into your branch is via the `git merge` command. In short, this creates a commit which brings the contents of another branch into the one you have checked out. In this case, it brings the updates to the `master` branch that were created for change #124 into our branch so we can ensure we're working from the latest possible commit. This reduces the things we'll have to reason about when comparing our branch to `master`, and in some cases, prevent problems when we try to merge.

> You can also use a concept called ["rebasing"](https://git-scm.com/book/en/v2/Git-Branching-Rebasing) to catch your branch up with the lastest changes from another branch. However, this works very differently to a simple merge, and is often better used for other niche use cases where it's needed. We will cover rebasing in a future section. For now, stick with `git merge`.

```
git merge master change-123
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Now, re-running `git diff` should show that only our change is what's left between our branch and `master`.

```
git diff master change-123
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

## Merge Conflicts

- Make another commit on master that will cause a merge conflict.
- Try to merge your branch back into master, and resolve the merge conflict.
- Delete your branch. Note the -d flag will fail if there are unmerged commits. Either -D or merge your commits

## Conclusion



self explanatory - git branch/merge/checkout
