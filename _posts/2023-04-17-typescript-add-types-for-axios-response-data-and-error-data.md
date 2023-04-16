---
layout: post
title: 'TypeScript: add types for axios response data and error data'
excerpt: 'TypeScript: add types for axios response data and error data'
date: 2023-04-17 00:00:00 CEST
updated: 2023-04-17 00:00:00 CEST
categories: typescript
tags: axios, typescript
image: "/assets/images/types_for_axios_data/type_for_response.webp"
---
When using `axios` with TypeScript, one major problem we face is the types for the response data and error data. 

Consider the below function, which uses `axios.post`

```ts
async function postHello() {
  try {
    const response = await axios.post('/hello', {});
    console.log(response.data);
  } catch (error) {
    console.log(error.response.data.status);
  }
}
```

In the above function, the type of data will be `any` which can't ensure the type safety. 

To avoid this situation, we can provide the axios with our custom type for the response data and error data. 

## <a class="anchor" name="response" href="#response"><i class="anchor-icon"></i></a>Add type for response data

First, let's look into the Response data.

```ts

type PostHelloResponseType = {
  status: string;
  id: number;
};

async function postHello() {
  try {
    const response = await axios.post<PostHelloResponseType>('/hello', {});
    console.log(response.data.status);
  } catch (error) {
    console.log(error.response.data.status);
  }
}
```

We defined `PostHelloResponseType` for the expected response and pass it to `axios.post`.

Now, when we the `response.data` will have the type `PostHelloResponseType`

{: style="text-align: center"}
![type for response data](/assets/images/types_for_axios_data/type_for_response.webp){: style='width: 100%'}

And TS will throw error if we try to use a non-existing key like `response.data.stats`.

{: style="text-align: center"}
![TS throw error on non-existing key](/assets/images/types_for_axios_data/ts_error.webp){: style='width: 100%'}

Next, we will look into error data type.

## <a class="anchor" name="error" href="#error"><i class="anchor-icon"></i></a>Add type for error data

In TS, the error we receive in `try...catch` block will always have type `unknown`.  
So we won't be able to assign type in `catch` instead we have to define new variable.  

```ts
import axios, { AxiosError, isAxiosError } from 'axios';

type PostHelloErrorType = {
  status: string;
  message: string;
  type: string;
  errors: string[];
};

async function postHello() {
  try {
    // call axios methods
  } catch (error) {
    if (isAxiosError(error)) {
      const err: AxiosError<PostHelloErrorType> = error;
      console.log(err.response.data.message);
    }
  }
}
```

Now we have type safety for the error data.

{: style="text-align: center"}
![type for error data](/assets/images/types_for_axios_data/type_for_error.webp){: style='width: 100%'}

Happy coding.  