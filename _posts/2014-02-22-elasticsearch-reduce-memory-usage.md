---
layout: post
title: "ElasticSearch : Reduce CPU usage"
date: 2014-02-22 00:00:00 IST
updated: 2014-02-22 00:00:00 IST
categories: elasticsearch
---

If your development machine, hangs due to CPU usage of elastic search, here are the two settings which you need to update. I tested these settings and got real perfomance gain on my **Ubuntu** development machine.

**The settings below should be used only on `development` machines.**

# 1. Set HEAP size

My default the ElasticSearch heap size is 256m minimum and 1g maximum. You need to update the maximum size to 256m. To do this open `/etc/init.d/elasticsearch` and uncomment the line,

```
ES_HEAP_SIZE=256m
```

# 2. Set number of shards & replicas

By default the number of shards is set to 5 and replicas to 1.
We can update to shards as 1 and replicas as 0 in development, which will lead to real gain of perfomance.

```
# /etc/elasticsearch/elasticsearch.yml
index.number_of_shards: 1
index.number_of_replicas: 0
```

Thanks.