---
layout: post
title: 'css: safe alignment of flex-items'
excerpt: How to safely align a flex-items in case of overflow
date: 2025-06-04 00:23 CEST
updated: 2025-06-04 00:23 CEST
categories: css
tags:
- css
image: "/assets/images/css-safe-center/css-safe-center.webp"
---
The simple way to center a flex item is using `center` for `justify-content` or `align-content`. 

When we use `center` with dynamic flex items, there is a chance of data loss when the items overflow the alignment container.
 
## <a class="anchor" name="safe-alignment" href="#safe-alignment"><i class="anchor-icon"></i></a>Safe alignment

To avoid the data loss when the items overflow, we can use the `safe` keyword along with `center`

```css
justify-content: safe center 
```

Now this will help us center the items when there is no overflow and it will use `start` when the flex-items start overflowing. 

This will help us prevent the data loss.

{: style="text-align: center"}
![css safe center alignment](/assets/images/css-safe-center/css-safe-center.webp){: style='width: 100%'}

## <a class="anchor" name="using-with-tailwindcss" href="#using-with-tailwindcss"><i class="anchor-icon"></i></a>using with tailwindcss

In case if we want to safe alignment with tailwind `justify-center-safe` and `justify-end-safe`.

Hope this is helpful.

Versions of Language/packages used in this post.

| Library/Language | Version |
| ---------------- | ------- |
| tailwind         | 4.1     |
|                  |         |
