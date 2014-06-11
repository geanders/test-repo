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

Later, we'll make sure you can pull changes I make to the original "test-repo". To do this, when you set up the repository on your computer, you'll want to also name the original repository (the one on my GitHub account) as "upstream" so you can grab any changes I make to that later. Establish that as the "upstream" remote repository within this git repository by changing into the new "test-repo" directory on your computer: 

```
cd test-repo
``` 

and then typing:

```
git remote add upstream https://github.com/geanders/test-repo.git
```

## 3. Make changes to some of the files in "test-repo" on your computer and try to update them to your GitHub "test-repo" repository

Now open up one of the Markdown files in your version of "test-repo" on your laptop (for example, try the README file). Type in your changes and save them like you normally would. 

Now, to get your changes saved with git on your computer, you can use `git add` and `git commit`. First, make sure you're in the right working directory by typing from your command line:

```
pwd
```

It should give you something ending with 'test-repo'. If not, use the `cd` command to get to the right directory. 

Next, add and commit your changes to the git repository on your laptop by typing into the command line:

```
git add -a
git commit -m "My first edit"
```

The changes are now all set on your laptop. Next, you want to get them up on GitHub. To do this, you'll use `git push`:

```
git push
```

(Note: I *think* that this is just a shorter version of `git push origin master`-- does anyone know?)

The command line will ask you for your GitHub username and then your password (if you've forgotten either of these, I think you should be able to get GitHub toemail them to the email address you used when you signed up). Now go check your GitHub account and see if the changes you made went through.

## 4. Fetch and merge changes I make to the original "test-repo" to your personal copy

Now I'll try making some changes to files in "test-repo". Once I make the changes, try getting them to your version using `fetch` and `merge`:

```
git fetch upstream
git merge upstream/master
```

