Command Line Cheat Sheet
========================

## pwd

Literally, "print working directory". Find out where in the jungle of your computer files you are. 

```
pwd
```

## ls

"List". List all the files and directories in your current working directory (and, remember, you can figure out the name of *that* with `pwd`):

```
ls 
```

## mkdir

"Make directory". Make a new (sub)directory in whatever directory you're in (which, again, you can figure out using `pwd`). For example, to make a new subdirectory called "Week_1_Meeting" in whatever directory I'm working in, I would type:

```
mkdir Week_1_Meeting
```

## cd 

"Change directory". Change to a new directory. It will *always* work to put the full path to the directory:

```
cd /Users/brookeanderson/test-repo/Week_1_Meeting
```

However, there are also some shortcuts for getting to certain directories that can save a lot of time.

If it's a directory right below the one you're in right now (in which case it will show up when you type `ls`), you can just put the name of it, like:

```
cd Week_1_Meeting
```

If it's the directory right above the one you're in right now, you don't put the name, but rather `..`:

```
cd ..
```

If you want to get back to your home directory, from *anywhere*, you can put in `~`:

```
cd ~
```

Your home directory is the directory you're in when you first open Terminal or git bash. It's probably something like `\Users\[your name]\`.

## touch

Create a new file in your directory. For example, you can create a new (blank) markdown file called "CommandLineCheatSheet.md" by typing:

```
touch CommandLineCheatSheet.md
```

This file should now show up when you type `ls` when you're working in this directory. If you want to get really fancy, you could open and edit this file from the command line using a text editor like emacs or vi, but I cope out here and just find the file and open it using something like TextEdit or Notepad.