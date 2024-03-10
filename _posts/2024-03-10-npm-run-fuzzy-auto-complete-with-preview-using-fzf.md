---
layout: post
title: npm run fuzzy auto-complete with preview using fzf
excerpt: npm run fuzzy auto-complete with preview using fzf
date: 2024-03-10 14:00 CEST
updated: 2024-03-10 14:00 CEST
categories: cli, fzf
tags:
- fzf
image: "/assets/images/fzf_npm_run/fzf_npm_run.webp"
---
In my previous blog post, we discussed adding [fuzzy search for curl options using fzf][curl_fzf].

In this post, we will add fuzzy completion to the `npm run` command by reading "scripts" from `package.json` in the current directory. This requires [jq][jq], to available on `PATH`.

{: style="text-align: center"}
![NPM run with fzf completion](/assets/images/fzf_npm_run/fzf_npm_run.webp){: style='width: 100%'}



## <a class="anchor" name="helpers-for-sub-command" href="#helpers-for-sub-command"><i class="anchor-icon"></i></a> Helpers for sub-command

Fzf `_fzf_complete_COMMAND` function will trigger on main command and not for sub commands like `npm run`. To support this, we need some helper functions.

```bash
_fzf_complete_get_command_pos() {
    local arguments=("${(Q)${(z)@}[@]}")
    local cmd=$(__fzf_extract_command "$@")
    echo ${arguments[(i)$cmd]}
}

_fzf_complete_trim_env() {
    local command_pos=$1
    shift 1
    local arguments=("${(Q)${(z)@}[@]}")
    echo ${(q)arguments[$command_pos, -1]}
}

_fzf_complete_get_env() {
    local command_pos=$1
    shift 1
    local arguments=("${${(z)@}[@]}")
    echo ${arguments[1, $command_pos - 1]}
}
```


## <a class="anchor" name="fzf-complete-for-npm-run" href="#fzf-complete-for-npm-run"><i class="anchor-icon"></i></a> fzf complete NPM run

Now, using the above helper functions, we can add `_fzf_complete_npm` and `_fzf_complete_npm_run` as below.

```bash

_fzf_complete_npm() {
    setopt local_options no_aliases
    local command_pos=$(_fzf_complete_get_command_pos "$@")
    local arguments=("${(Q)${(z)"$(_fzf_complete_trim_env "$command_pos" "$@")"}[@]}")
    local subcommand=${arguments[2]}

    if (( $command_pos > 1 )); then
        local -x "${(e)${(z)"$(_fzf_complete_get_env "$command_pos" "$@")"}[@]}"
    fi

    if (( $+functions[_fzf_complete_npm_${subcommand}] )) && _fzf_complete_npm_${subcommand} "$@"; then
        return
    fi

    _fzf_path_completion "$prefix" "$@"
}

_fzf_complete_npm_run() {
    local package=${npm_directory-$(dirname -- $(npm root))}/package.json
    if [[ ! -f $package ]]; then
        return
    fi

    local scriptContent=$(cat package.json | jq -r '.scripts')

    _fzf_complete  --prompt="npm run> " --preview="echo '$scriptContent' | jq -r '.\"{}\"'"  -- "$@" < <(
      echo $scriptContent | jq -r 'keys[]'
    )
}
```

Here is a small preview of the above script in action. 

{: style="text-align: center"}
[![NPM run with fzf completion](https://asciinema.org/a/637425.svg){: style='width: 100%'}](https://asciinema.org/a/637425)


[jq]: https://jqlang.github.io/jq/
[curl_fzf]: /2024/02/curl-fuzzy-search-options-using-fzf.html


  

Versions of Language/packages used in this post.

```
| Library/Language | Version |
| ---------------- |---------|
| jq               |   1.7   |
| fzf              |  0.45.0 |
| zsh              |   5.9   |
```  
