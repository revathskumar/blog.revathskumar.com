---
layout: post
title: "Yeoman : What's new in backbone generator"
date: 2014-02-10 00:00:00 IST
updated: 2014-02-10 00:00:00 IST
categoy: blog
---
In this blog post, I am trying to summarize the major updates to backbone generator.

# 1. Custom app path
Previously the scaffold is generated into only `app` folder. Now you can customize it with `--appPath` option.
{% highlight sh %}
yo backbone --appPath=public
{% endhighlight %}
This will create a folder named `public` instead of `app` and when you use any sub generators like `backbone:model` the scaffold will be created into the public directory.

<center>
![app-path option](http://i653.photobucket.com/albums/uu253/revathskumar/Coderepo/2014/02/yo-public_zpsc43683e5.png)
</center>

# 2. Generating mocha tests
We have written a new generator named [generator-backbone-mocha](https://github.com/revathskumar/generator-backbone-mocha) which will generate mocha tests for you backbone app. When you create new model with `yo backbone:model todo`, this will create `todo.spec.js` in your test folder.

<center>
![Backbone mocha](http://i653.photobucket.com/albums/uu253/revathskumar/Coderepo/2014/02/yo-backbone-mocha_zps66ebd55f.png)
</center>

You can choose bdd/tdd when generating the new backbone app with the `--ui` option.

{% highlight sh %}
yo backbone --ui=tdd 
{% endhighlight %}

By default the generator will be configured for bdd with mocha.

# 3. Added CoffeeScript support for RequireJS
Another great addition to backbone generator 2.0 is the CoffeeScript support for RequireJS. A lot of people were requesting for this and we happy to announce support for it. Thanks to [@stephanebachelier](https://github.com/stephanebachelier) for the pull request.

# 4. Bootstrap 3.0 
We are happy to announce that we are upgraded to [Bootstrap 3.0](http://getbootstrap.com). Now when you generate a new application, by default yeoman will install bootstrap 3.0. If you wanna use bootstrap 2.0, then you have to manually edit the version of sass-bootstrap in the `bower.json`.

Hope you like the new additions and enhancements made on backbone generator. We are looking for your comments.