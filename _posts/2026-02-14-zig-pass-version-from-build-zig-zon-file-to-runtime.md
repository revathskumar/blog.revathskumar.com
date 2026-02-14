---
layout: post
title: 'zig : pass version from build.zig.zon file to runtime'
date: 2026-02-14 12:53 CEST
updated: 2026-02-14 12:53 CEST
categories: zig
tags:
- zig
image: ''
---
In this blog post we will explore how to pass the options/values from the build to the project's Zig code. To illustrate this, we will consider the example of reading the version from `build.zig.zon` at build and using it at runtime.

<!--excerpt ends-->

Zig won't allow us to import the `build.zig.zon` file in our main or other source files. So we need to get the value at build and expose it to our modules.

## <a class="anchor" name="use-addOptions-in-build-script" href="#use-addOptions-in-build-script"><i class="anchor-icon"></i></a>use `addOptions` in build script

From Zig `v0.14.0`, we can [import zon](https://ziglang.org/download/0.14.0/release-notes.html#Import-ZON){: rel="nofollow"} file at compile time 

```zig
const pkg = @import("build.zig.zon");
```

Now we have the version number from `build.zig.zon` in `pkg.version`.  

The `addOptions` from `std.Build` provides a way to expose build.zig values to Zig source code with `@import`.

```zig
// build.zig
const pkg = @import("build.zig.zon");


pub fn build(b: *std.Build) void {

    const exe = b.addExecutable(.{
      //
    });

    const options = b.addOptions();
    options.addOption([]const u8, "version", pkg.version);
    exe.root_module.addOptions("build_options", options);

}
```

We named the options `build_options`, which will be used for importing the values into other source files.

## <a class="anchor" name="import-build-options-in-main" href="#import-build-options-in-main"><i class="anchor-icon"></i></a>import `build_options` in main

Now we can do `@import("build_options")` in the main, to access the value of `version`.


```zig
// main.zig
const std = @import("std");
const build_options = @import("build_options");

pub fn main() anyerror!void {
	var stdout_buffer: [1024]u8 = undefined;
	var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
	const stdout = &stdout_writer.interface;

	try stdout.print("Clipz : v{s} \n", .{build_options.version});
	try stdout.flush();
}
```

## <a class="anchor" name="parsing-the-version-number" href="#parsing-the-version-number"><i class="anchor-icon"></i></a>parsing the version number

In case you need to parse the version number at runtime, you can use the `parse` method from [std.SemanticVersion](https://ziglang.org/documentation/0.15.2/std/#std.SemanticVersion){: rel="nofollow"} 

Hope this is helpful.

Versions of Language/packages used in this post.

| Library/Language | Version |
| ---------------- | ------- |
| zig              | 0.15.2  |
|                  |         |
{: style="width:100%"}
