---
layout: post
title: "React : server side rendering"
---

Now server rendering is a big thing for heavy client side apps and now most of
the client side frameworks supports it. Yesterday I tried a bit of react server
rendering along with expressjs and react router.

## Setup Express js server and dependencies.

As usual we can start with scaffolding a new expressjs app using expressjs-
generator and installing all the dependencies. I used `webpack` for client side
bundling. 

You can install all the dependencies like

~~~ sh
npm i --save react react-dom react-router babel-register
~~~

and development dependencies like

~~~ sh
npm i --save-dev babel-cli babel-core babel-preset-es2015 babel-preset-react babel-preset-stage-0 webpack babel-loader
~~~

## Setting up webpack & babel for client.

I decided to keep all my client js and react components in a new folder named
`client` and put all the compiled js in `public/javascripts`. I added a
`.babelrc` to load babel presets and configs.

~~~ json
{
    "presets": ["es2015", "react", "stage-0"]  
}
~~~

Now to webpack config. I pointed the entry file, output directory and babel
loader in `webpack.config.js`

~~~ js
// webpack.config.js

var path = require('path');

module.exports = {
  entry: './client/app.jsx',

  output: {
    filename: 'app.js',
    path: path.join('public/javascripts/')
  },

  module: {
    loaders: [
      {
        test: /\.jsx?$/,
        loader: 'babel-loader',
        query: {
          presets: ['react', 'es2015'],
          plugins: ['transform-object-assign']
        }
      }
    ]
  }
};
~~~

Now I can run 

~~~ sh
webpack --debug --hot --output-path-info --devtool=eval --display-modules --watch -d
~~~

for build client js in development mode with debugging and hot module reloading.

