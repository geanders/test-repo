Command Line Cheat Sheet
========================

## pwd

Literally, "print working directory". Find out where in the jungle of computer files on your computer you are. 

```
pwd
```

## ls

"List". List all the files and directories in your current working directory (and, remember, you can figure out the name of that with `pwd`):

```
ls 
```

## mkdir

"Make directory". Make a new (sub)directory in whatever directory you're in (which you can figure out using `pwd`). For example, to make a new subdirectory called "Week_1_Meeting" in whatever directory I'm working in, I would type:

```
mkdir Week_1_Meeting
```

## cd 

"Change directory". Change to a new directory. It will *always* work to put the full path to the directory:

```
cd /Users/brookeanderson/test-repo/Week_1_Meeting
```

However, there are also some shortcuts for getting to certain directories.

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
