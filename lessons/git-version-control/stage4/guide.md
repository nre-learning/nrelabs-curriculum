Git is a **distributed version control system**, which means it was designed so that each user can have their own copy of a repository. It also has some built-in tools for synchronizing different versions of a repository. In this lesson thus far, we haven't really made much use of these features, because we've really just been working with a local Git repository. 

These days, however, with the overwhelming popularity of platforms like Github, it's really not that common anymore to **just** work with Git locally. You're almost always working on a repository that is hosted by a service like Github, so while you're still working with a local copy of a repository, you need to be able to inform that central location of the changes you've made.

Enter the concept of Git "remotes". Defining a remote is a way of telling Git that there is another system out there with a copy of the repository that we're currently working with, and we wish to either push our changes to that remote, or pull some changes from that remote that we may not already have in our local copy.

One advantage of doing this is that remotes offer a sort of neutral "middle ground" where users all over the world can collaborate on the same repository.

<div style="text-align:center;margin-top:30px;"><img class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/git-stage-4-remotes/lessons/git-version-control/stage4/images/remotes.png"></div>

A very popular choice for this is Github, which is a hosted Git service, and allows you to create internet-accessible Git repositories that anyone can contribute to or pull from.

It's useful to point out that everything we've talked about in this lesson thus far, including the concept of remotes in general, are core to Git itself. We will often refer to these as "Git fundamentals", meaning they apply to any software system or service like Github that is centered around Git. Services like Github, Gitlab, Bitbucket, Gitea, etc build on top of these fundamentals to add additional features to make it easier to collaborate on Git repositories. Things like Issues and Pull Requests are not built in to Git, but rather are features implemented by these services for the purposes of making Git a more collaborative experience on their platform.

<div style="text-align:center;margin-top:30px;"><img class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/git-stage-4-remotes/lessons/git-version-control/stage4/images/gitnotgithub.png"></div>

We'll be using a few of these features in this chapter - but it's important to remember that there is an important distinction between platform-agnostic "git fundamentals" like commits and branches, and platform-specific features like Issues and Pull Requests that may vary from platform to platform. They are complementary, but Git is not the same thing as Github.

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

Use your cursor to highlight the entire output - everything starting with and including `ssh-rsa` and  ending with and including `antidote@linux1`. Finally, press `Ctrl` and `Insert` at the same time to copy this to your clipboard.

Next, navigate over to Gitea:

<button type="button" class="btn btn-primary btn-sm" onclick="switchToTab('remote')">Go to "remote"</button>

First, click the button in the top-right corner of this tab pane titled "Login". When prompted, enter the username `jane` and the password `Password1!` and click "Sign In".

Once signed in, click the dropdown in the top-right corner and select "Settings":

<div style="text-align:center;margin-top:30px;"><img class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/git-stage-4-remotes/lessons/git-version-control/stage4/images/settings.png"></div>

On this screen, perform the steps listed and shown below:

1. Click "SSH/GPG Keys"
2. Click "Add Key" in the box titled "Manage SSH Keys"
3. Click inside the box titled "Content" that opens, and press `Ctrl`+`v` to paste the contents of your clipboard, which should still contain the public SSH key we copied earlier.
4. Click "Add Key"

<div style="text-align:center;margin-top:30px;"><img class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/git-stage-4-remotes/lessons/git-version-control/stage4/images/addkey.png"></div>

Once this is done, you should be ready to interact with Gitea via Git within the `linux1` tab as an authenticated user. The rest of this lesson won't work properly if you haven't done this, so make sure you've followed these instructions and you haven't seen any obvious errors before proceeding.

### Use Case 1 - Push Your Own Repository

For our first exercise, we'll push the contents of the existing repository that we've been working with throughout this lesson to a new remote.

Click the plus (`+`) icon in the top-right and select "New Repository" from the drop-down.

<div style="text-align:center;margin-top:30px;"><img class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/git-stage-4-remotes/lessons/git-version-control/stage4/images/newrepo.png"></div>

This will create a new repository within Gitea for us to push our local branch to. On the next screen, enter `myfirstrepo` into the box labeled "Repository Name", and then leave everything else blank and unchecked (this is important!). Scroll down to the bottom and click the green "Create Repository" button.

<div style="text-align:center;margin-top:30px;"><img class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/git-stage-4-remotes/lessons/git-version-control/stage4/images/repocreate.png"></div>

If you've done it correctly, you should see something like this:

<div style="text-align:center;margin-top:30px;"><img class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/git-stage-4-remotes/lessons/git-version-control/stage4/images/blankrepo.png"></div>

This means that Gitea has successfully created the repository, but as instructed, it didn't pre-populate it with any commits, so it's empty. This is a good thing, because we've already been making commits to our repository in the previous sections, so what we would prefer to do is simply push these.

You may notice that on the last screen there's a section titled "Pushing an existing repository from the command line". Since we already have commits of our own to push, this is the option we want. However, let's break these commands down a little bit.

As we covered earlier, a "remote" is a Git repository that's running on another computer. Git allows us to define these remotes by name first, and then gives us commands to interact with these remotes - either pulling commits from them, or pushing commits to them.

```
git remote add origin git@remote:jane/myfirstrepo.git
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Right now, our remote has exactly zero commits - we explicitly told Gitea when we created the repo to **not** initialize the repo with any commits, because doing so would cause problems when we try to push our own commits. So, what we need to do is "push" these commits to the remote. This is done by referencing the remote by name `origin`, as well as the branch we wish to push - in this case, `master`. 

```
git push -u origin master
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Note the output - the remote is telling us that we've created a new branch there, since `master` didn't exist on the remote side until we pushed from our side.

Next, go back to the `remote` tab and click on the "myfirstrepo" link at the top of the page to refresh, and then click on "commits" to view the graphical representation of the commits we've seen in previous sections:

<div style="text-align:center;margin-top:30px;"><img class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/git-stage-4-remotes/lessons/git-version-control/stage4/images/viewcommits.png"></div>

This is actually a very common exercise. You might start work on a project by just working with Git only, using a local repo on your machine. Later on you might decide to publish your work, and/or collaborate with others, and this workflow allows you to push what you already have to a service like Github.

### Use Case 2 - Contribute to Someone Else's Repository

The other big use case for working with Git remotes comes when you find an existing repository that belongs to someone else. Maybe this is a popular open source project, or maybe it's something as simple as a personal repository that belongs to a friend. In most cases, you 
