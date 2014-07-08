---
layout: post
title: "CSS : Hide up/down arrows in number field"
excerpt: "CSS : Hide up/down arrows in number field"
date: 2014-07-09 00:00:00 IST
updated: 2014-07-09 00:00:00 IST
categories: css
tags: css
---


```css
  input[type='number'] {
    -moz-appearance:textfield;
  }

  input::-webkit-outer-spin-button,
  input::-webkit-inner-spin-button {
    /* display: none; <- Crashes Chrome on hover */
    -webkit-appearance: none;
    margin: 0; /* <-- Apparently some margin are still there even though it's hidden */
  }
```