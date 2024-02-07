---
layout: post
title: 'curl: fuzzy search options using fzf'
excerpt: using fzf to fuzzy search curl options
date: 2024-02-08 00:00 CET
updated: 2024-02-08 00:00 CET
categories: cli, fzf
tags: fzf
image: "/assets/images/fzf_curl/fzf_curl.webp"
---
Curl has more than 200 CLI options, and using classic autocomplete is not a great way to find those options. 
So, we will use the fzf, and its [custom fuzzy completion API][custom_fuzzy_completion_api], `_fzf_complete` to easily find those options.

```bash

_fzf_complete_curl() {
  _fzf_complete --header-lines=1  --prompt="curl> " -- "$@" < <(
    curl -h all
  )
}

_fzf_complete_curl_post() {
  awk '{print $1}' | cut -d ',' -f -1
}

```

Here is the above snippet in action. 

[![asciicast](https://asciinema.org/a/5i7ubSfnksIpzJvWcDguDQBat.svg){: style='width: 100%'}](https://asciinema.org/a/5i7ubSfnksIpzJvWcDguDQBat)

[custom_fuzzy_completion_api]: https://github.com/junegunn/fzf?tab=readme-ov-file#custom-fuzzy-completion


  

Versions of Language/packages used in this post.

```
| Library/Language | Version |
| ---------------- |---------|
| fzf              |  0.45.0 |
```