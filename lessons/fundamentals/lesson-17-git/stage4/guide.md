# Version Control with Git
## Part 4 - Oops! I Made A Mistake!

None of us are perfect, and we all make mistakes. The robustness and complexity of a tool like Git has a way of highlighting this truth. You've probably heard stories of people committing things like passwords or Slack tokens to a GitHub repository. The reality is that when you get into the groove with Git, it can be really easy to commit more than you intended.

What's worse is that if you've committed sensitive information to a Git repository, simply adding another commit to remove the information isn't enough. Anyone can still plainly see the information in the Git history, even though it's been removed in a more recent commit. What we actually need to be able to do is go back in time and **actually** undo the change itself.

In this part of the lesson, we'll focus just on this problem; once you've committed a change you didn't intend, what can you do about it? 

### Changing the Past

Let's make a new change - say, adding a new hostname configuration file to our repository:

```
cd ~/myfirstrepo/
cat <<EOT >> hostname-config.txt
system {
  host-name vqfx1;
}
EOT

```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

We're pretty confident that we know what we're doing, and besides, we're in a hurry to get home to binge Tiger King. Let's just use a wildcard to `git add` everything and make a quick commit.

```
git add *
git commit -s -m "Added new hostname configuration"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

And this is when we get that sick feeling in our stomach. The output we get from our commit indicates there was more in the commit payload than we intended:

```
[master d3e5b0f] Added new hostname configuration
 2 files changed, 4 insertions(+)
 create mode 100644 credentials.txt
 create mode 100644 hostname-config.txt
```

We can see via `git show HEAD` that the last commit included not only the change we made, but also a file that happened to be in the directory at the time, which houses sensitive credentials:

```
git show HEAD
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

When we ran `git add *` we added EVERYTHING that wasn't already ignored by a `.gitignore` configuration into staging. And then when we ran `git commit`, all of those changes were committed. It is for this reason it is often a very good idea to either add files or directories individually when you know that all of the changes involved are what you want. Using wildcards, or adding files while making a commit are surefire ways to include more than you intended. However, what's done is done, and we need to undo this. Enter the `git reset` command.

**WARNING** - this is not a tool to wield without extreme care. One of the advantages of Git or version control in general is that even if you make mistakes, the history is still there for you to find your way back to a working state. In this case, we're about to **erase** that same history that previously kept us safe. This is a good thing when we're trying to actually erase sensitive information, but can also come back to bite us if we use it incorrectly.

The `git reset` flag is generally used with one of two flags to indicate the type of reset you wish to perform. The safer option, and the one we want to use now, is the `--soft` flag. This instructs git to undo all commits back to the one we specify, and take all of the contents of those commits and place them into staging. This allows us to modify staging, and typically make a new commit.

Note that we can specify commits as a relative offset of `HEAD` - in this case `HEAD~1` is the commit before the most recent one. Let's specify this as a parameter for a soft reset:

```
git reset --soft HEAD~1
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Now, if we run `git status`, we see the contents of the commit that we reversed in staging:

```
git status
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Finally, we can also use `git reset` with the name of the file as a parameter to remove that file from staging. 

```
git reset credentials.txt
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Don't forget to add that file to `.gitignore` so this doesn't happen again! In our case, we also need to add the `.gitignore` file itself. This is a good idea - so that everyone that uses this repository can also be protected against this problem.

```
echo "credentials.txt" >> .gitignore
git add .gitignore
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Now that staging is the way we **actually** expect (we'll still check with `git status`), we can finally commit our changes.

```
git status
git commit -s -m "Adding hostname config that my stupid boss wanted"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

### Amending a Commit

You can also amend commits that you've already made. This is possible for any commit, but far easier for the most recent commit. Popular use cases for this include changing the commit messages or adding some additional files.

In our case, we "accidentially" insulted our superior in a commit message, and before we get caught, we want to amend the commit to include a new message.

```
git commit --amend -s -m "Adding hostname config"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

### Changing the Past

Finally, it may come to pass that you just need to blow a commit away. Let's say your boss told you that our super secret hostname configuration shouldn't be committed to the repository either, and we need to undo any record of that commit as a whole. In this case, there's nothing we want to keep in the most recent commit - we just want it gone.

**ANOTHER WARNING** - the `--hard` flag has bitten many Git users before. Its sole purpose is to literally undo commits and their contents like it never happened. Use this **only** when you're sure that you are removing only that which you are okay parting with.

Again, the `HEAD~1` usage allows us to back-track to the commit prior to the most recent one, effectively wiping it out.

```
git reset --hard
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

And with that, we're back to the state we were in to begin with:

```
git status
git log --oneline
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>


### Tips for Using `git reset` when working with Remotes

We haven't covered remotes yet (which we will in the next part of this lesson) but there are some implications to using `git reset` when collaborating with others using a platform like GitHub or GitLab. Keep in mind that you're effectively changing history, and removing commits that others may be relying upon.

For instance, if you've pushed a bunch of commits that contain sensitive information, and then a day later decide to undo those commits, it's possible that others have made their own commits on top of that information. If you undo them, and push your branch, you risk causing some serious problems for those that have already incorporated those commits into their ancestry.

We'll explore this in more detail in the next part of this lesson, but suffice it to say for now that making changes using `git reset` is best done within the safety of a local branch and repo, which is what we've focused on in this lesson. Once you've pushed those changes to another machine, it opens up a whole can of worms.
