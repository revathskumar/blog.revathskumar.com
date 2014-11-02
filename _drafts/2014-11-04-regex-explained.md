---
layout: post
title: "Regex: comma seperated indian currency"
excerpt: "Regex: comma seperated indian currency10"
date: 2014-11-04 00:00:00 IST
updated: 2014-11-04 00:00:00 IST
categories: regex
---

Recently, I got a request to show prices in comma seperated format on [whatznear.com](http://whatznear.com). Since we are using rails, it have a handy method to do [number_to_currency](http://api.rubyonrails.org/classes/ActionView/Helpers/NumberHelper.html#method-i-number_to_currency), but unfortunately that was not enough because it follow US system of seperation with thousands. My requirement was to show prices in Indian system of seperation with hundreds.

```ruby
450,500 # US system
4,50,500 # Indian System
```

So I dropped a mail to [Kerala Ruby Users Groups](https://groups.google.com/d/msg/kerala-ruby-users-group/9-TjkhSTspc/R-NIwr9XuxwJ) and [Hari Sankar](http://csnipp.com/coderhs) replied with a [regular expression](https://groups.google.com/d/msg/kerala-ruby-users-group/9-TjkhSTspc/10ywX41mZiUJ) from his snippet collection.

```ruby
price.to_s.gsub(/(\d+?)(?=(\d\d)+(\d)(?!\d))(\.\d+)?/, "\\1,")
```

The above regex worked fine for me, but I was curious to know how it works. So I started digging into regex documentation. I am gonna explain, what I understand about the regex.

[![Regex groups explained](http://i653.photobucket.com/albums/uu253/revathskumar/Coderepo/2014/11/Screenshotfrom2014-11-02223852_zpsaf17908a.png)](http://www.regexper.com/#%2F\(%5Cd%2B%3F\)\(%3F%3D\(%5Cd%5Cd\)%2B\(%5Cd\)\(%3F!%5Cd\)\)\(%5C.%5Cd%2B\)%3F%2F)

## Group 1 `(\d+?)`

Let look into group 1 ie., `(\d+?)` which says digit should repeat. I think there is nothing much confusing here except the tailing `?`. The question mark tells the regex engine, "**preceding token zero times or once**". A `?` after `+` makes it [lazy](http://www.regular-expressions.info/repeat.html#lazy) and return as soon as the first match.

## Group 2 `(?=(\d\d)+(\d)(?!\d))`

The Group 2 start with `?=` means its a positive lookahead and the previously captured match (matched by group 1) should follow match of this group. Whatever this Group 2 matches won't expand the match of Group 1.

In order to match this group, 2 digits should be found at least once (`(\d\d)+`), followed by a digit (`(\d)`) and at last not followed by a digit. 

`(?!\d)` is a [negative lookahead](http://www.regular-expressions.info/lookaround.html) which succeeds when the regex inside lookahead fails. This helps to filter out last 3 digits of a number.


## `(\d+?)(?=(\d\d)+(\d)(?!\d))`

So the group 1 and group 2 jointly helps to match number **1000000** as in the below image.

[![](http://i653.photobucket.com/albums/uu253/revathskumar/Screenshotfrom2014-11-02233630_zps1c05171d.png)](http://rubular.com/r/EUcINMTwmw)

