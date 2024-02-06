---
layout: post
title: 'React : Testing file upload using testing library'
excerpt: Testing file upload using upload method in @testing/library/user-event
date: 2024-02-06 18:11 CEST
updated: 2024-02-06 18:11 CEST
categories: react, jest, testing
tags: react, testing
image: ''
---
In this post, we will look into writing a test case for file upload using the React testing library

## <a class="anchor" name="select-accepted-file-type" href="#select-accepted-file-type"><i class="anchor-icon"></i></a> Select accepted file type 

In order to simulate file upload in test case, we will be using `upload` method from `@testing-library/user-event`.

`upload` method will accept input element as the first argument and [File][file] object as the second.


```jsx
import userEvent from '@testing-library/user-event';
import { render, screen } from '@testing-library/react';


test("select accepted file", async () => {
  const user = userEvent.setup();
  render(
    <>
      <label htmlFor='file'>Select file</label>
      <input type="file" name='file' id="file" accept='text/csv' />
    </>
  );

  const fileInput = screen.getByLabelText(/Select file/i);
  const content = '';

  const file = new File([str], 'upload.csv', {
    type: 'text/csv',
  });

  await user.upload(fileInput, file);
  expect(fileInput.files[0]).toBe(file)
  expect(fileInput.files[0].size).toBe(0)
});
```


## <a class="anchor" name="select-unaccepted-file-type" href="#select-unaccepted-file-type"><i class="anchor-icon"></i></a> Select unaccepted file type

In the below example, the input element will accept only `text/csv` file, but in the test case for validation, we should be able to select non CSV file. 

In order to do this, we need to pass `{applyAccept: false}` to `userEvent.setup` method. By default, `applyAccept` is true.

```jsx
import userEvent from '@testing-library/user-event';
import { render, screen } from '@testing-library/react';

test("select unaccepted file", async () => {
  const user = userEvent.setup({applyAccept: false});
  render(
    <>
      <label htmlFor='file'>Select file</label>
      <input type="file" name='file' id="file" accept='text/csv' />
    </>
  );

  const fileInput = screen.getByLabelText(/Select file/i);
  const content = '{}';

  const file = new File([content], 'upload.json', {
    type: 'application/json',
  });

  await user.upload(fileInput, file);
  expect(fileInput.files[0]).toBe(file)
  expect(fileInput.files[0].size).toBe(2)
});
```

## <a class="anchor" name="select-multiple-files" href="#select-multiple-files"><i class="anchor-icon"></i></a> Select multiple files

To select multiple files in the test case, we can pass an array of file object as second argument to  `upload` method

```jsx
import userEvent from '@testing-library/user-event';
import { render, screen } from '@testing-library/react';


test("select mulitple file", async () => {
  const user = userEvent.setup();
  render(
    <>
      <label htmlFor='file'>Select file</label>
      <input type="file" name='file' id="file" accept='text/csv' multiple />
    </>
  );

  const fileInput = screen.getByLabelText(/Select file/i);
  const content0 = '';

  const file0 = new File([content0], 'upload0.csv', {
    type: 'text/csv',
  });

  
  const file1 = new File(['a,b,c'], 'upload1.csv', {
    type: 'text/csv',
  });

  await user.upload(fileInput, [file0,file1]);

  expect(fileInput.files[0]).toBe(file0)
  expect(fileInput.files[0].size).toBe(0)

  expect(fileInput.files[1]).toBe(file1)
  expect(fileInput.files[1].size).toBe(5)
});
```

Hope that helped.  
Happy coding.  
  

Versions of Language/packages used in this post.

  
| Library/Language | Version |
| ---------------- |---------|
| @testing-library/react | 14.2.1 |
| @testing-library/user-event | 14.5.2 |


[file]: https://developer.mozilla.org/en-US/docs/Web/API/File