# Version Control with Git
## Part 3 - Parallelizing Your Work With Git Branches

As Git is a distributed version control system, it's often the case that you want to work in parallel with either other engineer, or even yourself, as you work on different aspects of a given repository. Imagine you have two change windows, one of which is more complicated but happens a few weeks away, and another which is tomorrow night but is fairly simple. If you have your configurations or scripts for these changes in a Git repository, it's likely that you'll have to work on both at the same time at some point, while making sure the two changes don't step on each other in the process.

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

> By the way, Git is full of shortcuts. As you continue in your Git journey, you'll notice that many commands in Git, like the one we just ran are just shortcuts for common workflows that might otherwise require 2 or more separate commands to perform.

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

As was mentioned previously, Git branching is a powerful tool to have when multiple work streams are going on simultaneously. Let's say Fred is also working on his own change ticket (#124) which changes the IP address of em4, in branch `change-124`. Let's say that the change review board likes Fred better than you so his change gets approved before yours. Since we haven't managed to run fast enough to capture Fred and upload his brain into this lesson, we built a script to simulate this taking place. Run this script to merge Fred's change into the `master` branch:

```
/antidote/stage3/change-approval.sh
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Now, Fred's change is present on the `master` branch while you're still working in `change-123`. This means your branch is actually simultaneously **behind** and **ahead** of `master`, in that your branch has commits that `master` doesn't have, but the reverse is also true.

One cool trick is that we can actually use the `git diff` command to compare entire branches, not just files, changes or commits. By comparing the `change-123` branch (our currently checked-out branch) with `master`, we can see that not only is our change to `em3` shown, but also Fred's change to `em4`:

```
git diff master change-123
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Fortunately, this is fairly easy to remedy, and a fairly common occurrence. Imagine you're working on a project with many other people, with changes going into the `master` branch all the time. You may have to "catch up" your working branch many times over the course of a given work cycle.

The simplest and most common way to integrate these changes into your branch is via the `git merge` command. In short, this creates a commit which brings the contents of another branch into the one you have checked out. In this case, it brings the updates to the `master` branch that were created for change #124 into our branch so we can ensure we're working from the latest possible commit. This reduces the things we'll have to reason about when comparing our branch to `master`, and in some cases, prevent problems when we try to merge.

> (You can also use a concept called ["rebasing"](https://git-scm.com/book/en/v2/Git-Branching-Rebasing) to catch your branch up with the latest changes from another branch. However, this works very differently to a simple merge, and is often better used for other niche use cases where it's needed. We will cover rebasing in a future section. For now, stick with `git merge`).

```
git merge master change-123 -m "Merge branch 'master' into change-123"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Now, re-running `git diff` should show that only our change is what's left between our branch and `master`.

```
git diff master change-123
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

## Merge Conflicts

Fred's at it again!

This time, not only is he making more changes, but he's making a change to **your** part of the configuration! On top of that, he convinced the change review board to merge his changes to `master`, even though it conflicted with your change!

Run this script to simulate his conflicting changes.

```
/antidote/stage3/bumbling-fred.sh
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Of course, you're busy working on your own change, so just like before, you see there are new commits on the `master` branch you don't have, so you catch-up your branch with `master` using `git merge`:

```
git merge master change-123 -m "Catch-up again"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

**Oh no!** This time, you see a problematic error message:

```
CONFLICT (content): Merge conflict in interface-config.txt
Automatic merge failed; fix conflicts and then commit the result.
```

In most cases, Git is smart enough to merge changes without issue. Since Fred was previously working on the em4 IP address, and we were working on em3's IP address, Git knew how to merge those changes together. However, since the last change Fred made was to the exact same line we changed, Git doesn't know which one should take precedence. Again, since we were working in two separate branches, this wasn't even a problem until we tried to merge, at which point Git throws up its hands and tells us we need to intervene to fix the problem. This is known commonly as a **merge conflict**.

The way to fix this is to open the file `interface-config.txt`, as Git will insert lines into that file to highlight what's wrong. Sometimes there are multiple conflicts in a single file, but in this case, there's just one. It looks like this:

```
<<<<<<< HEAD
                address 10.31.0.12/24;
=======
                address 123.123.123.123/24;
>>>>>>> master
```

The anatomy is simple - there are two distinct sections we must choose from. Everything between the first set of arrows (`<<<<<<< HEAD`) and the line of equal signs (`=======`) is the valid change we've been working on. We know this because it's titled `HEAD`, which is currently pointing at our branch. Everything after the equal signs up to the second line of arrows (`>>>>>>> master`) is what we're trying to merge into our branch, in this case, the changes Fred made in `master`.

Resolving conflicts like this are first and foremost a text editing process. We literally need to edit the text shown above so that we are left with only the text we want in this file. This means removing all of the lines that Git inserted, as well as the actual contents of the change we want to discard. Note that this choice is entirely up to you. You could choose to keep both changes, none of them, or even make an additional change to truly resolve the problem. It is entirely up to the context of the conflict. In this case, however, we want to totally get rid of Fred's change.

You can edit this file with `nano` (don't forget to save by pressing Ctrl+`x`, `y`, and then "Enter"), or, you can run this handy bash-foo for doing it in a one-liner. Note this is only for simplicity in this lesson - you'll definitely want to get comfortable with making these changes in your own text editor:

```
grep -Ev "<<<<<<<|=======|>>>>>>>|123\.123\.123\.123" interface-config.txt > temp && mv -f temp interface-config.txt
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

We've changed the contents of the conflicting file, but we still have a little more work to do. We need to tell Git that we've resolved the problem, and this is done with a new commit which resolves the conflict. Note the output of `git status`:

```
git status
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Git is telling us that it still sees an unresolved state, so we need to run a new `git add` and `git commit` to tell Git that the current state of the file, with our manual fixes, resolves the conflict:

```
git add interface-config.txt
git commit -s -m "Resolve merge conflict, overwrite Fred's change"
```

## The Final Merge

It's time to merge our work into `master`. In practice, this is done typically by senior members of the team with "commit privileges". It's not uncommon to have a code review system like Gerrit, Github etc (which we'll discuss later) where only certain members of the team have permissions to actually make commits (including merge commits) to `master`, so that only approved changes get through to `master`. This is obviously totally dependent on the team structure and the Git workflow that works for your organization. For now, let's pretend we're a senior member of the team and we're merging the contents of `change-123`.

First, we want to check out the `master` branch:

```
git checkout master
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Then, merging is simple, using the same `git merge` command we know and love. Since we have `master` checked out, the command for merging `change-123` just references that branch by name:

```
git merge change-123 -m "Merging change 123 into master"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Note that during any merge operation, there may be merge conflicts like we dealt with before. In this case, we chose to deal with conflicts in `change-123` ahead of time, so that when we merged those changes back to `master`, no conflicts remain. It's fairly common to do it this way, so that merges to `master` can be done cleanly.

Since all of the commits from `change-123` are fully merged into `master`, we don't need that branch anymore, and can delete it like so:

```
git branch -d change-123
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

The `-d` flag tells Git to delete the branch only if everything is fully merged. If there are unmerged commits, then Git would throw an error. We can forcefully delete a branch (unmerged commits or not) with the capitalized `-D` flag.

## Conclusion

To summarize, the commands we learned in this section were:

- `git checkout` - check out a branch (or with the `-b` flag, create it first)
- `git merge` - bring the commits from another branch into the currently checked-out branch
- `git branch` - work with Git branches, such as creating, viewing, or deleting them.

We also learned how to resolve merge conflicts, which can arise when two branches make conflicting changes and we try to merge them together.

Stay tuned for more!
