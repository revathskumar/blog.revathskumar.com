---
layout: post
title: "Simple chat with express.js and socket.io"
excerpt: "Simple chat application with express.js and socket.io"
date: 2014-07-05 00:00:00 IST
updated: 2014-07-05 00:00:00 IST
categories: expressjs, socket
tags: expressjs, socket
---

I always wondered how this chat application works in real time. we just enter some text and send, the right next moment it reaches the other end. From the first time I heard of socket.io, It was in mind that I should build a simple chat application.

Here I used [socket.io](http://socket.io) and [express.js](http://expressjs.com). Let see what all features we need for a simple chat,

* setup socket.io
* Accept a user
* Update the user list for all connections
* User can select some other users available
* When the user enter a text, show up to the corresponding user

## The socket.io setup

Let get ready with socket.io, since in this blog post I am gonna concentrate on socket.io, I will be skipping the default express.js boilerplate code for convenience. We need to setup the socket.io on both server and client to accept connection.

On server you can install socket.io from npm,

```sh
npm install --save socket.io
```

Then in your `app.js` require the `socket.io` and bind the connection event. We will register more events in `connection` callback as we advance more functionalities.

```js
// server
// app.js
var io = require('socket.io');

server = http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});

io = io.listen(server);
var sockets = {};

io.sockets.on('connection', function(socket) {
  // register all events here
});
```

Then on client side, we will add socket.io, we don't need to install anything for client as the `socket.io.js` will be served by socket.io in server.

```html
<script src="/socket.io/socket.io.js"></script>
<script>
  var socket = io.connect('http://localhost');
</script>
```

