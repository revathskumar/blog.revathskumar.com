---
layout: post
title: "Browserify with gulp"
excerpt: "Browserify with gulp"
date: 2016-02-02 00:00:00 IST
updated: 2016-02-02 00:00:00 IST
categories: javascript
tags: browserify, gulp
---

In my [last blog post](/2016/01/browserify.html) I explained how to use browserify command line to bundle javascript modules. In this we will use browserify api to use it along with gulp. 

```js
import gulp from "gulp";
import browserify from "browserify";
import fs from "fs";

gulp.task('default', () => {
  browserify({
    entry: 'src/utils.js',
    debug: true
  })
  .bundle()
  .pipe(fs.createWriteStream('./dist/utils.js'));
});
```

A basic implementation can be done as above. But this won't work when you need to pipe with other gulp plugins like `uglify` or `gulp.dist`. This is because `browserify.bundle()` return a [text stream](https://github.com/substack/node-browserify#bbundlecb) where as gulp works using [vinyl stream](https://github.com/gulpjs/vinyl). In order to browserify to work with other plugins you need to use [vinyl-source-stream](https://github.com/hughsk/vinyl-source-stream).

`vinyl-source-stream` will convert text streams from `browserify.bundle()` to vinyl streams so you can pipe with other gulp plugins.

