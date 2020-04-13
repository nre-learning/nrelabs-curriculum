Git is a **distributed version control system**, which means it was designed so that each user can have their own copy of a repository. It also has some built-in tools for synchronizing different versions of a repository. In this lesson thus far, we haven't really made much use of these features, because we've really just been working with a local Git repository. 

These days, however, with the overwhelming popularity of platforms like Github, it's really not that common anymore to **just** work with Git locally. You're almost always working on a repository that is hosted by a service like Github, so while you're still working with a local copy of a repository, you need to be able to inform that central location of the changes you've made.

Enter the concept of Git "remotes". Defining a remote is a way of telling Git that there is another system out there with a copy of the repository that we're currently working with, and we wish to either push our changes to that remote, or pull some changes from that remote that we may not already have in our local copy.

One advantage of doing this is that remotes offer a sort of neutral "middle ground" where users all over the world can collaborate on the same repository.

<div class="full" style="text-align:center;margin-top:30px;"><img src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/git-stage-4-remotes/lessons/git-version-control/stage4/images/remotes.png"></div>

A very popular choice for this is Github, which is a hosted Git service, and allows you to create internet-accessible Git repositories that anyone can contribute to or pull from.

It's useful to point out that everything we've talked about in this lesson thus far, including the concept of remotes in general, are core to Git itself. We will often refer to these as "Git fundamentals", meaning they apply to any software system or service like Github that is centered around Git. Services like Github, Gitlab, Bitbucket, Gitea, etc build on top of these fundamentals to add additional features to make it easier to collaborate on Git repositories. Things like Issues and Pull Requests are not built in to Git, but rather are features implemented by these services for the purposes of making Git a more collaborative experience on their platform.

<div class="full" style="text-align:center;margin-top:30px;"><img src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/git-stage-4-remotes/lessons/git-version-control/stage4/images/gitnotgithub.png"></div>

We'll be using a few of these features in this chapter - but it's important to remember that there is an important distinction between platform-agnostic "git fundamentals" like commits and branches, and platform-specific features like Issues and Pull Requests that may vary from platform to platform. They are complementary, but Git is not the same thing as Github.

In your journey, you're likely to run into two main use cases for using Git remotes:

- Pushing commits from your local repository to your own remote repository
- Collaborating on another repository that you do not own.

We'll address both below.

### Prep Work

Some operations with git remotes can be done unauthenticated, but for all popular platforms like Github these days, you won't be able to avoid eventually having to authenticate as a user. This way, the remote software knows whether or not you have the right to push or pull commits.

You can do HTTP or SSH based auth. SSH authentication is not only more secure, but also works for systems that do 2FA

```
ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ""
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>


### Use Case 1 - Push your own repository

For our first exercise, we'll push the contents of the existing repository that we've been working with throughout this lesson to a new remote. For this, we'll use some software called "Gitea" which has a look and feel that is very similar to Github:

<button type="button" class="btn btn-primary btn-sm" onclick="switchToTab('gitea')">Go to "remote"</button>

First, click the button in the top-right corner of this tab pane titled "Login". When prompted, enter the username `jane` and the password `Password1!`.

Once logged in, click the plus (`+`) icon in the top-right and select "New Repository" from the drop-down.

<div class="full" style="text-align:center;margin-top:30px;"><img src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/git-stage-4-remotes/lessons/git-version-control/stage4/images/newrepo.png"></div>

This will create a new repository within Gitea for us to push our local branch to. On the next screen, enter `myfirstrepo` into the box labeled "Repository Name", and then leave everything else blank and unchecked (this is important!). Scroll down to the bottom and click the green "Create Repository" button.

<div class="full" style="text-align:center;margin-top:30px;"><img src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/git-stage-4-remotes/lessons/git-version-control/stage4/images/repocreate.png"></div>

If you've done it correctly, you should see something like this:

<div class="full" style="text-align:center;margin-top:30px;"><img src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/git-stage-4-remotes/lessons/git-version-control/stage4/images/blankrepo.png"></div>

This means that Gitea has successfully created the repository, but as instructed, it didn't pre-populate it with any commits, so it's empty. This is a good thing, because we've already been making commits to our repository in the previous sections, so what we would prefer to do is simply push these.

You may notice that on the last screen there's a section titled "Pushing an existing repository from the command line".

### Contribute to someone else's repository