---
layout: post
title: "Express.js : respect DNT header"
excerpt: "Express.js : respect DNT header"
date: 2015-01-02 00:00:00 IST
updated: 2015-01-02 00:00:00 IST
categories: javascript, express, nodejs
---

Nowadays big companies like google and facebook are tracking uses even they are logged out. Most of the sites are now installed with facebook like button and google analytics which help them to track users easily.

We might need Google analytics and Facebook like button for our apps to reach and target users. Many users really want to be tracked and installing these trackers for those users is against our ethics. But how you will know whether users don't want to be tracked?

The people who care about privacy, will be enabled DNT in their browsers.  Now every popular browsers are equipped with a **Do not track (DNT)** settings. If the user is enabled Do not Track browser will send a **DNT** flag with headers. Using this flag you can identify the users who care for privacy and can be opt out from installing tracker for them.

Recently, when I released [Gist reader](http://gistreader.herokuapp.com/), a toy app for reading gists written in markdown, I thought of not to install any trackers for those who send **DNT** flag. Since *Gist reader* was build with [Express.js](http://expressjs.com) I can show you how I opt out Google Analytics for users with DNT flag.

Since DNT should be implement though out all the pages, I implemented it as a middleware. You can get the value of DNT header from `req.headers.dnt`. I used the value from `req.headers.dnt` and passed to view using [app.set](http://expressjs.com/api.html#app.set). The value of `req.headers.dnt` will **`1`** if the user enable DNT and **`0`** if they didn't.

```js
// In app.js
app.use(function(req, res, next){
    app.set('dnt', req.headers.dnt);
    next();
});
```

Now the value of DNT header will be available in views via `settings` variable and we can install Google Analytics tracker for those DNT header value is **`0`**.

```jade
// layout.jade
unless settings.dnt
  script
    | (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    | (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    | m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    | })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

    | ga('create', 'UA-xxxxxxx-xx', 'auto');
    | ga('send', 'pageview');
```

Done. Now you are respecting the users privacy by not installing the trackers. Same way you can replace the Facebook like/share button with a simple share link.
