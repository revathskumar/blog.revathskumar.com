---
layout: post
title: 'JavaScript : String.length is not the count of characters'
excerpt: 'In JavaScript, `String.length` does not represent the count of characters.
  Rather they represent the count of codepoints. '
date: 2022-08-31 12:00 +0530
updated: 2022-08-31 12:00 +0530
categories: javascript
tags: javascript
---
In JavaScript, `String.length` does not represent the count of characters. Rather they represent the count of codepoints. 
Since the normal characters can be represented using single codepoints, in most cases we get `String.length` is the same as the count of characters.

But as we start using [unicode characters][unicode], which uses more than one codepoint to represent a single character, we start getting wrong character counts. 

For Eg. `"💊".length` will provide the length as `2`. 

{: style="text-align: center"}
![unicode length](/assets/images/string_length/unicode_length.webp)

So, How do we find the correct character length when unicode characters are involved? 


## <a class="anchor" name="using-spread-operator" href="#using-spread-operator"><i class="anchor-icon"></i></a>Using spread operator


The easiest way to find the character length is to convert the string into an array using the spread operator and then find the length of the array

```js
[...`💊💊💊💊`].length  // 4
```

{: style="text-align: center"}
![using spread operator](/assets/images/string_length/using_spread_operator.webp)

Hope that helped.   
Thank You.


[unicode]: {% post_url 2014-11-28-unicode %}