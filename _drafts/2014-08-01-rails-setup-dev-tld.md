---
layout: post
title: "Rails : Setup .dev TLD"
excerpt: "Rails : Setup .dev TLD"
date: 2014-08-01 00:00:00 IST
updated: 2014-08-01 00:00:00 IST
categories: rails
tags: rails
---

While I was working with PHP, I used to setup *.dev* domain with [Apache VirtualHost](http://www.phprepo.in/2011/09/adding-virtual-host-in-apache-on-ubuntu/) for my development. But after I moved to Ruby on Rails, I never used it since Rails were not using apache and port other than 80.

In the begining I tried to set domain with `/etc/hosts`, but I came to know that hosts file won't accept PORT. They only map IP. But now I managed to find a way to setup *.dev* domain for rails development.

## Manual Setup

To setup *.dev* domain, the prerequisites are [dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) and [rinetd](http://www.boutell.com/rinetd/).

*dnsmasq*
Its a lightweight DNS server, which can be configured in a variety of convenient ways.

### Installation

* Install dnsmasq

_ apt-get install dnsmasq

* Install rinetd

_ apt-get install rinetd

### Configure

create /etc/dnsmasq.d/dev-tld

```
local=/dev/
address=/dev/127.0.0.1
```

append to /etc/rinetd.conf

```
0.0.0.0 80 0.0.0.0 4000
0.0.0.0 443 0.0.0.0 3003
```

sudo service rinetd restart
sudo service dnsmasq restart
sudo /etc/init.d/networking restart

## Setup with invoker

rvmsudo invoker setup

