---
layout: post
title: 'gjs : How to read from stdin in a gtk application'
excerpt: 'gjs : How to read from stdin in a gtk application'
date: 2025-01-10 18:45 CET
updated: 2025-01-10 18:45 CET
categories: javascript gjs
tags: javascript gjs gtk stdin gtk4
image: ""
---

In this blog post, I will show you how to read from stdin in a GTK application written with gjs. 

Since I was already using [greenclip](https://github.com/erebe/greenclip)(with [rofi](https://github.com/davatorium/rofi)) for clipboard history, I would like to use [Bender](https://github.com/revathskumar/bender) in a similar way. `greenclip print | bender` .

As a beginner to GJS-GTK, my first challenge was to [bootstrap a GTK app](/2025/01/writing-gjs-gtk-app-in-typescript.html) and read the data from stdin. 

For the first prototype, I used the [InputStream.read_bytes](https://docs.gtk.org/gio/method.InputStream.read_bytes.html) like below
## <a class="anchor" name="using-read-bytes" href="#using-read_bytes"><i class="anchor-icon"></i></a>Using read_bytes 

```ts
const cli = new Gio.ApplicationCommandLine();
const inputStream = cli.get_stdin();

let str = "";
const bytes = inputStream?.read_bytes(8192, null);
inputStream?.close(null);
const data = bytes?.get_data();
if (data) {
  str = new TextDecoder("utf-8").decode(data);
}
```

This comes with some limitations, 

1. Its synchronous/blocking
2. we have to specify the no of bytes

I settled with `read_bytes` because, when I tried to use `read_all_async` or `read_all` I was getting errors like below in GJS 1.74.2.
* `Function Gio.InputStream.read_all_async() cannot be called: argument 'buffer' with type array is not introspectable because it has a type not supported for (out caller-allocates)`
* `TypeError: method Gio.InputStream.read_all_async: At least 4 arguments required, but only 3 passed`

Once I had an initial prototype, I started looking into better ways to read from stdin in GTK applications.

A quick search of the above errors led me to some discussions on the Gnome forums like [this](https://discourse.gnome.org/t/cannot-read-from-inputstream-gio-inputstream/15186) and [this](https://discourse.gnome.org/t/dynamically-allocated-buffer-for-gio-inputstream/24576) which lead me to a [bug report #501 on GJS](https://gitlab.gnome.org/GNOME/gjs/-/issues/501) & a [merge request #787](https://gitlab.gnome.org/GNOME/gjs/-/merge_requests/787) 

Based on [merge request #787](https://gitlab.gnome.org/GNOME/gjs/-/merge_requests/787) I decided to give a try to `MemoryOutputStream.splice_async`. 

## <a class="anchor" name="using-splice-async" href="#using-splice-async"><i class="anchor-icon"></i></a>Using MemoryOutputStream.splice_async

I started replacing the read_byes with `splice_async` & `splice_finish` and it worked fine.

```ts
const cli = new Gio.ApplicationCommandLine();
const inputStream = cli.get_stdin();

if (inputStream) {
  const outputStream = Gio.MemoryOutputStream.new_resizable();

  outputStream.splice_async(
	inputStream,
	Gio.OutputStreamSpliceFlags.CLOSE_TARGET,
	GLib.PRIORITY_DEFAULT,
	null,
	(outputStream, result) => {
	  let data;
	  let str = "";
	  let bytes;

	  try {
		outputStream?.splice_finish(result);
		bytes = outputStream?.steal_as_bytes();
	  } catch (err) {
		console.debug(err);
	  }

	  data = bytes?.get_data();
	  if (data) {
		str = new TextDecoder("utf-8").decode(data);
	  }
	  console.debug("body:", str);
	},
  );
}
```

For now, this looks better than using `read_bytes` and I don't need to worry about the hard coded bytes count, and it's non-blocking. 

Hope this is helpful.
Did I make any mistake or is there a better way, feel free for drop an email.

  
Versions of Language/packages used in this post.
  
| Library/Language | Version |
| ---------------- | ------- |
| GJS              | 1.74.2  |
