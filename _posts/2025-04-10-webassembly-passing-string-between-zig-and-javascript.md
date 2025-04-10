---
layout: post
title: webassembly - passing string between zig and javascript
excerpt: webassembly - passing string between zig and javascript
date: 2025-04-10 14:08 CEST
updated: 2025-04-10 14:08 CEST
categories: webassembly
tags: zig, javascript
image:
---
When working with webassembly (wasm) we only have numeric values.

This means that if we need to handle strings, we need to handle them in raw binary data format using `TypedArray` & `ArrayBuffer`.

If we want to pass complex data types between the web assembly (wasm) and the host JavaScript environment, we pass the memory pointer to shared memory and a length data.

In this blog post we will learn how to pass a string between zig & JS host environment and vice versa. 

For this blog post, we are using zig to compile into webassembly. we are not using any additional library or any compiler options so, we have to write the glue code to communicate between the wasm and JS. 

## <a class="anchor" name="response" href="#passing-string-from-wasm-to-js"><i class="anchor-icon"></i></a>Passing string from wasm to JS

First we will look at passing a string from wasm to JS.

We will start by defining an external function called print, which will be provide the functionality to output the string based on the host environment.

Next, we will define a simple function that defines a string (slice), and call the print function.

```c
// string_from_wasm.zig
extern fn print(message: [*]const u8, length: u64) void;

export fn hello() void {
    const message: []const u8 = "Hello from Zig!";
    print(message.ptr, message.len);
}
```

Now let's compile this into wasm.

```sh
zig build-exe src/string_from_wasm.zig -target wasm32-freestanding -fno-entry --export=hello
```

Since we are using `wasm32-freestanding` as the target, we need to provide the `print` function when loading the Wasm module with Node.js.


To define a `print` function, we first need to decode the string using the arguments passed, the memory pointer, and the length of the string. 

```js
// string_from_wasm.mjs
import { readFile } from "node:fs/promises"

const source = await readFile("./string_from_wasm.wasm");
const typedArray = new Uint8Array(source);

const waResult = await WebAssembly.instantiate(typedArray, {
  env: {
    print: (pointer, length) => { 
      const slice = new Uint8Array(mem.buffer, pointer, Number(length))
      const message = new TextDecoder().decode(slice);
      console.log("Message from Zig : ", message); 
    }
  }
});

let mem = waResult.instance.exports.memory;
const { hello } = waResult.instance.exports;

hello();
```

Now, Let run this code using nodejs. 

```sh
node string_from_wasm.mjs
# Message from Zig :  Hello from Zig!
```

## <a class="anchor" name="response" href="#passing-string-from-js-to-wasm"><i class="anchor-icon"></i></a>Passing string from JS to wasm

Let's look at passing a string from JS to wasm.

Since we are managing the memory manually, we need to export functions to allocate and free the memory.

For the purpose of this blog post, we will use the `std.heap.wasm_allocator` from zig. 


```c
# string_to_wasm.zig
const std = @import("std");
const allocator = std.heap.wasm_allocator;

extern fn print(message: [*]const u8, length: u64) void;

export fn allocUint8(length: u32) [*]const u8 {
    const slice = allocator.alloc(u8, length) catch
        @panic("failed to allocate memory");
    return slice.ptr;
}

export fn free(pointer: [*:0]u8) void {
    allocator.free(std.mem.span(pointer));
}

export fn helloName(name: [*:0]const u8) void {
    const nam = std.mem.span(name);
    
    const message: []const u8 = std.fmt.allocPrint(allocator, "Hello {s}", .{nam}) catch unreachable;
    print(message.ptr, message.len);
}
```

Let's compile this to wasm

```sh
zig build-exe src/string_to_wasm.zig -target wasm32-freestanding -fno-entry --export=helloName --export=allocUint8 --export=free
```

Now, in JS, we can use `allocUint8` to allocate memory and pass the pointer of a null-terminated string to the `helloName` function. Later, we can use `free` to free up the allocated memory.

```js
// string_to_wasm.mjs
import { readFile } from "node:fs/promises"

const source = await readFile("./string_to_wasm.wasm");
const typedArray = new Uint8Array(source);

const waResult = await WebAssembly.instantiate(typedArray, {
  env: {
    print: (pointer, length) => { 
      const slice = new Uint8Array(mem.buffer, pointer, Number(length))
      const message = new TextDecoder().decode(slice);
      console.log("Message from Zig : ", message); 
    }
  }
});

const stringToPointer = (string) => {
  const buffer = new TextEncoder().encode(string);
  const pointer = allocUint8(buffer.length + 1); // ask Zig to allocate memory
  const slice = new Uint8Array(
    mem.buffer, // memory exported from Zig
    pointer,
    buffer.length + 1
  );
  slice.set(buffer);
  slice[buffer.length] = 0; // null byte to null-terminate the string
  return pointer;
};


let mem = waResult.instance.exports.memory;
const { helloName, allocUint8, free } = waResult.instance.exports;

const str = stringToPointer("JS-String")

helloName(str);
free(str)
```

Now, when we run this code using nodejs. 

```sh
node string_to_wasm.mjs
# Message from Zig :  Hello JS-String
```

Some Helpful links

* [std.heap.wasm_allocator](https://ziglang.org/documentation/0.14.0/std/#std.heap.wasm_allocator) 
* [std.mem.span](https://ziglang.org/documentation/0.14.0/std/#std.mem.span)

Hope this is helpful.


Versions of Language/packages used in this post.

| Library/Language | Version |
| ---------------- | ------- |
| Zig              | 0.14    |
| Node             | 23.10   |