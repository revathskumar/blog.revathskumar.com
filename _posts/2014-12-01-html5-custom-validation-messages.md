---
layout: post
title: "HTML5: custom validation messages"
excerpt: "HTML5: custom validation messages"
date: 2014-12-01 00:00:00 IST
updated: 2014-12-01 00:00:00 IST
categories: html5, javascript
---

By the introduction of HTML5 validations, things are really getting easy for the developers regarding the form validation. we can validate the inputs using the attributes itself. They usually have their on predefined validation message. What if we want our custom validation message. we always need it. right?

For the required attribute, the usual error message is "*Please fill out this field*". Let see how we can customize those messages.

Here is a simple form with number field `age` with required attribute, minimum is set to 1 and maximum value set to 150.

```html
<form action="">
  <label for="age"> Age </label>
  <input type="number" name="age" required="required" min="1" max="150"/>
  <input type="submit"/>
</form>
```

This form is invalid if age field is blank, non-number, less than or equal to zero and greater than 150. Every input have a **oninvalid** event handler in which we can assign a handler method, this method will be triggered when value in this input is invalid.

```js
document.addEventListener("DOMContentLoaded", function(){
  var invalid = function (e) {

  };

  var age_element = document.getElementsByName("age");
  age_element[0].oninvalid = invalid;
});
```

This is just like any other event handle like `click`, `mouseover`, `mouseout` etc. The event object will be passed to the handler. From the event object we will get the target element using `e.target`. Now the target will have a property named `validity` which is an object of `ValidityState`. The `ValidityState` object will have all the errors types with a boolean value.

```js
[object ValidityState] {
  badInput: false,
  customError: false,
  patternMismatch: false,
  rangeOverflow: false,
  rangeUnderflow: false,
  stepMismatch: false,
  tooLong: false,
  typeMismatch: false,
  valid: false,
  valueMissing: false
}
```

If the required attribute of an element is violated, then `valueMissing` will be `true`. So now we have a way to identify which validation is violated. Now we need a way to set custom message.

The target element have `setCustomValidity` method to set the validation message. It accepts a string argument which is our custom message. SO now we can customize the `valueMissing` (required) error as follows.

```js
document.addEventListener("DOMContentLoaded", function(){
  var invalid = function (e) {
    if(e.target.validity.valueMissing){
      e.target.setCustomValidity("Value Missing");
      return;
    }
  };

  var age_element = document.getElementsByName("age");
  age_element[0].oninvalid = invalid;
});
```

Set `setCustomValidity` to empty string to indicate that element doesn't have custom validity message. After settings the custom message for other errors our code will look like

```js
document.addEventListener("DOMContentLoaded", function(){
  console.log("DOM loaded");
  var invalid = function(e){
    if(e.target.validity.badInput){
      e.target.setCustomValidity('Only Integer');
      return;
    }
    if(e.target.validity.rangeOverflow){
      e.target.setCustomValidity('max value 150');
      return;
    }
    if(e.target.validity.rangeUnderflow){
      e.target.setCustomValidity('min value 1');
      return;
    }
    if(e.target.validity.valueMissing){
      e.target.setCustomValidity("Value Missing");
      return;
    } 
  }; 

  var age_element = document.getElementsByName("age");
  age_element[0].oninvalid = invalid;
    
});
```

If you want to see this in action here is the jsbin.

<a class="jsbin-embed" href="http://jsbin.com/xameda/5/embed?js,output">JS Bin</a><script src="http://static.jsbin.com/js/embed.js"></script>

Hope you enjoyed the post. Let me know if you have any feedback or corrections.  
Thank You.  

