---
layout: post
title: "JavaScript: Extending Module pattern"
excerpt: "JavaScript: Extending Module pattern"
date: 2014-11-26 00:00:00 IST
updated: 2014-11-26 00:00:00 IST
categories: javascript, patterns
---

I like to write independent, decoupled modules, so we can add or remove modules as we like and don't want to care about other modules. Initially when I started working with [whatznear](http://whatznear.com/), I used contructor patten for modules, but when the requirements started getting complicated I understood that the constructor pattern was not enough. I want something more to make the modules decoupled and thus I introduced module pattern along with  mediator pattern. 

In module pattern actually we can have public and private methods with the help of cloures. So I wrote a module for Product review with init method as public api. It worked fine, until I need to add reviews for Stores.

Store review was pretty much similar, except loading of reviews, so I thought of extending `ProductReview` module. Then I came to understand that if I want to override a method in it should be public. That made me change the visibility of `load` method to public.

```js
ProductReview = (function () {
  var _el = "";

  var init = function (options) {
    _el = options.el;
    options.load = options.load || true;
    // other event bindings and defaults
  };

  var load = function () {
    $.ajax({
      url: "/reviews.json",
      data: {
        product_id: _el.data('product-id'),
        inventory_id: _el.data('inventory-id'),
      },
      type: "GET",
    })
    .done(_success)
    .fail(_error)
  };
  
  var _success = function (data, status, xhr) {
    // ...
  };

  var _error = function(data, xhr) {
    // ..
  };

  // other functionalities

  return {
    init: init,
    load: load
  };

})()
```
Thus my ProductReview module works fine with new changes and now I need to extend this for the store review and I only need to update the load method and its success and error callbacks. Since I need all event binds as it is in product review and I don't want to duplicate any code, So I just used `init` method of ProductReview itself.

```js
StoreReview = (function() {

  var load = function() {
    $.ajax({
      url: "/store_reviews.json",
      data: {
        store_id: this._el.data('store-id')
      }
      type: "GET",
    })
    .done(_success.bind(this))
    .fail(_error)
  };

  var _success = function(data, status, xhr) {
    // ...
  };

  var _error = (data, xhr) {
    // ..
  };

  return {
    load: load,
    init: ProductReview.init
  };

})()
```

Thus my store review module is ready, just with the change for load and other callback. Since both these module never come on the same page (atleast for now) it works perfectly. 

If you think this implementation have any problem or issue. please lemme know.