---
layout: post
title: "jQuery : is hidden &amp; visibility"
date: 2014-05-03 00:00:00 IST
updated: 2014-05-03 00:00:00 IST
categories: javascript
---

Recently I noticed that the `$.is(':hidden')` won't work on an element with `visibility:hidden`. In order to test this I created a simple [jsbin](http://jsbin.com/lucab/1/edit) for it. It has 3 div's one with `visibility:hidden`, other with `display:none` and last with `opacity:0`. The `$.is('hidden')` return `true` only for the element with `display:none`.

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

I am pretty sure this is not a bug, but why it works like this is not sure. May be because the `visibility:hidden` &amp; `opacity:0` [consume space](/2014/02/css-visibility-display-opacity.html) of the element in the DOM.