For easier use I added this command to [npm scripts](https://docs.npmjs.com/misc/scripts) with name `webpack:server`, so I just need to run 
`npm run webpack:server`.

## Setup react router

Now the basic scaffolding and development setup is finished and time to start
building our app. I started it with configuring the router. I panned mainly for
two routes `/home` to show the rendering of static component and `/list` to show
the server side rendering with some data.

First I have to define the entry point which will mount our `react-router`
component to DOM. 

~~~ js
// client/app.jsx

import React from 'react';
import {render} from 'react-dom';

import AppRouter from './router.jsx';

render(<AppRouter/>, document.querySelector('#app'));
~~~

Then the routes defined in `client/router.jsx`

~~~ js
// client/router.jsx

import React from 'react';
import {Router, browserHistory, Route} from 'react-router';

import AppRoot from './app-root.jsx';
import Home from './home.jsx';
import List from './list.jsx';

const AppRouter = () => {
  return (
    <Router history={browserHistory}>
      <Route path="/" component={AppRoot}>
        <Route path="/home" component={Home}/>
        <Route path="/list" component={List}/>
      </Route>
    </Router>
  );
};

export default AppRouter;
~~~

`AppRoot` is nothing but a simple layout for all the root routes.

~~~ js
// client/app-root.jsx

import React, {Component} from 'react';
import {Link} from 'react-router';

class AppRoot extends Component {
  render() {
    return (
      <div>
        <h2>React Universal App</h2>
        <Link to="/home"> Home </Link>
        <Link to="/list"> List </Link>
        {this.props.children}
      </div>
    );
  }
}

export default AppRoot;
~~~

## Setup express js for server side rendering

Since we are using React + ES6 for components we need to use `babel-register` so 
that we can write express js routes in ES6 and require the ES6 route we already wrote.
I required the `babel-register` at the beginning of express js entry point `app.js`.

~~~ js
// app.js
require('babel-register');
var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');

//rest of the express js boilerplate
~~~

Then I rename the `routes/index.js` to `routes/index.jsx`. Now I can use the 
client routes and react components in server side. For server side rendering we use 
`renderToString` method from `react-dom/sever` package and `match`, `createRoutes` and `RouterContext`
from `react-router`.

[match](https://github.com/reactjs/react-router/blob/master/docs/API.md#match-routes-location-history-options--cb) 
utility will match a set of routes to a location without rendering and call as callback. 
For `match` we have to provide the set of routes, which need to be created from our `client/router.jsx`(`appRouter`) component.
We can use [createRoutes](https://github.com/reactjs/react-router/blob/master/docs/API.md#createroutesroutes) 
method from `react-router` to do this. 

~~~ js
// routes/index.jsx
// express and react imports

import appRouter from '../client/router.jsx';

const routes = createRoutes(appRouter());
~~~

Once we had a match [RouterContext](https://github.com/reactjs/react-router/blob/master/docs/API.md#routercontext) will 
renders the component tree for the given router state.

Once we have the route match we can render the `RouterContext` to string using the `renderToString` method.

~~~ js

router.get('\*', (req, res) => {
  match({routes, location: req.url}, (error, redirectLocation, renderProps) => {
    // check for error and redirection
    const content = renderToString(<RouterContext {...renderProps}/>);
    // passing to jade view
  })
})
~~~

Now I have the react component rendered as string and I need to pass this to `jade` view. 
So I made change to my jade view which will accept a `content` variable and substitute 
inside the react app mount point.  

~~~ jade
extends layout

block content
  div.container#app!= content
~~~

## Rendering a static component on server

`/home` points to a static component called `Home` which we are going to render from server.

~~~ js
import React from 'react';

const Home = () => {
  return (
    <div>
      <h1>Home</h1>
    </div>
  );
};

export default Home;
~~~

and now when I join the dots the `routes/index.jsx` will look the below code.

~~~ js
import express from 'express';
import React from 'react';
import {renderToString} from 'react-dom/server';
import {RouterContext, match, createRoutes} from 'react-router';

import appRouter from '../client/router.jsx';

const routes = createRoutes(appRouter());

const router = express.Router();

router.get('/home', (req, res) => {
  match({routes, location: req.url}, (error, redirectLocation, renderProps) => {
    if (error) {
      res.status(500).send(error.message);
    } else if (redirectLocation) {
      res.redirect(302, redirectLocation.pathname + redirectLocation.search);
    } else if (renderProps) {
      const content = renderToString(<RouterContext {...renderProps}/>);
      res.render('index', {title: 'Express', content});
    } else {
      res.status(404).send('Not Found');
    }
  });
});
~~~ 

## Rendering component on server with data

In this I am trying to render a list of users, the data source is not db, but an api for demo purpose.
So to render data, we need to fetch that from the server, pass it to component via [context](/2016/02/reactjs-context.html).
So we start with writing a Higher Order Component to set the data to context.

~~~ js
import express from 'express';
import request from 'request';
import React, {Component} from 'react';
import {renderToString} from 'react-dom/server';
import {RouterContext, match, createRoutes} from 'react-router';

import appRouter from '../client/router.jsx';

const routes = createRoutes(appRouter());

class DataProvider extends Component {
  getChildContext() {
    return {data: this.props.data};
  }
  render() {
    return <RouterContext {...this.props}/>;
  }
}

DataProvider.propTypes = { 
  data: React.PropTypes.object
};

DataProvider.childContextTypes = { 
  data: React.PropTypes.object
};
~~~

The above `DataProvider` will set data to context if we pass it via props named `data`.

The `List` component will look like,

~~~ js
import React, {Component} from 'react';

class List extends Component {
  constructor(props, context) {
    super(props, context);
    this.state = this.context.data || window.__INITIAL_STATE__ || {items: []};
  }

  componentDidMount() {
    this.fetchList();
  }

  fetchList() {
    fetch('http://jsonplaceholder.typicode.com/users')
      .then(res => {
        return res.json();
      })  
      .then(data => {
        this.setState({
          items: data
        });
      })  
      .catch(err => {
        console.log(err);
      }); 
  }

  render() {
    return (
      <ul>
        {this.state.items.map(item => {
          return <li key={item.id}>{item.name}</li>;
        })}
      </ul>
    );  
  }
}

List.contextTypes = { 
  data: React.PropTypes.object
};

export default List;
~~~

The above list component will look for data in context first, then in global state and later in component level state. 
While we render it from server the data will be available in context and component and use it to render the initial HTML. 
later after loading it in browser the component can fetch again and update the data.

Now we can setup the route to fetch the data and render the component. 

~~~ js
router.get('/list', (req, res) => {
  match({routes, location: req.url}, (error, redirectLocation, renderProps) => {
    if (error) {
      res.status(500).send(error.message);
    } else if (redirectLocation) {
      res.redirect(302, redirectLocation.pathname + redirectLocation.search);
    } else if (renderProps) {
      request('http://jsonplaceholder.typicode.com/users', (error, response, body) => {
        const data = {items: JSON.parse(body)};
		const content = renderToString(<DataProvider {...renderProps} data={data}/>);
        res.render('index', {title: 'Express', data, content});
      });
    } else {
      res.status(404).send('Not Found');
    }
  });
});
~~~

Thats it. we successfully rendered our react components from server side with and without data, so that user dont want to wait
for another ajax request after loading the page to see the data.

