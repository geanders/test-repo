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

## 4. Create your own repository

Go to your GitHub account and click on the "Repositories" tab. On the top right there should be a button that says "New". Click it. This takes you through the steps to create a new repository on your GitHub account. Create one called "MyRCode". Make it public and give it a README file (these are all options when you make the repository).

Now you have the new repository on GitHub (check your account and make sure), but it's not on your computer yet. 

Open your command line and make sure you're in your home directory (check by typing `pwd`). If you are, make a new directory called "MyRCode" using `mkdir` then move into it using `cd`:

```
mkdir MyRCode
cd MyRCode
```

Check if you've succeeded using `pwd`. 

Initialize this directory as a git repository using `git init`:

```
git init
```

Create a README file using `touch`:

```
touch README
```

Add and commit this change to your laptop's git repository:

```
git add -A
git commit -m "Created README file"
```

Now we have the appropriate repositories set up on both your laptop and your GitHub account, we just need to link them using `git add` (replace [username] with your GitHub user name):

```
git remote add origin https://github.com/[username]/MyRCode.git
```

Now sync the new files using `git push`:

```
git push
```

Any errors? Sometimes I'll get some with the first push, saying that I need to pull the GitHub version and merge any changes. Let's deal with that if we get that error.

## 5. Add a file with some simple R code to your laptop "MyRCode" directory and push it to GitHub.

Once you've got your laptop and GitHub repositories going and linked, try editing or adding files to the directory on your laptop and then sending them to GitHub. We'll try adding a simple R file. 

First, go to the command line use `pwd` to make sure you're in the right directory (if you are, you should get something that ends with "MyRCode"). If not, use `cd` to move to the "MyRCode" directory. 

Add a blank R file using:

```
touch SimpleExample.R
```

Open the file you just created in RStudio. Add the following code:

```
df <- c(5, 23, 14, 9, 16, 3)
mean(df)
hist(df)
```

Save the file in R. Go back to your command line. Make sure you're still in the right directory using `pwd`. Save your files to your laptop's git repository and then push them to your GitHub account using:

```
git add -A
git commit -m "Created SimpleExample.R file"
git push
```

Check and see if the changes made it up to your GitHub repository. 

Now go back to the R file on your laptop and edit the file to include comments saying what each file does. A comment can be put on any line if you start it with two hash tags, like:

```
## This is an example of an R comment
```

Save, add, commit, and push again. Check your GitHub repository to see if the changes made it through.  

## 6. Fetch and merge changes I make to the original "test-repo" to your personal copy

Now I'll try making some changes to files in "test-repo". Once I make the changes, try getting them to your version using `fetch` and `merge`:

```
git fetch upstream
git merge upstream/master
```

