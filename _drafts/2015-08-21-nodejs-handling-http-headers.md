---
layout: post
title: "Nodejs : handling http headers"
excerpt: "Nodejs : How to set and get http headers"
date: 2015-08-21 00:00:00 IST
updated: 2015-08-21 00:00:00 IST
categories: nodejs
tags: nodejs
---

In a [simple nodejs http server](/2015/08/nodejs-simple-http-server.html) all the request headers in are avilable on `req.headers` object. So if you want to get any header value you can do

```js
requestObj.headers.HEADER_NAME
```

so if you want to get `host`, you can use

```js
var server = require('http').createServer(function(req, res) {

  req.write('<h1>Hello World :: ' + req.headers.host +' </h1>');

  res.end();
}); 
var port = process.env.PORT || 9001;
server.listen(port);
server.on('listening', function(){
  console.log('Listening to ', port);
}); 
```

And if you want to set an header for your response, you can use `setHeader` method on response object.

```js
var server = require('http').createServer(function(req, res) {
  var headerStr =JSON.stringify(req.headers);
  
  res.setHeader('content-type', 'application/json');
  
  res.write(headerStr);
  res.end();
}); 
var port = process.env.PORT || 9001;
server.listen(port);
server.on('listening', function(){
  console.log('Listening to ', port);
}); 
```

While setting response header, you need to make sure that you set the header before sending first byte of response.

Thank You.