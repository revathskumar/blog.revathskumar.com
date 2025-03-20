---
layout: post
title: 'Deno : url.domainToASCII behaves differently from nodejs'
excerpt: 'Deno : url.domainToASCII behaves differently from nodejs'
date: 2025-03-19 19:17 CEST
updated: 2025-03-19 19:17 CEST
categories: javascript
tags: deno nodejs
image: ''
---
While working with `@fedify/fedify` today, I came across a bug where the `.well-known/webfinger` [route was returning `404`](https://github.com/fedify-dev/fedify/issues/218).  

After some debugging and chatting with the `@fedify/fedify` team, I realised that this problem only happened when used with Node.js.    

Finally, after hours of debugging, I was able to identify the root cause as the behaviour of the `url.domainToASCII`.

```js
import { domainToASCII } from 'node:url  
console.log(domainToASCII("localhost:8000"));  
console.log(domainToASCII("example.com:8000"));  
```  

In deno, the hostname with port number (e.g.: `example.com:8000`) is considered valid input and returns the string as `example.com:8000`.  

But in Node.js & Bun, `domainToASCII` will consider `example.com:8000` as invalid input and return the empty string.

Below is the tabular form of return value of `domainToASCII("example.com:8000")` in various runtimes.

|  | return value             |
| ---------- | ------------------ |
| Deno       | `exmaple.com:8000` |
| Node.js    | `<empty string>`   |
| Bun        | `<empty string>`   |
{: style="width:100%"}

Hope this is Helpful.   


Versions of Language/packages used in this post.
  
| Library/Language | Version |
| ---------------- | ------- |
| Deno             | 2.2.4   |
| Node.js          | v23.3.0 |
| Bun              | 1.2.5   |
