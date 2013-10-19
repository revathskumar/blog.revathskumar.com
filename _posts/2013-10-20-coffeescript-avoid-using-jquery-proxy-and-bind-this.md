---
layout: post
title: "CoffeeScript : Avoid using jQuery proxy and .bind(this)"
date: 2013-10-20 00:00:00 UTC
updated: 2013-10-20 00:00:00 UTC
categories: es6
---

There are many times I need to execute the methods, which are triggered by an event handler/callbacks to execute without changing the context. So that I can use instance variables or methods inside them. I usually use [$.proxy](http://api.jquery.com/jQuery.proxy/) or [.bind()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/bind) method to achieve this.

When I was learning [CoffeeSctipt](http://coffeescript.org), I continued using the same. later I came to know there CoffeeScript supports much handy way to do the same.

In CS, you can use Fat arrow functions for this.

{% highlight coffeescript %}
class Form
  constructor: (root) ->
    @root = root;
    @root.on 'submit', @onSubmit
    @root.on 'submit', @onSub

  onSub:(e) ->
    console.log(this)
    return false;
  
  onSubmit:(e) =>
    console.log(this)
    return false;
{% endhighlight %}

In the above code, I want to execute the `onSubmit` method in the context of `Form`.
Since the `onSubmit` is trigger by the submit event, by default its context will be element which the event is binded.

I hope you understand the differece between thin arrow and fat arrow function. You can get the detailed description on the [CoffeeScript doc](http://coffeescript.org/#fat-arrow).

## In ECMAScript 5

If you are using ECMAScript 5, As I saild before you can use [.bind()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/bind) method.

{% highlight coffeescript %}
var Form = (function(){
  function Form(root){
    this.root = root;
    this.root.on('submit', this.onSubmit.bind(this));
    this.root.on('submit', this.onSub);
  }

  Form.prototype.onsubmit = function(e){
    console.log(this)
    return false;
  }

  Form.prototype.onSub = function(e){
    console.log(this)
    return false;
  }

  return Form;
})()
{% endhighlight %}