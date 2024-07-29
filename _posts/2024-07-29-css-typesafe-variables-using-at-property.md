---
layout: post
title: "CSS: typesafe variables using @property"
excerpt: "css variables defined using @property can give more context and better errors in devtools"
date: 2024-07-29 13:56 CEST
updated: 2024-07-29 17:56 CEST
categories: css
tags:
- css
image: "/assets/images/css-at-property/at-propery-in-devtools.webp"
---
CSS [@property][0]{: rel='nofollow' target="_blank"} allows developers to define variables with type checking and constraining, initial value and inherit rules. 


```css
@property --custom-variable {
  syntax: '<color>';
  inherits: false;
  initial-value: #000;
}
```

If we define a CSS variable without `@propery`, browser developer tools won't give any feedback for the wrong values, 

{: style="text-align: center"}
![normal variable with error has no indicator in devtools](/assets/images/css-at-property/normal-variable-with-error.webp){: style='width: 50%'}

instead, if we use `@property` like

```css
@property --container-border-color {
  syntax: '<color>';  
  inherits: true;  
  initial-value: #000;
}
```

and if we provide a wrong value dev tools can help us with proper error indicators

{: style="text-align: center"}
![@property shows proper error in devtools](/assets/images/css-at-property/at-property-with-error.webp){: style='width: 100%'}


Hovering on the variables on devtools will give us more context as well. 

{: style="text-align: center"}
![at property shows more context in devtools](/assets/images/css-at-property/at-propery-in-devtools.webp){: style='width: 50%'}

Hope that was helpful.   
Thank You.

[0]: https://developer.mozilla.org/en-US/docs/Web/CSS/@property