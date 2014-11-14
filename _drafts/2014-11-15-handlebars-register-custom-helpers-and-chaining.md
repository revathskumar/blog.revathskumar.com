---
layout: post
title: "handlebars.js : Register custom helpers and chaining"
excerpt: "handlebars.js : Register custom helpers and chaining11"
date: 2014-11-15 00:00:00 IST
updated: 2014-11-15 00:00:00 IST
categories: javascript, handlebars
---

[Handlebars.js](https://github.com/wycats/handlebars.js) won't allow you do any data manipulation from the view. So if you didn't use presenter or manipulated data for view you will be in trouble. One way you can get though this is defining custom helpers for data manipulation. I personaly prefer not to use lot of helpers and use only if you can't avoid.

## Register Helper

```js
Handlebars.registerHelper('total_price', function(price, quantity) {
  total = price;
  if(typeof quantity == "number") {
    total = price * quantity;
  }
  return total;
});
```

Now you can use this as


```js
<span>{{ total_price this.product.price this.quantity }}</span>
```

## Chaining helpers

Handlebars won't allow you to chain the helpers. And as per the [@wycats](https://github.com/wycats/), He doesn't have any [plan to support in the future](https://github.com/wycats/handlebars.js/issues/304#issuecomment-8416546). But some handlerbars fans have done some workarounds to support this.

```js
// https://github.com/wycats/handlebars.js/issues/304#issuecomment-15635762

Handlebars.registerHelper('chain', function () {
    var helpers = [], value;
    $.each(arguments, function (i, arg) {
        if (Handlebars.helpers[arg]) {
            helpers.push(Handlebars.helpers[arg]);
        } else {
            value = arg;
            $.each(helpers, function (j, helper) {
                value = helper(value, arguments[i + 1]);
            });
            return false;
        }
    });
    return value;
});
```

which can be used by 

```js
{{chain "taxAdd" "formatPrice" this.product.price}}
```

You can see the detailed discussion over [wycats@handlebars.js#304](https://github.com/wycats/handlebars.js/issues/304)