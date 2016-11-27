---
layout: post
title: 'JavaScript : Proper way to use done() while testing promises with mocha'
excerpt: "JavaScript : Proper way to use done() while testing promises with mocha"
date: 2016-11-27 00:00:00 IST
updated: 2016-11-27 00:00:00 IST
categories: javascript, promises
tags: javascript, promises
image: 'http://i653.photobucket.com/albums/uu253/revathskumar/Coderepo/2016/11/Screenshot%20from%202016-11-27%2022-23-48_zpsgqrcxsds.png'
---

While testing asyncronous code, especially `Promises`, I seen that many people are using
`done()` method in wrong way. This post tries to guide you how to do it in proper way.

Conside we are going to test a piece of code which fetches data asynchronously.

~~~ js
// api.js
require('whatwg-fetch');

module.exports = class ApiClient {
  static get(url) {
    return fetch(url)
      .then(res => {
        return res.json();
      })
      .catch(err => {
        throw err;
      });
  }
}
~~~


~~~ js
// index.js
const ApiClient = require('./api');

module.exports = function getUsers() {
  return ApiClient.get('http://jsonplaceholder.typicode.com/users')
};
~~~

Now when we try to write a simple test for `getUsers` it will look like

~~~ js
// test.js
const getUsers = require('./index');
const ApiClient = require('./api');
const sinon = require('sinon');
const expect = require('chai').expect;

describe('getUsers', () => {
  context('on success', () => {
    it('returns user data', (done) => {
      const getSpy = sinon.stub(ApiClient, 'get').returns(Promise.resolve([
        {id: 1, name: 'Leanne Graham'},
        {id: 2, name: 'Ervin Howell'}
      ]));

      getUsers().
        then((res) => {
          expect(res).to.eql([
            {id: 1, name: 'Leanne Graham'},
            {id: 2, name: 'Ervin Howell'}
          ]); 
          done();
        })  
    }); 
  }); 
});
~~~

The above test will work fine and show the test passing, But calling `done()` in the same `then` callback is a bad idea.

**Why?**

The above code works well until your expectation fails, consider the above code with wrong expectation

~~~ diff
// test.js
const getUsers = require('./index');
const ApiClient = require('./api');
const sinon = require('sinon');
const expect = require('chai').expect;

describe('getUsers', () => {
  context('on success', () => {
    it('returns user data', (done) => {
      const getSpy = sinon.stub(ApiClient, 'get').returns(Promise.resolve([
        {id: 1, name: 'Leanne Graham'},
        {id: 2, name: 'Ervin Howell'}
      ]));

      getUsers().
        then((res) => {
          expect(res).to.eql([
            {id: 1, name: 'Leanne Graham'},
-            {id: 2, name: 'Ervin Howell'}
+            {id: 2, name: 'Ervin Howel'}
          ]); 
          done();
        })  
    }); 
  }); 
});
~~~

This will throw some error like below. 

![Error 1](http://i653.photobucket.com/albums/uu253/revathskumar/Coderepo/2016/11/Screenshot%20from%202016-11-27%2022-22-36_zpsxvu1kuqh.png)

The above failure is not very useful for programmers, Mocha is well equiped to show better error than this. If we want to utilize the 
mocha's error we shouldn't call `done()` from the same `then()` callback. See the below test

~~~ diff
// test.js
const getUsers = require('./index');
const ApiClient = require('./api');
const sinon = require('sinon');
const expect = require('chai').expect;

describe('getUsers', () => {
  context('on success', () => {
    it('returns user data', (done) => {
      const getSpy = sinon.stub(ApiClient, 'get').returns(Promise.resolve([
        {id: 1, name: 'Leanne Graham'},
        {id: 2, name: 'Ervin Howell'}
      ]));

      getUsers().
        then((res) => {
          expect(res).to.eql([
            {id: 1, name: 'Leanne Graham'},
            {id: 2, name: 'Ervin Howel'}
          ]); 
        })
+       .then(() => done(), done);
    }); 
  }); 
});
~~~

Now see the difference in the mocha's failure message with actual and expected diff. 

![Better Error]({{ page.image }})

Isn't this error message better for programmers to debug the failure. 

