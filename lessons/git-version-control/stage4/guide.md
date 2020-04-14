Git is a **distributed version control system**, which means it was designed so that each user can have their own copy of a repository. It also has some built-in tools for synchronizing different versions of a repository. In this lesson thus far, we haven't really made much use of these features, because we've really just been working with a local Git repository. 

These days, however, with the overwhelming popularity of platforms like Github, it's really not that common anymore to **just** work with Git locally. You're almost always working on a repository that is hosted by a service like Github, so while you're still working with a local copy of a repository, you need to be able to inform that central location of the changes you've made.

Enter the concept of Git "remotes". Defining a remote is a way of telling Git that there is another system out there with a copy of the repository that we're currently working with, and we wish to either push our changes to that remote, or pull some changes from that remote that we may not already have in our local copy.

One advantage of doing this is that remotes offer a sort of neutral "middle ground" where users all over the world can collaborate on the same repository.

<div style="text-align:center;margin-top:30px;"><img style="max-width: 70%;" class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/v1.2.0/lessons/git-version-control/stage4/images/remotes.png"></div>

A very popular choice for this is Github, which is a hosted Git service, and allows you to create internet-accessible Git repositories that anyone can contribute to or pull from.

It's useful to point out that everything we've talked about in this lesson thus far, including the concept of remotes in general, are core to Git itself. We will often refer to these as "Git fundamentals", meaning they are the core features and tools within Git itself, and work the same way on any platform. Services like Github, Gitlab, Bitbucket, or Gitea build on top of these fundamentals by adding additional features for collaborating on Git repositories. Things like Issues and Pull Requests are not built in to Git, but rather are features implemented by these services for the purposes of making Git a more collaborative experience on their platform.

We'll be using a few of these features in this chapter - but it's important to remember that there is an important distinction between platform-agnostic "git fundamentals" like commits and branches, and platform-specific features like Issues and Pull Requests that may vary from platform to platform. They are complementary, but Git is not the same thing as Github.

<div style="text-align:center;margin-top:30px;"><img style="max-width: 70%;" class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/v1.2.0/lessons/git-version-control/stage4/images/gitnotgithub.png"></div>

In your journey, you're likely to run into two main use cases for using Git remotes:

- Pushing commits from your local repository to your own remote repository
- Collaborating on another repository that you do not own.

We'll address both below.  For this lesson we'll be using an open source Github alternative called "Gitea", located in the `remote` tab, which will provide us with the ability to provision and work with remote Git repositories. Gitea has a look and feel that is very similar to Github, and much of what you're about to learn can be applied almost exactly to Github. 

### First Step - Authentication

Some operations with git remotes can be done unauthenticated, but for all popular platforms like Github these days, you won't be able to avoid eventually having to authenticate as a user. This way, the remote software knows whether or not you have the right to push or pull commits.

For most Git-based services, you'll see that you can use HTTP or SSH as a transport protocol for Git. While HTTP can be more convenient especially for anonymous read-only operations, SSH is far more secure, and is often the only option you can use if you wish to enable two-factor authentication on your account, which is a really good idea. So, we'll be ignoring the HTTP option in this lesson and instead authenticating via SSH.

First, we need to generate an SSH key:

```
ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ""
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

The previous command generated a private and public key. To authenticate to Gitea, we'll need to provide our public key, so let's print that out now:

```
cat ~/.ssh/id_rsa.pub
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Use your cursor to highlight the entire output - everything starting with and including `ssh-rsa` and  ending with and including `antidote@linux1`. Do not include the final `antidote@linux1:~$` on the next line, as that is our bash prompt. Finally, press `Ctrl` and `Insert` at the same time to copy this to your clipboard.

Next, navigate over to Gitea:

<button type="button" class="btn btn-primary btn-sm" onclick="switchToTab('remote')">Go to "remote"</button>

First, click the button in the top-right corner of this tab pane titled "Sign In". When prompted, enter the username `jane` and the password `Password1!` and click "Sign In".

Once signed in, click the dropdown in the top-right corner and select "Settings":

<div style="text-align:center;margin-top:30px;"><img style="max-width: 70%;" class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/v1.2.0/lessons/git-version-control/stage4/images/settings.png"></div>

On this screen, perform the steps listed and shown below:

1. Click "SSH/GPG Keys"
2. Click "Add Key" in the box titled "Manage SSH Keys"
3. Click inside the box titled "Content" that opens, and press `Ctrl`+`v` to paste the contents of your clipboard, which should still contain the public SSH key we copied earlier.
4. Click "Add Key"

