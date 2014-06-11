Git Cheat Sheet
===============

NOTE: For all commands, I've just talked about the simplest things they do in the context of a very basic way of working with git and GitHub. There are loads of other options for all of these, but I would suggest starting with these very basic uses.

# Commands for once you've gotten going
Once you've initialized a directory as a git repository and linked it up with one in GitHub, you'll only need a few commands to keep things current between the directory on your laptop and the associated GitHub repository: `add`, `commit`, and `push`.

## git add and git commit

Updates the git repository on your computer (but not on GitHub yet) of all the changes you've made to files in the directory since the last time you committed. I usually use the option `-A` with the `git add` command, to make sure it adds any changes for any file, and the `-m` option with the `git commit` command, so I can add a message saying what changes I've made (plus, if I don't do that right, I often find git puts me into a vi session to write my message, and I just have no idea what to do with that). 

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