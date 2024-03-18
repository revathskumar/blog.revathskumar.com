---
layout: post
title: 'Gren : using ANSI escape codes'
excerpt: Using ANSI escape sequences to give colors for the terminal outputs in Gren
  Lang.
date: 2024-03-18 17:43 CET
updated: 2024-03-18 17:43 CET
categories: gren, node
tags:
- gren
image: "/assets/images/gren-ansi-escape-code/gren-ansi-escape-code.webp"
---
In this blog post, we will look into using [ANSI escape sequences](https://en.wikipedia.org/wiki/ANSI_escape_code) to give colors for the terminal outputs in [Gren Lang](https://gren-lang.org/).

Standard escape codes are prefixed with `\033` (Octal), ⁣`\x1B` (Hex) or `\u001B` (Unicode) followed by the command.

Gren Lang doesn’t support `\0` or `\x` as part of the string. So the only option is to use `\u` (Unicode).

In order to get some basic text in red color, we will be using output string like below.

```elm
"\u{001B}[32mHello \u{001B}[0m"
```

Below is the sample program to write the text with ANSI escape sequence to stdout.

```elm
init :
    Environment
    -> Init.Task
        { model : Model
        , command : Cmd Msg
        }
init env =
    Init.await Terminal.initialize
        <| (\termConfig ->
			Node.startProgram
				{ model =
					{ stdout = env.stdout
					, stderr = env.stderr
					}
				, command =
					Stream.sendLine env.stdout
    <| "\u{001B}[32mHello \u{001B}[0;4;31mworld!\n\u{001B}[0m"
				}
		)
```

Here is output look like

{: style="text-align: center"}
![Gren Lang ansi escape codes](/assets/images/gren-ansi-escape-code/gren-ansi-escape-code.webp){: style='width: 100%'}

You can look into the sample app on [GitHub][github_gren_Examples].


Versions of Language/packages used in this post.

| Library/Language | Version |
| ---------------- | ------- |
| gren-lang        | 0.3.0   |
| gren-lang/node   | 3.1.0   

I hope it helped.   
Thank You.

[ansi_wiki]:https://en.wikipedia.org/wiki/ANSI_escape_code
[gren]:https://gren-lang.org/
[github_gren_Examples]:https://github.com/revathskumar/gren-examples/blob/fa54ae1067064f7445ced43eb6041bd9bce774a4/ansi-escape-codes/src/Main.gren