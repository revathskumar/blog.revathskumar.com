---
layout: post
title: "ReactJS : writing in ES6"
excerpt: "When writing ReactJS components in ES6 here is the certain things that are different from ES5 syntax"
date: 2016-02-12 00:00:00 IST
updated: 2016-02-12 00:00:00 IST
categories: javascript
tags: reactjs
---

When you are new to ES6 syntax with react here is certain things that are different from ES5 syntax.

## Extend from React.Component

In ES5 syntax, we use `React.createClass` create component where as along with ES6 syntax you can extends the component from `React.Component`.

As per ES5

~~~ js
var React = require('react');

var Comp = React.createClass({
  render() {
    return (<div>Comp with ES5</div>);
  }
})
~~~

Where as in ES6

~~~ js
import React, {Component} from 'react';

class Comp extends Component {
  render() {
    return (<div>Comp with ES5</div>);
  }
}
~~~

## Use `constructor` instead of `getInitialState`

In ES5 with `React.createClass` we usually use `getInitialState` method to specify the initial state of the component. But with ES6 `class` syntax you don't need `getInitialState` method. You set the initial state in `constructor` itself.

~~~ js
import React, {Component} from 'react';

class Comp extends Component {
  constructor() {
    super();
    this.state = {
      name: "some name"
    };
  }
  render() {
    return (<div>Comp with ES5 :: {this.state.name}</div>);
  }
}
~~~

## Use `constructor` to make ajax calls

Also if you want to make any ajax calls when component is loading you can do that as well in the `constructor`.

~~~ js
import React, {Component} from 'react';

class Comp extends Component {
  constructor() {
    super();
    this.getData();
  }
  getData() {
    // make ajax call
  }
  render() {
    return (<div>Comp with ES5 :: {this.state.name}</div>);
  }
}
~~~

You don't need to to call `getData` in `componentDidMount`.
