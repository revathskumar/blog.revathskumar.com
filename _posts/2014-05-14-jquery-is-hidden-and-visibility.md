---
layout: post
title: "jQuery : is hidden &amp; visibility"
date: 2014-05-14 00:00:00 IST
updated: 2014-05-14 00:00:00 IST
categories: javascript
---

Recently I noticed that the `jQuery(':hidden')` won't work on an element with `visibility:hidden`. In order to test this I created a simple [jsbin](http://jsbin.com/lucab/1/edit) for it. It has 3 div's one with `visibility:hidden`, other with `display:none` and last with `opacity:0`. The `jQuery(':hidden')` return `true` only for the element with `display:none`.

```html
<div style="visibility:hidden" id="hidden"></div>
<div style="display:none" id="display-none"></div>
<div style="opacity:0" id="opacity"></div>

<script>
(function(){
  $('#hidden').is(':hidden') // return false
  $('#display-none').is(':hidden') // return true
  $('#opacity').is(':hidden'); // return false
})()
</script>
```
The [jQuery api doc](http://api.jquery.com/hidden-selector/) explains this well

Elements can be considered hidden for several reasons:

* They have a CSS display value of none.
* They are form elements with type="hidden".
* Their width and height are explicitly set to 0.
* An ancestor element is hidden, so the element is not shown on the page.

**Elements with visibility: hidden or opacity: 0 are considered to be visible, since they still consume space in the layout.**

If you are confused on "consume space", you can read my post [CSS : Visibility, Opacity and Display](/2014/02/css-visibility-display-opacity.html) which explains the difference between visibility, opacity and display.

