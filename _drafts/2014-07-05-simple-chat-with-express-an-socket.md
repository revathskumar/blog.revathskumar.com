---
layout: post
title: "Simple chat with express.js and socket.io"
excerpt: "Simple chat application with express.js and socket.io"
date: 2014-07-05 00:00:00 IST
updated: 2014-07-05 00:00:00 IST
categories: expressjs, socket
tags: expressjs, socket
---

I always wondered how this chat application works in realtime. we just enter some text and send, the right next moment it reaches the other end. From the first time I heard of socket.io, It was in mind that I should build a simple chat application.

Here I use [socket.io](http://socket.io) and [express.js](http://expressjs.com).

```js
io = io.listen(server);
var sockets = {};
io.sockets.on('connection', function(socket) {
  socket.on('send', function(data){
    var chatCollection = db.get('chats');
    chatCollection.insert({text: data.chat, to: data.to}, function(err, doc){
      if(err){
        console.log(err);
      }else{
        sockets[data.to].emit('get', {chat: data.chat});
        // socket.broadcast.emit('get', {chat: data.chat});
      }
    });
  });

  socket.on('new user', function(data){
    sockets[data.name] = socket;
    console.log(data);
    socket.broadcast.emit('user list update', {name: data.name});
  });

  socket.on('disconnect', function () {
    socket.broadcast.emit('remove user', {id: this.id});
  });
});
```