<div style="text-align:center;margin-top:30px;"><img style="max-width: 70%;" class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/v1.2.0/lessons/git-version-control/stage4/images/addkey.png"></div>

Once this is done, you should be ready to interact with Gitea via Git within the `linux1` tab as an authenticated user. The rest of this lesson won't work properly if you haven't done this, so make sure you've followed these instructions and you haven't seen any obvious errors before proceeding.

The specific steps may differ, but this is very similar to what you'd have to do with a hosted service like Github in order to push to a repository.

### Use Case 1 - Push Your Own Repository

For our first exercise, we'll push the contents of the existing repository that we've been working with throughout this lesson to a new remote.

Click the plus (`+`) icon in the top-right and select "New Repository" from the drop-down.

<div style="text-align:center;margin-top:30px;"><img style="max-width: 70%;" class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/v1.2.0/lessons/git-version-control/stage4/images/newrepo.png"></div>

This will create a new repository within Gitea for us to push our local branch to. On the next screen, enter `myfirstrepo` into the box labeled "Repository Name", and then leave everything else blank and unchecked (this is important!). Scroll down to the bottom and click the green "Create Repository" button.

<div style="text-align:center;margin-top:30px;"><img style="max-width: 70%;" class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/v1.2.0/lessons/git-version-control/stage4/images/repocreate.png"></div>

If you've done it correctly, you should see something like this:

<div style="text-align:center;margin-top:30px;"><img style="max-width: 70%;" class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/v1.2.0/lessons/git-version-control/stage4/images/blankrepo.png"></div>

This means that Gitea has successfully created the repository, but as instructed, it didn't pre-populate it with any commits, so it's empty. This is a good thing, because we've already been making commits to our repository in the previous sections, so what we would prefer to do is simply push these.

You may notice that on the last screen there's a section titled "Pushing an existing repository from the command line". Since we already have commits of our own to push, this is the option we want. However, let's break these commands down a little bit.

As we covered earlier, a "remote" is a Git repository that's running on another computer. Git allows us to define these remotes by name first, and then gives us commands to interact with these remotes - either pulling commits from them, or pushing commits to them.

The first command that Gitea wants us to run (`git remote add`) defines a new remote with the name of `origin`, and stores this in the local repository configuration `.git/config`. The name `origin` is a common convention for the name of a Git remote, but not a strict requirement. The final parameter for this command is the location for this remote - in this case, we're using the hostname `remote` to indicate the system we want to connect to, and then `jane/myfirstrepo.git` to specify the path to the repository.

Enter the `myfirstrepo` repository that we've been working with, and run this command to set up the remote:

```
cd ~/myfirstrepo
git remote add origin git@remote:jane/myfirstrepo.git
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Right now, the remote repository has exactly zero commits - we explicitly told Gitea when we created the repo to **not** initialize the repo with any commits, because doing so would cause problems when we try to push our own commits. So, what we need to do is "push" these commits to the remote. This is done by referencing the remote by name `origin`, as well as the branch we wish to push - in this case, `master`. 

```
git push -u origin master
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Note the output - the remote is telling us that we've created a new branch there, since `master` didn't exist on the remote side until we pushed from our side.

Next, go back to the `remote` tab and click on the "myfirstrepo" link at the top of the page to refresh, and then click on "commits" to view the graphical representation of the commits we've seen in previous sections:

<button type="button" class="btn btn-primary btn-sm" onclick="switchToTab('remote')">Go to "remote"</button>

<div style="text-align:center;margin-top:30px;"><img style="max-width: 70%;" class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/v1.2.0/lessons/git-version-control/stage4/images/viewcommits.png"></div>

This is actually a very common exercise. You might start work on a project by just working with Git only, using a local repo on your machine. Later on you might decide to publish your work, and/or collaborate with others, and this workflow allows you to push what you already have to a service like Github.

### Use Case 2 - Contribute to Someone Else's Repository

(This section runs a little long, so you may want to refresh the page here to ensure your lab environment stays active)

The other big use case for working with Git remotes comes when you find an existing repository that belongs to someone else. Maybe this is a popular open source project, or maybe it's something as simple as a personal repository that belongs to a friend. In most cases, you don't have "write access" to these repositories - that is, you are not able to simply push a branch of commits directly to the repository.

