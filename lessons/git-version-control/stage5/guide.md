
The other big use case for working with Git remotes comes when you find an existing repository that belongs to someone else. Maybe this is a popular open source project, or maybe it's something as simple as a personal repository that belongs to a friend. In most cases, you don't have "write access" to these repositories - that is, you are not able to simply push a branch of commits directly to the repository.

Instead, a "Fork and Pull" workflow is used, which goes something like this:

1. Create a "fork" of the upstream repository you want to contribute to, which is a fancy way of saying "creating your own copy of it"
2. Push changes to a new branch in your forked repository. It's your copy, so this works just fine.
3. Submit a "pull request" to the original, upstream project you forked from that says "please pull these changes from my repository back into yours".

**Clarification on "Forking"** - you may have heard in the past that "forking" in the world of open source is a bad thing. In this case, you likely heard this in reference to "hard forking", which is to take an existing project, and go in a different direction with it, without intending on bringing any changes back to the original project. There are some good reasons for doing this, but it does carry a bit of a negative connotation regardless. In any case, this is not what we're doing here for the "Fork and Pull" workflow; we are doing what's commonly referred to as a "soft fork". Our intention is to eventually bring these changes back into the upstream repository via a Pull Request. Our fork is a place holder for us to more easily push commits before they are pulled back into the upstream repository. This is a very common workflow for platforms like Github so that maintainers can carefully control the quality of what gets integrated into a repository. In fact, this is exactly how the <a target="_blank" href="https://github.com/nre-learning/nrelabs-curriculum">NRE Labs curriculum itself</a> is maintained!

For this example, we want to take a look at a repository that already exists. Head back over to the `remote` tab:

<button type="button" class="btn btn-primary btn-sm" onclick="switchToTab('remote')">Go to "remote"</button>

Click "Explore" at the top of the page. You'll see the repository we created in the previous exercise, but you'll also see one we haven't explored yet:

<div style="text-align:center;margin-top:30px;"><img style="max-width: 70%;" class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/git-stage-5/lessons/git-version-control/stage5/images/repositories.png"></div>

Click the link to `initech/network-configs`:

<div style="text-align:center;margin-top:30px;"><img style="max-width: 70%;" class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/git-stage-5/lessons/git-version-control/stage5/images/initechrepo.png"></div>

Let's say we want to change the autonomous system number in one of Initech's network configuration files. The difference here is that not only to we need to make a change to a remote repository, the `initech/network-configs` repository doesn't even belong to us; we are not permitted to simply push commits directly to the repository. This is where the "Fork and Pull" workflow comes in handy.

Click the "fork" button in the top right of the `initech/network-configs` repository. This will bring up a form:

<div style="text-align:center;margin-top:30px;"><img style="max-width: 70%;" class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/git-stage-5/lessons/git-version-control/stage5/images/newfork.png"></div>

Just accept the defaults here, and click "Fork Repository". This will result in the following screen:

<div style="text-align:center;margin-top:30px;"><img style="max-width: 70%;" class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/git-stage-5/lessons/git-version-control/stage5/images/janefork.png"></div>

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

<div style="text-align:center;margin-top:30px;"><img style="max-width: 70%;" class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/git-stage-5/lessons/git-version-control/stage5/images/janefork-newpr.png"></div>

Select that, and you'll be presented with the option to select the branches you wish to compare. Make sure they're set like the screenshot below - you want be comparing `initech:master` with `jane:change-as-number`:

<div style="text-align:center;margin-top:30px;"><img style="max-width: 70%;" class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/git-stage-5/lessons/git-version-control/stage5/images/newpr1.png"></div>

Click the green "New Pull Request" button, and you'll be presented with a form:

<div style="text-align:center;margin-top:30px;"><img style="max-width: 70%;" class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/git-stage-5/lessons/git-version-control/stage5/images/newpr2.png"></div>

The title and description on this screen is up to you - and is likely to be another thing that will depend on the project that you are contributing to. Different projects require different information in these fields. For now, just click the green "Create Pull Request" button. If you've done this correctly, you'll see something like this:

<div style="text-align:center;margin-top:30px;"><img style="max-width: 70%;" class="full" src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/git-stage-5/lessons/git-version-control/stage5/images/propened.png"></div>

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

