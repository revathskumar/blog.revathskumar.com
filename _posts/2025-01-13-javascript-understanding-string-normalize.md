---
layout: post
title: "JavaScript : understanding string normalize"
excerpt: "JavaScript : understanding string normalize and different normalization forms"
date: 2025-01-13 10:16 CEST
updated: 2025-01-21 12:16 CEST
categories: javascript
tags: javascript unicode string
image: ""
---

> Visualize different string normalization forms using [string-normalize.surge.sh/?str=öé+ﬀ](https://string-normalize.surge.sh/?str=%C3%B6%C3%A9+%EF%AC%80)

Recently, When I was working on enhancing the search of [Bender](https://github.com/revathskumar/bender), I wanted to search words with characters like `"ö"` or `"é"` using normal characters like `o` and `e`. 
While looking into handling this case, I came across `String.prototype.normalize` 

`String.prototype.normalize` supports 4 types of normalization

* [NFC](#nfc)  : canonical composed
* [NFD](#nfd) : canonical decomposed
* [NFKC](#nfkc) : compatible composed
* [NFKD](#nfkd) : compatible decomposed

Based on our use case, we should be able to choose which normalization we should use.
NFC is the default normalization form, if we omit the argument.

Before getting into each normalization form, let us see what is unicode composed and decomposed form. 

## <a class="anchor" name="composed-and-decomposed-forms" href="#composed-and-decomposed-forms"><i class="anchor-icon"></i></a>Composed & decomposed forms

Some unicode characters can be represented in both composed and decomposed forms.  
For example, `"ö"` can be represented in composed form by `\u00F6` and in the decomposed form it can be represented by `\u006F` (o) and `\u0308` ([Combining Diaeresis](https://www.compart.com/en/unicode/U+0308)).

```js
const composed = "\u00F6";
const decomposed = "\u006F\u0308"

console.log(composed); // ö
console.log(composed.length); // 1

console.log(decomposed); // ö 
console.log(decomposed.length); // 2
```

In order to show the difference I will use `"Köln ﬀ"` (`ﬀ = U+FB00`) as sample string and perform all 4 normalization form.

## <a class="anchor" name="nfc" href="#nfc"><i class="anchor-icon"></i></a>NFC

* default normalization form
* use canonical equivalent character
* uses composed form (single codepoint)
* won't change the visual appearance
* won't be able to produce or find the string based on compatible chars

```js
const str = 'Köln ﬀ';
const normalizedStr = str.normalize('NFC');

console.log(str); // Köln ﬀ
console.log(str.length); // 6

console.log(normalizedStr); // Köln ﬀ
console.log(normalizedStr.length); // 6

console.log(normalizedStr.includes('o')) // false
console.log(normalizedStr.indexOf('o')) // -1

console.log(normalizedStr.includes('f')) // false
console.log(normalizedStr.indexOf('f')) // -1
```

## <a class="anchor" name="nfd" href="#nfd"><i class="anchor-icon"></i></a>NFD

* use canonical equivalent character
* uses decomposed form (multiple codepoints)
* won't change the visual appearance
* won't be able to produce or find the string based on compatible chars

```js
const str = 'Köln ﬀ';
const normalizedStr = str.normalize('NFD');

console.log(str); // Köln ﬀ
console.log(str.length); // 6

console.log(normalizedStr); // Köln ﬀ
console.log(normalizedStr.length); // 7 (only ö get decomposed into \u006F and \u0308

console.log(normalizedStr.includes('o')) // true
console.log(normalizedStr.indexOf('o')) // 1

console.log(normalizedStr.includes('f')) // false
console.log(normalizedStr.indexOf('f')) // -1
```

## <a class="anchor" name="nfkc" href="#nfkc"><i class="anchor-icon"></i></a>NFKC

* use compatible equivalent character 
* uses composed form (single codepoint)
* changes the visual appearance
* able to produce or find the string based on compatible chars

```js
const str = 'Köln ﬀ';
const normalizedStr = str.normalize('NFKC');

console.log(str); // Köln ﬀ
console.log(str.length); // 6

console.log(normalizedStr); // Köln ff (ﬀ got converted into ff)
console.log(normalizedStr.length); // 7 (ö in the composed form, but ﬀ got converted into ff)

console.log(normalizedStr.includes('o')) // false
console.log(normalizedStr.indexOf('o')) // -1

console.log(normalizedStr.includes('f')) // true 
console.log(normalizedStr.indexOf('f')) // 5
```

## <a class="anchor" name="nfkd" href="#nfkd"><i class="anchor-icon"></i></a>NFKD

* use compatible equivalent character 
* uses decomposed form (multiple codepoints)
* changes the visual appearance
* able to produce or find the string based on compatible characters

```js
const str = 'Köln ﬀ';
const normalizedStr = str.normalize('NFKD');

console.log(str); // Köln ﬀ
console.log(str.length); // 6

console.log(normalizedStr); // Köln ff (ﬀ got converted into ff)
console.log(normalizedStr.length); // 8 (ö is decomposed and ﬀ got converted into ff)

console.log(normalizedStr.includes('o')) // true
console.log(normalizedStr.indexOf('o')) // 1

console.log(normalizedStr.includes('f')) // true 
console.log(normalizedStr.indexOf('f')) // 5
```

## <a class="anchor" name="conclusion" href="#conclusion"><i class="anchor-icon"></i></a>Conclusion

Since we now understood all the normalization forms, we can make an informed decision on which normalization form to use for our usecase. 

If we want to compare string or compare length of strings, we can normalize both strings using `NFC` or `NFD` before comparing. 

If we want to search a string using compatible characters and canonical equivalent characters, the best option is to use `NFKD` normalization. `NFKD` normalized string may not be suitable for display, as it will visually change the character.

Hope this is Helpful.  
If I have made a mistake or missed something, please feel free to email me.

References:
* [MDN: String.prototype.normalize()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/normalize) 