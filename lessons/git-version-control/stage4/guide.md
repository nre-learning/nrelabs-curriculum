Git is a **distributed version control system**, which means it was designed so that each user can have their own copy of a repository. It also has some built-in tools for synchronizing different versions of a repository. In this lesson thus far, we haven't really made much use of these features, because we've really just been working with a local Git repository. 

These days, however, with the overwhelming popularity of platforms like Github, it's really not that common anymore to **just** work with Git locally. You're almost always working on a repository that is hosted by a service like Github, so while you're still working with a local copy of a repository, you need to be able to inform that central location of the changes you've made.

Enter the concept of Git "remotes". Defining a remote is a way of telling Git that there is another system out there with a copy of the repository that we're currently working with, and we wish to either push our changes to that remote, or pull some changes from that remote that we may not already have in our local copy.

One advantage of doing this is that remotes offer a sort of neutral "middle ground" where users all over the world can collaborate on the same repository.

<div style="text-align:center;margin-top:30px;"><img src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/git-stage-4-remotes/lessons/git-version-control/stage4/images/remotes.png"></div>

### Use Case 1 - Push your own repository

For our first exercise, we'll push the contents of the existing repository that we've been working with throughout this lesson to a new remote. For this, we'll use some software called "Gitea" which has a look and feel that is very similar to Github:

<button type="button" class="btn btn-primary btn-sm" onclick="switchToTab('remote')">Go to "remote"</button>

First, click the button in the top-right corner of this tab pane titled "Login". When prompted, enter the username `jane` and the password `Password1!`.

Once logged in, click the plus (`+`) icon in the top-right and select "New Repository" from the drop-down.

<div style="text-align:center;margin-top:30px;"><img src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/git-stage-4-remotes/lessons/git-version-control/stage4/images/newrepo.png"></div>

This will create a new repository within Gitea for us to push our local branch to. On the next screen, enter `myfirstrepo` into the box labeled "Repository Name", and then leave everything else blank and unchecked (this is important!). Scroll down to the bottom and click the green "Create Repository" button.

<div style="text-align:center;margin-top:30px;"><img src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/git-stage-4-remotes/lessons/git-version-control/stage4/images/repocreate.png"></div>

If you've done it correctly, you should see something like this:

<div style="text-align:center;margin-top:30px;"><img src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/git-stage-4-remotes/lessons/git-version-control/stage4/images/blankrepo.png"></div>

This means that Gitea has successfully created the repository, but as instructed, it didn't pre-populate it with any commits, so it's empty. This is a good thing, because we've already been making commits to our repository in the previous sections, so what we would prefer to do is simply push these.

You may notice that on the last screen there's a section titled "Pushing an existing repository from the command line".

### Contribute to someone else's repository