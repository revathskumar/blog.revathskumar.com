---
layout: post
title: "Redux : testing a simple component"
excerpt: "Redux : testing a simple component"
date: 2016-02-19 00:00:00 IST
updated: 2016-02-19 00:00:00 IST
categories: javascript
tags: redux
---

In my last post on [redux : using with vanilla js](/2016/02/redux-using-with-vanilla-js.html) we created a simple counter. In this post let's see how we can test the compomponent as well as redux actions. For testing I will be using [mocha](http://mochajs.org/) testing framework and for assertion [expect.js](https://github.com/LearnBoost/expect.js).

For my last post the counter module will look like 

~~~ js
import {createStore} from 'redux';

// reducer 
function counter(state=0, action) {
  console.log('counter', action)
  switch(action.type) {
    case 'INCREMENT':
      return state + 1;
    case 'DECREMENT':
      return state - 1;
    default:
      return state;
  }
}


//actions
const increment = () => {
  return {
    type: 'INCREMENT'
  };
};

const decrement = () => {
  return {
    type: 'DECREMENT'
  };
};

//create store
const store = createStore(counter);

class Counter {
  constructor(options) {
    this.$el = options.el;
    this.store = options.store;
    store.subscribe(this.update.bind(this));
    this.$el.querySelector('#inc')
      .addEventListener('click', this.inc.bind(this));
    this.$el.querySelector('#dec')
      .addEventListener('click', this.dec.bind(this));
  }

  inc() {
    this.store.dispatch(increment())
  }

  dec() {
    this.store.dispatch(decrement())
  }


  update() { 
    console.log(store.getState());
    this.$el
      .querySelector('#text')
      .innerHTML = store.getState();
  }

  render() {
    this.update();
  }
}
~~~

For testing purpose, I will be adding a new dispatch type called "RESET".

~~~ diff
// reducer 
function counter(state=0, action) {
  switch(action.type) {
    case 'INCREMENT':
      return state + 1;
    case 'DECREMENT':
      return state - 1;
+    case 'RESET':
+      return 0;
    default:
      return state;
  }
}
~~~

Testing can be done in two parts, First unit test the actions then the `Counter` module.
In initial setup, we setup for `bdd` and will create a new store for test

~~~ js
mocha.ui('bdd');

const testStore = createStore(counter);

// our tests

mocha.run();
~~~

## Testing actions

~~~ js
// code for the component from first snippet

mocha.ui('bdd');

const testStore = createStore(counter);

describe('actions', () => {
  beforeEach(() => {
    testStore.dispatch({type: 'RESET'});
  });

  it('inc', () => {
    testStore.dispatch(increment());
    expect(testStore.getState()).toEqual(1);
  });

  it('dec', () => {
    testStore.dispatch(decrement());
    expect(testStore.getState()).toEqual(-1);
  })
});

mocha.run()
~~~