---
layout: post
title: "jQuery: set ajax callbacks conditionally"
excerpt: "jQuery: set ajax callbacks conditionally"
date: 2014-11-25 00:00:00 IST
updated: 2014-11-25 00:00:00 IST
categories: javascript, jquery, promises
---

When I work with `$.ajax`, many times I came across situations where  I need to set the 
success callback conditionally. I am not pretty intrested in setting a common callback and check the condition inside it. I like my functions to be simple and do less things as possible. So I used to set the options object explicity and set the `options['success']` conditionally and pass the resultant option object to `$.ajax` method. 


```js
options = {
  url: "create",
  data: JSON.stringify(data),
  contentType: 'application/json',
  type: "POST",
  error: handleFail,
}

if(type == "online") {
  options['success'] = function(response, status, xhr) {
    // ...
  }
}
else if(type == "other") {
  options['success'] = function(response, status, xhr) {
    // ...
  }
}

$.ajax(options)
```

But, ever since I am introduced to promises, I use the promise way to accomblish things. no more setting of options object conditionally. Since the `$.ajax` method will return a promise, use the returned object to chain with `$.done` method and set them conditionally with the callbacks. For me this is much more cleaner and extendable than the previous method and its the starting point where I am moving to promises where ever possible.

```js
$ajOrder = $.ajax({
  url: "create",
  data: JSON.stringify(data),
  contentType: 'application/json',
  type: "POST",
  error: handleFail
});

if( type == "online" ) {
  $ajOrder.done( function(response,status,xhr) {
    // ...
  });
}
else if( type == "other" ) {
  $ajOrder.done( function(response,status,xhr){
    //...
  });
}
```

I have already discussed the [promises in JavaScript](/2013/12/promises-in-javascript.html) a year back in [KeralaJS](http://keralajs.org) meetup. Hope that slides help you to get started with promises.

If you know any method better than these, please let me know.  
I am looking forward for the feedbacks.