Instead, a "Fork and Pull" workflow is used, which goes something like this:

1. Create a "fork" of the upstream repository you want to contribute to, which is a fancy way of saying "creating your own copy of it"
2. Push changes to a new branch in your forked repository. It's your copy, so this works just fine.
3. Submit a "pull request" to the original, upstream project you forked from that says "please pull these changes from my repository back into yours".

**Clarification on "Forking"** - you may have heard in the past that "forking" in the world of open source is a bad thing. In this case, you likely heard this in reference to "hard forking", which is to take an existing project, and go in a different direction with it, without intending on bringing any changes back to the original project. There are some good reasons for doing this, but it does carry a bit of a negative connotation regardless. In any case, this is not what we're doing here for the "Fork and Pull" workflow; we are doing what's commonly referred to as a "soft fork". Our intention is to eventually bring these changes back into the upstream repository via a Pull Request. Our fork is a place holder for us to more easily push commits before they are pulled back into the upstream repository. This is a very common workflow for platforms like Github so that maintainers can carefully control the quality of what gets integrated into a repository. In fact, this is exactly how the <a target="_blank" href="https://github.com/nre-learning/nrelabs-curriculum">NRE Labs curriculum itself</a> is maintained!

For this example, we want to take a look at a repository that already exists. Head back over to the `remote` tab:

<button type="button" class="btn btn-primary btn-sm" onclick="switchToTab('remote')">Go to "remote"</button>

Click "Explore" at the top of the page. You'll see the repository we created in the previous exercise, but you'll also see one we haven't explored yet:

<div style="text-align:center;margin-top:30px;"><img style="max-width: 70%;" class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/v1.2.0/lessons/git-version-control/stage4/images/repositories.png"></div>

Click the link to `initech/network-configs`:

<div style="text-align:center;margin-top:30px;"><img style="max-width: 70%;" class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/v1.2.0/lessons/git-version-control/stage4/images/initechrepo.png"></div>

Let's say we want to change the autonomous system number in one of Initech's network configuration files. The difference here is that not only to we need to make a change to a remote repository, the `initech/network-configs` repository doesn't even belong to us; we are not permitted to simply push commits directly to the repository. This is where the "Fork and Pull" workflow comes in handy.

Click the "fork" button in the top right of the `initech/network-configs` repository. This will bring up a form:

<div style="text-align:center;margin-top:30px;"><img style="max-width: 70%;" class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/v1.2.0/lessons/git-version-control/stage4/images/newfork.png"></div>

Just accept the defaults here, and click "Fork Repository". This will result in the following screen:

<div style="text-align:center;margin-top:30px;"><img style="max-width: 70%;" class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/v1.2.0/lessons/git-version-control/stage4/images/janefork.png"></div>

This is our new forked repository - a copy of the original repository that we are able to push directly to. Now that we have this, we can use a new command - `git clone`. This command downloads a remote repository to our local machine. Let's first navigate back to our home directory, so we don't accidentally clone this repository inside the one from the previous exercise.

```
cd ~
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Keeping it simple, we can append a single parameter to `git clone` which is the location of the repository we wish to clone from. Note that the username is `jane`, indicating that we're cloning our fork, not the upstream repository itself. You should also note that this location is provided to us on the main screen for our fork, shown in the previous screenshot.

```
git clone git@remote:jane/network-configs.git
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

We now have a local repository where we can use all of the git fundamentals we've been learning thus far. Enter this directory and take a look at the commit history:

```
cd network-configs/
git log
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

When we clone a repository, Git is smart enough to automatically add a remote called `origin` that points to the original clone location. You can list all configured remotes for this repository with:

```
git remote -v
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Even though we're working on a forked repository, it's always a good idea to still create a new branch to do some work, rather than pushing commits directly to our `master` branch. It's not uncommon to be working on multiple pull requests to the same repository, and having different branches on your side of things helps allow this.

```
git checkout -b change-as-number
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Even if you want your work to be merged to the `master` branch of the upstream repository, this will still work. All popular platforms like Github are perfectly capable of merging from a non-standard branch in your repository into the `master` branch on the upstream repository.

For this change, we'll just change the configured autonomous system number for the `vqfx1.txt` file in this repository. This is just an example though - feel free to make any change you want using `nano` or `vim`:

```
sed -i s/64001/64010/ vqfx1.txt
git diff
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

You know the drill by now - add this change and commit it:

