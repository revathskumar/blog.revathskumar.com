---
layout: post
title: 'jest : module mocking in es modules'
excerpt: 'jest : module mocking in es modules'
date: 2024-07-14 11:40 CEST
updated: 2024-07-14 11:40 CEST
categories: jest
tags:
- jest
---
When using CommonJS module system, we can `jest.mock` to mock the modules or functions. with `jest.mock` the mock statement will be hoisted automatically so we don't need to worry about the import orders. 

But when it comes to ES Modules,  we have to use the `jest.unstable_mockModule`
This comes with 2 major differences

1. it doesn't hoist the mock statements
2. factory method as second param is mandatory

Since `jest.unstable_mockModule` doesn't hoist automatically, we have to import modules or function using dynamic `import()` after `jest.unstable_mockModule`.

## <a class="anchor" name="set-up-jest-for-esm" href="#set-up-jest-for-esm"><i class="anchor-icon"></i></a>Set up jest for ESM

Jest by default transform the code to CommonJS, to avoid this when we use ESM, we configure the `transform` option to `{}` (empty object).


```javascript
"jest": {
  "transform": {}
}
```

And when we run the test, we need to use `--experimental-vm-modules` option with node.

```json
{
  "scripts": {
    "test": "node --experimental-vm-modules node_modules/jest/bin/jest.js"
  }
}
```

we can also use `NODE_OPTIONS='--experimental-vm-modules' npx jest`
## <a class="anchor" name="response" href="#"><i class="anchor-icon"></i></a>Mocking ES Modules 

For mocking we can take a small example

```js
// utils.js

import * as fs from "node:fs/promises";

export const readName = async () => {
  const content = await fs.readFile("package.json", "utf8");
  return JSON.parse(content).name;
};
```

In order to test the `readName` method we can try to mock `fs.readFile`. 

```js
// utils.test.js

jest.unstable_mockModule("node:fs/promises", async () => ({
  readFile: jest.fn(),
}));

const { readName } = await import("./utils");
const { readFile } = await import("node:fs/promises");

describe("index", () => {
  test("read name", () => {
    readFile.mockResolvedValue(JSON.stringify({'name': 'mock'}));
    return expect(readName()).resolves.toBe("mock");
  });
});

```

You can find the example repo on [revathskumar/jest-mock-in-esm](https://github.com/revathskumar/jest-mock-in-esm)

## <a class="anchor" name="in-typescript" href="#in-typescript"><i class="anchor-icon"></i></a>In TypeScript

When using with TypeScript you might need to add the signature for `unstable_mockModule` into project's declaration file. 

```ts
// index.d.ts

declare namespace jest {
  function unstable_mockModule<T = unknown>(moduleName: string, factory?: () => T, options?: MockOptions): typeof jest;
}
```


Hope that was helpful. 

Versions of Language/packages used in this post.

  
| Library/Language | Version |
| ---------------- | ------- |
| Jest             | 29.7.0  |
