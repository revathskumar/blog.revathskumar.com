---
layout: post
title: "Rails: File upload via ajax using remotipart"
excerpt: "Rails: File upload via ajax using remotipart"
date: 2014-12-03 00:00:00 IST
updated: 2014-12-03 00:00:00 IST
categories: rails
---

Rails `remote` is one of the best way to submit a form with ajax. But it is not capable of uploading files using ajax. That's where `remotipart` gem comes into action.

**Add gem to Gemfile**

```ruby
# Gemfile
gem 'remotipart'
```

Then you need to add remotipart to javascript manifest.

```erb
//= require jquery.remotipart 
```

You are done, now 

https://github.com/whatznear/whatznear_web_app/commit/0a98d0745d94b92cd2ceeef31503de19b4f0bf6f

http://os.alfajango.com/remotipart/
https://github.com/JangoSteve/remotipart
http://www.alfajango.com/blog/ajax-file-uploads-with-the-iframe-method/