---
layout: post
title: "ES6 : First sip of ES6 with traceur"
date: 2013-10-19 00:00:00 UTC
updated: 2013-10-19 00:00:00 UTC
categories: es6
---

I was really curious about the upcoming ES6 features. After a long time, today I made time to try out some of the features using [traceur-compiler](https://github.com/google/traceur-compiler).

First thing I done was to setup a boilerpate to run ES6 with traceur.
{% highlight html %}
<!-- index.html -->
<!doctype html>
<html class="no-js"> <!--<![endif]-->
    <head>
      <title>ES6</title>
    </head>
    <body>
      
    <script src="https://traceur-compiler.googlecode.com/git/bin/traceur.js"
        type="text/javascript"></script>
    <script src="https://traceur-compiler.googlecode.com/git/src/bootstrap.js"
        type="text/javascript"></script> 
    <script>
        traceur.options.experimental = true;
    </script>
    <script type="text/traceur" "calc.js"></script>
  </body>
</html>
{% endhighlight %}

In the above traceur.js is the compiler and bootstrap.js is used for compile all the script tags with **type="text/traceur"** into vanila js.

All the Experimental features in traceur are truned off by default, so we need to enable all the experimental features using

{% highlight html %}
<script>
    traceur.options.experimental = true;
</script> 
{% endhighlight %}

Now lets create a class for calculator and define a function named add.

{% highlight js %}
// calc.js
class Calc {
    constructor(){
      console.log('Calc constructor');
    }
    add(a, b){
      return a + b;
    }
}

var c = new Calc();
console.log(c.add(4,5));
{% endhighlight %}

Hooray!! it works!!

Modules are not fully implemented on traceur, so until we need to use [ES6 Loader polyfill](https://github.com/ModuleLoader/es6-module-loader).

If you want traceur to work on command line, You can install via npm.

{% highlight js %}
npm install traceur -g
{% endhighlight %}

And we can run it by,

{% highlight js %}
traceaur calc.js
{% endhighlight %}

This will you compile and execute the calc.js and output to terminal.

If you wanna compile to another file,

{% highlight js %}
traceaur --out build/calc.js calc.js
{% endhighlight %}

This will store the compiled js to *build/calc.js*. You can trun on experimental features with `--experimental` option.

