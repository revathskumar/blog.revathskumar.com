---
layout: post
title: 'Opinion : unblocking frontend'
excerpt: 'Unblocking frontend and providing the api should miss only the business logic not the thought process and contract'
date: 2018-12-03 23:55:00 IST
updated: 2018-12-03 23:55:00 IST
categories: opinion
tags: frontend
---

Now its quite normal that frontend and backend gets developed in parallel by different teams. In such cases (normally for `GET` apis) the backend team will provide a mock
api with dummy response just enough to **Unblock Frontend** so that frontend team can build their part. But I have seems some team misunderstand this **unblocking frontend**

It doesn't mean,

* can give some JSON what they think works for now and later change
* doesn't need any thought process
* doesn't need to meet all the data points
* can be served via entirely different api sever with only this endpoint.

but the **unblock frontend** should be

* It should be well thought out and planned contract
* It miss only the real business logic not the thought process
* the contract might not change much.
* it should be served via the same api server 

If the frontend team is constantly coming back and ask for api changes, it means the mock api is not well thought processed and such 
unblocking is just giving work to frontend team but they can't ship anything.

A little thought process and coming to a contract by sitting with frontend team or product managers will help.
