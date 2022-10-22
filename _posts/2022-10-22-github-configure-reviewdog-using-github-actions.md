---
layout: post
title: 'Reviewdog : configure reviewdog for eslint using github actions'
excerpt: 'Reviewdog : configure reviewdog for eslint using github actions'
date: 2022-10-22 10:00 +0200
updated: 2022-10-22 10:00 +0200
categories: github-actions
tags: github-actions
image: "/assets/images/reviewdog/reviewdog_comment.webp"
---
To make the eslint issues more visible on pull requests, especially the warnings, we used to add comments on PR as part of our review process. 

This manual process is error-prone and slows down our review process. To make it streamlined, I was looking for a tool which can report the eslint errors/warnings as PR review annotations on the exact line where eslint finds the problems. 
Thus I came to know about reviewdog. Luckily [reviewdog][reviewdog] has GitHub actions for [eslint][reviewdog_eslint] which is perfect for us. 

Below is the sample GitHub action file we use in our projects. 


{% highlight yml %}
{% raw %}

# .github/workflows/reviewdog.yml

name: reviewdog
on: [pull_request]
jobs:
  eslint:
    name: runner / eslint
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
    steps:
      - uses: actions/checkout@v2
      - uses: reviewdog/action-eslint@v1
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          reporter: github-pr-review # Change reporter.
          eslint_flags: 'src/'

{% endraw %}
{% endhighlight %}


The permission block in `reviewdog.yml` will give the required permissions for the `GITHUB_TOKEN` generated for the action. 

Here is the reviewdog in action,

{: style="text-align: center"}
![reviewdog comment in action](/assets/images/reviewdog/reviewdog_comment.webp){: style='width: 100%'}

I hope you will find it helpful and try it in one of your projects.


[reviewdog]: https://github.com/reviewdog/reviewdog
[reviewdog_eslint]: https://github.com/reviewdog/action-eslint