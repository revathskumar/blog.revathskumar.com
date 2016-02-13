---
layout: post
title: "JavaScript : Getting started with redux"
excerpt: "JavaScript : Getting started with redux"
date: 2016-02-13 00:00:00 IST
updated: 2016-02-13 00:00:00 IST
categories: javascript
tags: javascript, react, redux
---

This is planned as part 2 of [What I learned after buliding first web app with react]() post because I believe one of the biggest mistake I did was not investing much time in redux and went for states in components. Component states are difficult to manage and refactor.

Even though I heard of flux architecture and uni directional data flow long back I didn't really understand the concept and why we need it. But recently I got my hands on the redux and now I know why we shouldn't be using component level states in react application.

Redux help you to have a centralised store for data. So all the data related to you app will be holding in a object instead of holding in different components. 


## Action

Actions are simple JavaScript object which used to send data to application store. All action object should have a `type` key to define the action along with data to be changed in store if any.

~~~ js
{
  type: 'INCREMENT'
}
~~~

## Reducer

Reducers are the pure function which will change state and return new state. The only way to change state is to emit an action. 

```js
function counter(state=0, action) {
  switch(action.type) {
    case 'INCREMENT':
      return state + 1;
    case 'DECREMENT':
      return state - 1;
    default:
      return state;
  }
}
```
## Store

Store is the place where application state is holding. We can use the `createStore` from redux to create a new store using the reducer. The object returned from `createStore` will have 3 methods

* getState()  : Get the current application state
* dispatch()  : To dispatch an action to change the state
* susbcribe() : To listen to the state change

~~~ js
import {createStore} from 'redux';

const store = createStore(counter);

console.log(store.getState()) // logs 0

store.dispatch({
  type: 'INCREMENT'
});

console.log(store.getState()) // logs 1
~~~

## Using it with React

~~~ js
import React, {Component} from 'react';
import {createStore} from 'redux';

// reducer 
function counter(state=0, action) {
  switch(action.type) {
    case 'INCREMENT':
      return state + 1;
    case 'DECREMENT':
      return state - 1;
    default:
      return state;
  }
}

//create store
const store = createStore(counter);

// React Component
class Counter extends React.Component {
  increment() {
    this.props.store.dispatch({
      type: 'INCREMENT'
    });
  }
  decrement() {
    this.props.store.dispatch({
      type: 'DECREMENT'
    });
  }
  render() {
    return (<div>
      {this.props.store.getState()}
      <div>
        <button onClick={this.increment.bind(this)}>+</button>
        <button onClick={this.decrement.bind(this)}>-</button>
      </div>
    </div>
            )
  }
}
  
const render = () => {
  ReactDOM.render(<Counter store={store} />, document.getElementById('mount'));
};

store.subscribe(render);
render();
~~~ 

## Using `react-redux` bindings.

