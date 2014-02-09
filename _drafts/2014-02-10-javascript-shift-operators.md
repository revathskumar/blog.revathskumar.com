---
layout: post
title: "JavaScript : shift operators"
date: 2014-02-10 2:17:00 IST
updated: 2014-02-10 2:17:00 IST
categories: javascript
---

Shift operators were always confusing for me. So I thought of revising old lessons like converting numbers to binary, shift operators, etc.. once again.

So here I am gona address 3 operators, which are

* >> (Signed right shift)
* << (Signed left shift)
* >>> (Unsigned right shift)

These are the one of the first lessons which I learned when I started learning computing. For the easiness I am using only 8 bits for an integer.

# >> (Signed right shift)
On `10 >> 1`, here 10 is converted to binary as `00001010` and shit the bits 1 position to the right. Which results `00000101` equalant of 5 in decimal.

On `-10 >> 1`, -10 is converted to binary as `10001010` and when shifts to 1 position to right it becomes `10000101` which is equalant to -5. 

# << (Signed left shift)
On `10 << 1`, here the difference is, it shift the bits 1 posision to its left. which results `00010100` equalant of 20 in decimal. On -10, in the same way after shift it become `10010100` equalant to -20

# >>> (Unsigned right shift)
On `10 >>> 1`, here the processing of positive integers are same the `>>` (right shift) but bit different for the negative numbers.

On `-10 >>> 1`, here first the `00001010` is shift to 1 position to the right which results `00000101`, then since its **negative** it will **not** the `00000101` and results `11111010` hence the result will be 123. 
