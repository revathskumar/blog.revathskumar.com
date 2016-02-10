---
layout: post
title: "ReactJS : using debounce in react components"
excerpt: "ReactJS : using debounce in react components"
date: 2016-02-11 00:00:00 IST
updated: 2016-02-11 00:00:00 IST
categories: javascript
tags: browserify
---

When I was working with a typeahead feature, I wanted to rate limit the ajax calls made by it using debounce. Usually in such cases I use either [jQuery debounce](http://benalman.com/projects/jquery-throttle-debounce-plugin/) or [_.debounce](http://underscorejs.org/#debounce). 

But when it came to react components my usual approch didn't worked since react wrap the events with [SyntheticEvent](https://facebook.github.io/react/docs/events.html#syntheticevent). Since synthetic events have [event pooling](https://facebook.github.io/react/docs/events.html#event-pooling)  all properties will be nullified as soon as the callback function is invoked. Due to this the following code won't work.

Here I used [throttle-debounce](https://www.npmjs.com/package/throttle-debounce)

~~~ js
import react, {Component} from 'react';
import {debounce} from 'throttle-debounce';

export default class Comp extends Component {
  printChange(e) {
    console.log('value :: ', e.target.value);
    console.log('which :: ', e.which);
    // call ajax
  }
  render() {
    return (
      <div>
        <input type="text" onKeyUp={debounce(500, this.printChange)}/>
      </div>
    );
  }
}
~~~

In the above code it will throw error `Uncaught TypeError: Cannot read property 'value' of null` because `e.target` will be null due to event polling.

To make it work you need to remove debounce from event handler and use `e.persist()` on SyntheticEvent like in the below code.

~~~ js
import React, {Component} from 'react';
import {debounce} from 'throttle-debounce';

export default class Comp extends Component {
  printChange(e) {
    e.persist();
    debounce(500, () => {
      console.log('value :: ', e.target.value);
      console.log('which :: ', e.which);
      // call ajax
    })()
  }
  render() {
    return (
      <div>
        <input type="text" onKeyUp={this.printChange}/>
      </div>
    );
  }
}
~~~

Even though the above code work, the debounce won't rate limit. So we need to wrap call ajax in another function and wrap again that with debounce in `componentWillMount` or in `constructor` (if you are using ES6 class) . Here is the better working code with debounce.

~~~ js
import React, {Component} from 'react';
import {debounce} from 'throttle-debounce';

export default class Comp extends Component {
  constructor() {
    super();
    this.callAjax = debounce(500, this.callAjax);
  }
  printChange(e) {
    this.callAjax(e.target.value);
  }
  callAjax(value) {
    console.log('value :: ', value);
    // call ajax
  }
  render() {
    return (
      <div>
        <input type="text" onKeyUp={this.printChange.bind(this)}/>
      </div>
    );
  }
}
~~~

