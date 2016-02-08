---
layout: post
title: "Browserify : hot module replacement (hmr)"
excerpt: "Bring webpacks hot module replacement into browserify"
date: 2016-02-08 00:00:00 IST
updated: 2016-02-08 00:00:00 IST
categories: javascript
tags: browserify, hmr
---

Ever since I heard about [Hot Module replacement](https://webpack.github.io/docs/hot-module-replacement.html) in webpack I loved the idea. But since I was using [browserify](/2016/01/browserify.html) to bundle I was not able to use it. Recently when I saw [this thread](https://github.com/substack/node-browserify/issues/1143) I thought I should try [browserify-hmr](https://github.com/AgentME/browserify-hmr/).

browserify-hmr can be used a browserify plugin. By default it uses websocket server transfer the changes. You can specify the mode using `-m` or `mode` option as websocket or ajax.

## Setup 

To start we need to install a couple of node modules.

~~~
npm i --save-dev babel-plugin-react-transform babel-plugin-transform-runtime react-transform-hmr
~~~

These are the modules needed for browserify-hmr. I hope the other modules like `babel-core`, `babel-preset-es2015`, `babel-preset-react`, `babelify` etc are already installed.

## Setup `.babelrc`

Now we need some configuration in `.babelrc`.

~~~ json
{
  presets: ["es2015", "react"],
  "plugins": ["transform-runtime"],
  "env": {
    "development": {
      "plugins": [
        ["react-transform", {
          "transforms": [
            {
              "transform": "react-transform-hmr",
              "imports": ["react"],
              "locals": ["module"]
            }
          ]
        }]
      ]
    }
  }
}
~~~

## Setup Gulp task

Now we can write a gulp task with `watchify` and load `browserify-hmr` as a plugin.

~~~ js
import gulp from 'gulp';
import browserify from 'browserify';
import source from 'vinyl-source-stream';
import buffer from 'vinyl-buffer';
import sourcemaps from 'gulp-sourcemaps';
import util from 'gulp-util';
import babelify from 'babelify';
import hmr from 'browserify-hmr';
import watchify from 'watchify';

gulp.task('hmr', () => {
  const b = browserify({
    entries: 'src/index.jsx',
    extenstions: ['.jsx'],
    plugin: [hmr, watchify], // load hmr as plugin
    debug: true,
    cache: {},
    packageCache: {}
  })
  .transform(babelify);

  b.on('update', bundle)
  bundle();

  function bundle() {
    b.bundle()
    .on('error', err => {
      util.log("Browserify Error", util.colors.red(err.message))
    })
    .pipe(source('index.js'))
    .pipe(buffer())
    .pipe(sourcemaps.init({loadMaps: true}))
    .pipe(sourcemaps.write('./maps'))
    .pipe(gulp.dest('./dist'));
  }

});
~~~

You can also use `b.plugin()` method to specify the hmr plugin with options.