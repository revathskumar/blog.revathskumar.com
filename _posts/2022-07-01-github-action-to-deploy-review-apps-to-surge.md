---
layout: post
title: GitHub action to deploy review apps to surge
excerpt: GitHub action to deploy review apps to surge
date: 2022-07-01 01:00 +0530
updated: 2022-06-26 01:00 +0530
categories: github-actions
tags: github-actions, frontend
---
This post explains a simple GitHub action to deploy your frontend app to [surge](https://surge.sh) for each pull request created.

This post assumes you already have `surge` installed and logged in. 

Now, let's generate a new surge token 

```sh
surge token
```

Add the generated token to Github secrets so that GitHub actions can use it. 

Next, add the following action into `.github/workflows`. 

{% highlight yml %}
{% raw %}
# .github/workflows/surge.yml
name: Deploy to surge

on:
  pull_request:
  push:
    branches:
      - 'main'

jobs:
  build:
    runs-on: ubuntu-latest
    name: Deploying to surge
    steps:
      - uses: actions/checkout@v1
      - name: Install surge and fire deployment
        uses: actions/setup-node@v1
        with:
          node-version: 18
      - run: npm i -g surge
      - run: npm ci
      - run: npm run build
      - run: surge ./dist/ my-app-${{ github.event.number || 'main' }}.surge.sh --token ${{ secrets.SURGE_TOKEN }}  
{% endraw %}
{% endhighlight %}

This will action will get triggered when a pull request is created/updated and merged to the main. 

We use the pull request id in the URL for each review app like `my-app-1.surge.sh` for the review apps and when we merge the pull request to main it will deploy to `my-app-main.surge.sh`

Hope that helped.
