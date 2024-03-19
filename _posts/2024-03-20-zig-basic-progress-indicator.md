---
layout: post
title: 'zig : basic progress indicator in terminal'
excerpt: basic progress indicator in terminal using zig and ansi escape code
date: 2024-03-19 22:46 CEST
updated: 2024-03-19 22:46 CEST
categories: zig
tags:
- zig
image: https://asciinema.org/a/647684.svg
---
Yesterday I thought of putting together my recent learning's about ANSI escape codes and zig. 

In my last blog, I used ANSI escape codes to give [color to the text][gren_ansi] in terminal. In this exercise, I will use `[1A` to erase start of line to the cursor so that I can build a basic progress indicator for the terminal. 

**Disclaimer : This is for learning purposes only, if you like to use a progress indicator with zig for your app, I suggest you to look into [Std.Progress][std_progress]{: target="_blank"}**

```zig

const std = @import("std");

pub fn main() !void {

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var progress = [10]u8{ '.', '.', '.', '.', '.', '.', '.', '.', '.', '.' };

    for (1..101) |i| {
        if (i % 10 == 0) {
            const a: usize = i / 10;
            progress[a - 1] = ':';
        }
        try stdout.print("\u{001b}[1AProcessing : [{s}] {d}%\n", .{ progress, i });

        try bw.flush();
        std.time.sleep(60 * 1000 * 1000);
    }

    try bw.flush();
}

```

Here is the small preview of the output.

{: style="text-align: center"}
[![asciicast](https://asciinema.org/a/647684.svg){: style='width: 100%'}](https://asciinema.org/a/647684){: target="_blank"}

I hope it helped.   
Thank You.  

Versions of Language/packages used in this post.


| Library/Language | Version |
| ---------------- | ------- |
| Zig              | 0.11.0  |

[gren_ansi]:/2024/03/gren-using-ansi-escape-codes.html
[std_progress]:https://ziglang.org/documentation/master/std/#std.Progress