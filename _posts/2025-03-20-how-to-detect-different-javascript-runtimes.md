---
layout: post
title: How to detect different JavaScript runtimes
excerpt: How to detect different JavaScript runtimes
date: 2025-03-20 17:11 CEST
updated: 2025-03-20 17:11 CEST
categories: javascript
tags: nodejs bun deno kiesel
image: ''
---
As more and more JavaScript runtimes become popular, and each runtime has some subtle [differences in how modules/functions behave](/2025/03/deno-url-domainToASCII-behaves-differently-from-nodejs.html),

if we want to support our JavaScript code in these runtimes, we should be able to detect the runtime.

Ideally we should check the supported feature, instead of the runtimes, but in case if we want to detect the runtimes themselves,

here are the checks we can do

```ts
if (globalThis.Bun) {
  // bun 
}

if (globalThis.Deno) {
  // deno
}

if(globalThis.Kiesel) {
  // Kiesel
}
```

For `Node.js`, we can try

```ts
globalThis.process?.release?.name // returns node
```

But the caveat here is `Bun` & `Deno` will return `"node"` for `globalThis.process?.release?.name`, so we should use this along with the other checks above.  

Hope this is helpful.



