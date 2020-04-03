# Version Control with Git
## Part 1 - Your First Git Repository

Software developers have been using version control systems like Git to improve the way they manage changes to their code. Instead of just relying on the "undo" button, version control maintains a detailed history of every change to a file, so that you can roll back changes, maintain different versions, and more.

<div style="text-align:center;margin-top:30px;"><img src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/master/lessons/git-version-control/git.png" width="300px"></div>

However, there's **nothing** about Git or version control in general that requires you to be a software developer, or even that you manage code of any kind with it. At the end of the day, as long as you're managing some kind of text format, you should be using version control to record changes to it.

Incidentally, in the world of Network Reliability Engineering, not only do we have a need for using Git as a version control system for scripts or other kinds of code we might write for automation-related purposes, we can also use it to version-control things like YAML files, network configs, and more.

In this lesson, we'll learn the very basics of Git - enough to get you started using it in your network projects. Once you have a few of the commands in this lesson under your belt, there are a large number of resources on the internet that dive under the covers.

It's worth mentioning, it can take time to really become comfortable with Git. Git in particular emphasizes robustness and flexibility over ease-of-use, so if during this lesson or your day-to-day use of Git you feel overwhelmed or frustrated, know this is normal. Git is something you continually learn more about and add muscle memory for over time - not something anyone is expected to master in a few days.

In these exercises, we'll try to keep things as simple as possible, and focus on how to practically get started using Git. However, within these exercises, we'll also link frequently to [the Git book](https://git-scm.com/book/en/v2) which is available online for free, or in print form, which is a great resource to have when you want to dive deeper into a particular step of your Git workflow.

## Your First Repository

We refer to a group of directories and files managed by Git as a "repository" (or often, a "repo"). By now you may already know how to create a directory in your favorite Linux distribution, and navigate into it:

```
mkdir myfirstrepo/ && cd myfirstrepo/
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

However, our newly created `myfirstrepo` is just a regular directory. To initialize a Git repository within it, we need to run the `git init` command:

```
git init
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

## Configuring Git

Git is highly configurable, in many different ways. You can tell Git what editor you want to use to make commit messages, what email address to use when signing commits, and what key to sign your commits with, and much more. These options can be configured on both a repository-specific level, as well as globally to your user or even the entire system.

Canonically, the user-global configuration can be found within your user directory, in a file called `.gitconfig`:

```
cat ~/.gitconfig
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Oops! That file doesn't exist. This is because we haven't told Git anything about our desired configuration. So, let's do that.

A very common task to take on when setting up a system to use Git is to configure your name and email address. Not only does Git need to know who you are in order to make commits, most Git remotes (which we'll discuss later) like Github or Gitlab require you to sign your commits with an email address that is in your profile in order to attribute those commits to your username. And who wouldn't want credit for their work?

The `git config` command is used to both view the existing configuration, as well as set values. We can do this:

```
git config --global user.email "jane@nrelabs.io"
git config --global user.name "Jane Doe"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Git configurations are scoped, meaning that configuration options can be specified at one of three levels:

- **System** - configuration options for all repositories on the system
- **Global** - configuration options for all repositories for the current user
- **Local** - per-repository configuration options

Configuration options at the system level can be overridden by global options, and similarly, local options can override the previous two. So, if you have an option set in a local .gitconfig file, meaning one that is specific to a repository, then it takes precedence over a similar option defined globally or at a system level.

Since we specified `--global` in our commands above, these options were written to the global Git configuration, located at `~/.gitconfig`. Previously, this file didn't exist, but since we've bootstrapped it, it's now there, and contains our configuration options:

```
cat ~/.gitconfig
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>


We can use `--list` flag for this command to view the configuration, and by specifying `--global`, we can see what's effective at a global scope:

```
git config --list --global 
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Sometimes, however, you may want to configure a different email address or name for a specific repository. The good news is that the default scope, `--local`, does just this. And remember, "local" scope always takes precedence over broader scopes like "global". Since this is the default, we can re-run these commands without any flag, and it will automatically go in our local repo's configuration:

```
git config user.email "jim@nrelabs.io"
git config user.name "Jimmy Doe"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

These new `local` configuration options override the `global` ones - so this repository will now use our new email address and username, but all other repos will still use the global settings.

Note that you can easily see the full config by re-running with the `--list` flag, and by also using the `--show-origin` flag, we can see where Git saw each individual option. Note that we're omitting any scope flag, which means we're again defaulting to `--local`.

```
git config --list --show-origin 
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

We now have an initialized and configured Git repository, ready to track our files.

## Commands Reference

To summarize, the commands we learned in this section were:

- `git init` - initialize a new git repository
- `git config` - work with Git configuration options, both globally (with the `--global` flag) and locally in the current repository.
