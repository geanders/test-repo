Git Cheat Sheet
===============

NOTE: For all commands, I've just talked about the simplest things they do in the context of a very basic way of working with git and GitHub. There are loads of other options for all of these, but I would suggest starting with these very basic uses.

# Commands to get something new going

To link up a directory so that (1) you can track all the changes to files in the directory on your own computer using git and (2) you can keep an up-to-date version of everything in a GitHub repository, you'll need to do some setting up. I usually find this is the hardest part of using git and GitHub, and since you don't do this part all that often, it's easy to forget the steps from one time to the next. 

There are two main ways you'll want to set repositories up with git in the context of this class: forking someone else's repository and setting up your own repository based on a directory on your computer.

## Forking someone else's repository

First, you might want to get your own version of someone else's GitHub repository, so you'll have a personal version you can mess with and update on your computer and GitHub account. This is called "forking" someone else's repository.

To fully set up using forking, you first need to "Fork" in GitHub, and then you need to "clone" a copy to your laptop. To "Fork" in GitHub, go to the repository you're interested in and click the "Fork" button. Now go to your GitHub home page-- the forked repository should show up in your list of repositories. 

Now you just need to clone this repository so you'll have a copy on your laptop. To do that, open the command line for your computer. Use `cd` to get to the directory for which you'd like the clone to be a subdirectory (if you're fine with the clone being a directory of your home directory, you won't need to move around with `cd` at all). Then type:

```
git clone https://github.com/[yourgithubname]/[repositoryname].git
```

For example, my GitHub name is "geanders", and say I'd just forked the `rnoaa` repository, which includes a lot of cool R tools for getting NOAA weather data, to my repository. I can get a copy of everything from this repository in a directory on my home computer by opening my command line and typing:

```
git clone https://github.com/geanders/rnoaa.git
```

Now I can tweak the code for these R functions however I like, and generally keep my own running version in my GitHub repository. This won't at all affect the original repository *unless* I decide I've made some really cool changes that I think should go into the original, in which case I could make a "pull request", which asks the person who made the original if they'd like to integrate my changes into their version.

You will want to take one more step: if you think you'll ever want to keep up with changes the person with the original repository makes, you'll want to identify the original repository as 'upstream'. To do that, change into the new directory you've just cloned and then you can use `git remote` to identify the original repository. For example, the original repository for the 'rnoaa' repository I forked is "https://github.com/ropensci/rnoaa", so I'd type:

```
cd rnoaa
git remote add upstream https://github.com/ropensci/rnoaa.git
```

There's [a great set of instructions](https://help.github.com/articles/fork-a-repo) for forking a repository on GitHub.

## Setting up your own repository based on a directory on your computer

# Commands for once you've gotten going
Once you've initialized a directory as a git repository and linked it up with one in GitHub, you'll only need a few commands to keep things current between the directory on your laptop and the associated GitHub repository: `git add`, `git commit`, and `git push`.

## git add and git commit

Update the git repository on your computer (but not on GitHub yet) for all the changes you've made to files in the directory since the last time you committed. I usually use the option `-A` with the `git add` command, to make sure it adds any changes for any file, and the `-m` option with the `git commit` command, so I can add a message saying what changes I've made (plus, if I don't do that right, I often find git puts me into a vi session to write my message, and I just have no idea what to do with that). 

For example, say you've been working on several files in your current working directory (which is a git repository because you've initialized it using `git init`) and now you want to record all of the changes to all of them to your laptop. First, from the command line, use `pwd` to make sure you're in the directory you initialized as a git repository. Then you can type:

```
git add -A
git commit -m "I edited some of the text files."
```

Once you type this, the command line will print out some information about the changes you made. Note that this *doesn't* get your changes onto GitHub yet. It just records updates for your laptop. To get the changes onto GitHub, you'll need to use `git push`.

## git push

Update your GitHub repository with the changes you've made to your files. Once you've committed the changes to your laptop using `git add` and `git commit`, type: 

```
git push
```

The command line will ask for your GitHub username and your GitHub password. If you don't remember these, go to the GitHub website, where I imagine they have a way to help you (probably email to the email address associated with your account) if you've forgotten either of these.

Once you put those in, if all goes well, you'll get some messages on the command line about the push and then your GitHub repository will have the latest versions of your files.

## Special case: you're working with a forked directory

If you're working with a forked repository, you may want to get any changes that the person with the original repository made since you forked, and then merge those changes with any you've made. To do that, you need to have identified the original repository as 'upstream' (see the directions for forking a repository above), and then you can `fetch` new changes and `merge` them with changes you've made using: 

```
git fetch upstream
git merge upstream/master
```

(I've put these together, but you don't have to `merge` changes with your files unless you want to.)