```
git add vqfx1.txt
git commit -s -m "Updated autonomous system number for vqfx1"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

This makes the change in our local repository, but we now want to push the new `change-as-number` branch to our remote repository:

```
git push origin change-as-number
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Now that we have a branch pushed to our fork, our forked repository is different from the original `initech` repository. Note that we don't **have** to open a pull request now - we could continue to push to this branch until we're ready. Some projects prefer this, in fact. Other projects don't mind, and in some cases actually encourage contributors to open a Pull Request as soon as possible, marking it "Draft" or "WIP" until you're ready, so maintainers know you're working on it. Take some time to get familiar with the etiquette of the project you want to contribute to.

It should also be noted that even after opening a Pull Request, it's super common to continue to push changes to the same branch. Often, maintainers will leave review comments on your Pull Request that ask for additional changes, and you'll need to continue to push changes to your own branch until they're comfortable.

In our case, we'll open a Pull Request now. Switch back to the `remote` tab:

<button type="button" class="btn btn-primary btn-sm" onclick="switchToTab('remote')">Go to "remote"</button>

If you're not already there, navigate back to our fork via the "Explore" link on the top of the screen. On this page, you'll notice there's a button in the middle that says "New Pull Request":

<div style="text-align:center;margin-top:30px;"><img style="max-width: 70%;" class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/v1.2.0/lessons/git-version-control/stage4/images/janefork-newpr.png"></div>

Select that, and you'll be presented with the option to select the branches you wish to compare. Make sure they're set like the screenshot below - you want be comparing `initech:master` with `jane:change-as-number`:

<div style="text-align:center;margin-top:30px;"><img style="max-width: 70%;" class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/v1.2.0/lessons/git-version-control/stage4/images/newpr1.png"></div>

Click the green "New Pull Request" button, and you'll be presented with a form:

<div style="text-align:center;margin-top:30px;"><img style="max-width: 70%;" class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/v1.2.0/lessons/git-version-control/stage4/images/newpr2.png"></div>

The title and description on this screen is up to you - and is likely to be another thing that will depend on the project that you are contributing to. Different projects require different information in these fields. For now, just click the green "Create Pull Request" button. If you've done this correctly, you'll see something like this:

<div style="text-align:center;margin-top:30px;"><img style="max-width: 70%;" class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/v1.2.0/lessons/git-version-control/stage4/images/propened.png"></div>

At this point, the PR is open, and conversation can take place within this page. You might get comments from a reviewer, asking for additional changes, in which case you can add commits to your local branch and re-run `git push`, and the PR will automatically be updated. This process continues until the PR is either closed or merged back into the upstream repository.

## BONUS - How to stay up to date with upstream changes?

Once again, Git is a distributed version control system, which means we **have** to expect that changes can and will happen all the time, and we have to be ready to incorporate these changes.

Even though we've opened a Pull Request, the upstream project isn't going to wait for us. Keep in mind that some open source projects have thousands of contributors, with changes being merged all the time. It's actually quite common that shortly after opening a pull request, the upstream project continues to change, and sometimes these changes need to be brought back into our fork, so we can ensure we're working on the latest copy. However, our fork doesn't automatically update itself - this is something we have to do ourselves.

Git actually allows us to configure multiple remotes in a given repository. Even though we cloned the `network-configs` repository from our fork (which is currently set to the remote named `origin`), we can add a second one for the purposes of pulling down changes from the upstream `initech` repository. This can be done using the same syntax we saw earlier - but note the name `upstream` so it's obvious where this remote comes from:

```
git remote add upstream git@remote:initech/network-configs.git
git remote -v
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Then, we can check out our local `master` branch, and run the `git pull` command to ensure that it is in sync with the upstream's `master` branch:

```
git checkout master
git pull upstream master
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Now that our local `master` branch is updated, we still have to update the branch where we're working on our pull request. This is the same exercise we saw in the previous chapter on Git branches; use `git merge` to catch up our local branch, and then use `git push` to also catch up the remote copy of this branch on our fork (pay close attention to the use of `upstream` vs `origin`).

```
git checkout change-as-number
git merge master change-as-number
git push origin change-as-number
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

The initial step of adding the `upstream` remote should only be done once, but the remaining commands can be done repeatedly whenever you need to get your pull request updated with the latest commits from the upstream repository's `master` branch. Doing so helps to ensure your pull request can eventually get merged without problems.

