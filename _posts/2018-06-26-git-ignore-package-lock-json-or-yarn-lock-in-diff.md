---
layout: post
title: 'Git : ignore package-lock.json or yarn.lock in diff'
excerpt: 'Git diff with package-lock.json/yarn.lock is difficult since you need to scroll though too much noise, you can ignore those only for diff via this tip'
date: 2018-06-26 01:05:00 IST
updated: 2025-02-03 14:11:00 CET
categories: git
tags: git, lock-files
image: /assets/images/2018/git-diff/git-diff-package-lock.webp
---


Git diff with `package-lock.json`/`yarn.lock` is difficult since you need to scroll though too much noise, but we can't git ignore those as well. Those files are suppose to be checked into the repository.

![git diff][git_diff]{:style="width:100%"}

But those can be easily ignored only from the diff.

```sh
git diff -- ':!package-lock.json' ':!yarn.lock'
```

You can add this to your default alias for `git diff`.

```sh
alias gd="git diff -- ':!package-lock.json' ':!yarn.lock'"
```

Hope this tip helped.  
Comments are welcome.

    Versions of Language/packages used in this post.

    | Library/Language  | Version |
    | ----------------- |---------|
    |      Git          |  2.17.1 |


[git_diff]: {{ page.image }}
