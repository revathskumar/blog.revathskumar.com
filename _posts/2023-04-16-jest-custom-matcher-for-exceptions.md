---
layout: post
title: 'Jest : custom matcher for exceptions'
excerpt: A custom matcher to jest to test against the exception details
date: 2023-04-16 16:00:00 CEST
updated: 2023-04-16 16:00:00 CEST
categories: jest
tags: jest, testing
---
As of now jest matcher `toThrow` help us to match only the Exception class or the error message. 

If we want to do any matching against the custom details on the error instance, we have to use `try...catch` and assign the error to a variable and do expect manually like below


```js
let err: ValidationError;

try {
    await validatorDto(/* params */);
} catch (error) {
    err = error;
}

expect(err.details).toEqual(
    expect.arrayContaining([
        expect.stringMatching(/currencycode must be a valid/i),
    ]),
);
```

In this blog, I will explain on how we can create a custom matcher to make this simple  

First we will start with creating a `setupAfterEnv.ts` file and add it to `setupFilesAfterEnv` in jest config.

```json
// jest.config.js or package.json
{
    // other configs

    "setupFilesAfterEnv": [
      "<rootDir>/test/setupAfterEnv.ts"
    ]
}
```

You can make changes to the paths based on your jest configuration of `rootDir` and path to your `setupAfterEnv.ts` file.

Now let's use `expect.extend` to add our custom matcher method. 

```js
//  test/setupAfterEnv.ts

expect.extend({
  async toThrowWithErrorMessage(received, expected) {
    let err: { details: string[] };

    try {
      await received();
    } catch (error) {
      err = error;
    }

    if (this.isNot) {
      expect(err.details).not.toEqual(
        expect.arrayContaining([expect.stringMatching(expected)]),
      );
    } else {
      expect(err.details).toEqual(
        expect.arrayContaining([expect.stringMatching(expected)]),
      );
    }
    return {
      pass: !this.isNot,
      message: () => '',
    };
  },
});
```

In the above custom matcher, we assume that all our custom `Error` instances will hold the messages in the `.details` property.  


Next, let's add types so the typescript won't complain about your new custom matcher.   

```js
// index.d.ts

declare namespace jest {
  interface Matchers<R> {
    toThrowWithErrorMessage: (received: any) => void;
  }
  interface Expect {
    toThrowWithErrorMessage: (received: any) => void;
  }
}
```

Here is how we use the new custom matcher,  

```js
it('should throw error with error message', async () => {
  return expect(async () => {
    await validatorDto(Dto, {});
  }).toThrowWithErrorMessage(/name should not be empty/i);
});
```

Hope that Helped.   
if you have any suggestions or improvement, please drop a line to me over email


    Versions of Language/packages used in this post.

    | Library/Language | Version |
    | ---------------- |---------|
    |      Jest        |  28.1.2 |
    |   TypeScript     |   4.9.5 |
    