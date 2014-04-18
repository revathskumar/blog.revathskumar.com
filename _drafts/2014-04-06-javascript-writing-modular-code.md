---
layout: post
title: "JavaScript : Writing modular code"
date: 2014-04-06 11:00:00 IST
updated: 2014-04-06 11:00:00 IST
categories: javascript
---

As every newbies to JavaScript, me too jumbed into the language without really learning it. That time I only used JavaScript for client side validations with use of jQuery and its plugins. But when the years passed the usage of JavaScript increaced and started using it for more functionalities. Then the code which I wrote started becoming a mess. 

Starting to learn Backbone and testing in JavaScript was a turning point in my JavaScript carrier. They taught me how to write modular code, which can be testable, reusable, maintainable and not to mess things up.

Here is simple todo app example in which how I changed the code into modular one from a spaghetti code. The functionality of this is really simple which will allow you to add a todo item and remove it.

When I wrote the todo app with simple javascript it look simpler and functioning perfectly. You can take a look at [jsbin](http://jsbin.com/tezod/1/edit) to try out.

```html
<!-- todo.html -->
<div class="container">
  <ul class="items">
    
  </ul>
  <button class="btn add-item">Add Item</button>
</div>
````


```js
// todo.js
(function(){
  
  var d = document;
  var btn = d.querySelector('.add-item');

  btn.addEventListener('click', function(){
    var cont = d.querySelector('.items');
    var item = d.createElement('li');
    var text = prompt('write something');
    item.innerHTML = text + " <span class='close pull-right'>&times;</span>";
    cont.appendChild(item);
    item.addEventListener('click', function(){
      cont.removeChild(this);
    });
  });                   
})();
```

In first look, you can't find any issues with this code, since it works fine. but when we take a deep look this code

* Not testable
* Not Maintainable
* Not reusable

To fix these issues we need to refactor this into simple modules. This is how I done it.

```js
// todo.module.js
(function(){
  var d = document;
  var Wrapper = function(options){
    this.el = options.el;
    this.el.querySelector('.add-item').addEventListener('click', this.add.bind(this));
  };
  
  Wrapper.prototype.add = function(item){
    if(!item.el){
      item = new Item({el: d.createElement('li')});
    }
    this.el.querySelector('.items').appendChild(item.el);
  };
  
  var Item = function(options) {
    this.el = options.el;
    this.el.innerHTML = this.createText(options.text);
    this.el.addEventListener('click', this.remove.bind(this));
  };
  
  Item.prototype.createText = function (text) {
    if(text === undefined){
      text = prompt('write something');
    }
    return text + " <span class='close pull-right'>&times;</span>";
  };
    
  Item.prototype.remove = function(e) {
    if(e.target.tagName.toLowerCase() == 'span'){
      this.el.removeEventListener('click', this);
      this.el.parentNode.removeChild(this.el);
    }
  };
  
  var wrap = new Wrapper({el: d.querySelector('.container') });
    
})();
```

I know that the code has grown from 15 lines to something like 30-37 lines. But why this code is better?

# Seperated the functionalities
It splits into two Wrapper and item in which the functionlites on the todo-list will go to wrapper and and functionalities to the specific items goes to item. ie., we can test them seperately.

# Testable
Since we are padding the container Node in the constructor, during tests its easy for us to replace it with some dummy divs.

# Maintainable
Here we clearly know where the functionalities are written in Wrapper or in Item. If need to add another functionlity it will be very clear that where some one should write that.

See the code in action.

<a class="jsbin-embed" href="http://jsbin.com/pariz/4/embed?js,output">JS Bin</a><script src="http://static.jsbin.com/js/embed.js"></script>

If you are interested, here is a [CoffeeScript](http://jsbin.com/majoh/7/edit?js,output) version for you. I think the CS version will more look as modular. 

Hope this will help you to write modular code from today.