Examples for trying git / GitHub
================================

## 1. Fork my test-repo repository to your own GitHub account

We'll start by making sure you can all get your own version of this GitHub repository in your own GitHub accounts by forking. Make sure you're logged in to GitHub under your account, then go to my [test-repo repository](https://github.com/geanders/test-repo). This repository has information and examples for our meetings in a series of different directories. Go the the "Fork" button on the top right and click on it. This should be all it takes. Now go check your GitHub homepage and see if you have this repository now.

## 2. Clone the test-repo repository to your laptop so you can work with it on your computer

So, you've got a version of "test-repo" on GitHub, because you forked it. But you don't have it on your computer yet. To do that, you "clone" the repository from your GitHub account to your laptop. 

First, you need to decide where to put it. Unless you feel strongly otherwise, let's put it as a subdirectory of your home directory. Open your command line (Terminal-- for Mac-- or git bash). You should be in your home directory when you first open your command line. Check by typing: 

```
pwd
```

This is the address of your working directory and where, unless you move around first by using `cd`, your clone of "test-repo" will go. Now clone "test-repo" to your computer by using `clone`. Type (replace [your git hub name] with your actual github name): 

```
git clone https://github.com/[your github name]/test-repo.git
```

Let's also name the original repository (the one on my GitHub account) as "upstream" so you can grab any changes I make to that later. Establish that as the "upstream" remote repository within this git repository by changing into the new "test-repo" directory on your computer: 

```
cd test-repo
``` 

and then typing:

```
git remote add upstream https://github.com/geanders/test-repo.git
```

