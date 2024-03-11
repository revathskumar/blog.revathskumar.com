---
layout: post
title: 'Github : override language definitions'
excerpt: we can use .gitattributes to override the language definition
date: 2024-03-11 10:53 CET
updated: 2024-03-11 10:53 CET
categories: github
tags:
image: "/assets/images/github-linguist/json-with-comments.webp"
---
Recently, when I pushed some [gren-lang][gren-lang] code to GitHub, it was missing the syntax highlighting.  Since GitHub recognises ELM and the same can be used for Gren, I was looking for ways to override the language definition on GitHub. 

That led me to the [github-linguist/linguist][linguist], the library GitHub uses to detect the languages. Using the [override strategies][override], I was able to  get the syntax highlighting for  `.gren` files. 

## <a class="anchor" name="using-gitattributes-file" href="#using-gitattributes-file"><i class="anchor-icon"></i></a> Using `.gitattributes` file

I added the `.gitattributes` file with the below content in the project root, and GitHub started showing Elm syntax highlighting for all the `.gren` files in the repository.


```

*.gren linguist-language=Elm

```

Another use case can be to syntax highlight for `JSON with comments` file 

```

.vscode/*.json linguist-language=JSON-with-Comments

```

Below image shows the difference between before and after overriding the language definition of `JSON with comments` files. 

{: style="text-align: center"}
![JSON with Comments](/assets/images/github-linguist/json-with-comments.webp){: style='width: 100%'}


[gren-lang]: https://gren-lang.org/ 
[linguist]: https://github.com/github-linguist/linguist
[override]: https://github.com/github-linguist/linguist/blob/94e7b2/docs/overrides.md