---
layout: post
title: 'Git: tips I follow for better git commits'
excerpt: 'Git: tips I follow for better git commits'
date: 2024-07-24 19:35 CEST
updated: 2024-07-24 19:35 CEST
categories: git
tags:
- git
image: ''
---
Git is more than just adding files and storing them. It's about looking back in time and seeing changes or going back to old changes. In order to properly and easily revert the changes in git, we should plan it at the time of committing the changes. 

In order to make the revert easier, I personally prefer to organise commits into logical chunks. Also, in case if I need to revert a change, I should be able to do it with ease, and I want the app to be able to build and run without any issues like missing dependency after the revert. 

Here are some of the questions I ask myself to help me organise the git commits. 

* Does this change include necessary dependencies, docs & tests related to feature or bug. 
* Does this commit pass the CI? 
* Does this commit build and run the app without any issues? 
* If I revert this change, does the app go back to previous stable state, including passing the CI and Build? 

Additionally, I follow the below guidelines 
* Don't club feature changes and refactoring changes. 
* Refactoring changes go after the feature changes (Ideally in a different PR). 
* Changes due to PR review comments, CI failures are always amended. 


This is more effort at the time of committing. But it pays off at the worst time when I need to revert or debug an issue.

Related Reading: [Submitting patches: the essential guide to getting your code into the kernel][0]


[0]: https://docs.kernel.org/process/submitting-patches.html#separate-your-changes