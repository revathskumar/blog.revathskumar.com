---
layout: post
title: "Getting started with React"
date: 2014-05-03 00:00:00 IST
updated: 2014-05-03 00:00:00 IST
categories: javascript
---

Recently when I saw a tweet saying "its super easy to build UI components with [React.js](http://facebook.github.io/react/)" I thought I should try it as well. 

# React

React is a simple JavaScript library from Facebook to create UI components. React uses `*.jsx` files for its template. You can either precompile it with react npm module or in the browser with `JSXTransformer.js`. 

I started with installing react with bower.

```sh
bower install react
```

After installing with bower I added react.js into my index.html.

```html
<script src="bower_components/react/react.js"></script>
```

Since I prefer to precompile the jsx files, I installed react npm module and gulp plugin for it.

```sh
npm install react gulp-react --save
```

# First Component

My first component was a simple HelloMessage with name and click handler.

```js
/** @jsx React.DOM */
var HelloMessage = React.createClass({
  click: function(){
    console.log('clicked');
  },
  render: function(){
    return <div onClick={this.click}>Hello {this.props.name} </div>;
  }
});

var parent = document.querySelector('.jumbotron');
React.renderComponent(<HelloMessage name="Revath" />, parent);
```

The `React.renderComponent` method accepts two arguments

1. The Component name and the properties
    > In this case the component is `HelloMessage` which has a property `name` with value "Revath"

2. The parent element where it should inject in the DOM.
   > In this case it is the element with class `jumbtron`

It is optional to use `/** @jsx React.DOM */` as the first line when you use [gulp-react] to precompile.

To precompile this I configured the gulpfile.

```js
// gulpfile.js
var react = require('gulp-react');

gulp.task('react', function(){
  return gulp.src('app/scripts/*.jsx')
    .pipe(react())
    .pipe(gulp.dest('.tmp/scripts/'));
});
```

