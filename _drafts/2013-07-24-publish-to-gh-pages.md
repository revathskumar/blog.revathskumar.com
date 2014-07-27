---
layout: post
title: "publish your github pages with ease using git submodules"
excerpt: "publish your github pages with ease using git submodules"
date: 2014-07-24 00:00:00 IST
updated: 2014-07-24 00:00:00 IST
categories: github, git
tags: github, git
---

When I first start using github pages to publish web pages, It was pretty difficult 
for me to publish after the build. I need to 

* commit code to master 
* build and copy the build to temporary location
* switch to gh-pages branch
* copy back the build and push to gh-pages.

It was too much complicated until I got introduced to git submodules. 

> Submodules allow you to keep a Git repository as a subdirectory of another Git repository.

Its not only another repository, but also another branch of the same repository. 
Here to make publishing easier, I used git submodules which will convert my publish directory points to gh-pages branch.

## Setup the Git respository

To start with commit your sourcecode to master branch and push to the remote repository.
Then create a `orphan` branch named `gh-pages`.

```sh
git checkout --orphan gh-pages
```

Removed all the files which are cached to and ready to commit in gh-pages. Then create a sample file and push to the remote. Then switch to master branch.

## Setup dist/Publish folder

If you already have a dist/publish directory remove it from the project and `.gitignore`.

## Create submodule

Create a gh-pages as the submodule to the dist directory

git submodule add -b <gh-pages> <repo url> <dist/publish directory>

```sh
git submodule add -b gh-pages git@github.com:revathskumar/todo-custom-element-backbone.git dist
```