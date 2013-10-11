---
layout: post
title: "Rails : render partials without losing event bindings"
date: 2013-10-11 00:00:00 IST
updated: 2013-10-11 00:00:00 IST
categories: rails
---


## Problem

Recently when I was working on a rails project I have to render the a partial after the form sumitted via `remote: true`. but then I noticed that the event binding stopped working after the rendering partial via `js.erb`.

{% highlight js %}
<!-- list.js.erb -->
$('.user-list').html(<%= j render partial: "user_list" %>);
{% endhighlight %}

The user_list consists of a table of users, In which the user details are shown the we click on the corresponding row. This is working fine when they are rendered from server. But the show details stopped working after we render the `list.js.erb` after the form submission.

{% highlight html %}
<!-- _user_list.html.erb -->
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Email</th>
    </tr>
  </thead>
  <tbody>
    <% @user.each do | user | %>
      <tr class='user'>
        <td><% user.name %></td>
        <td><% user.email %></td>
      </tr>
      <tr class='user-details'>
        <td colspan="2"><%= user.details %></td>
      </tr>
    <% end %>
  </tbody>
</table>
{% endhighlight %}

The user-details row is initialy hidden by css. Then when we click on the user row the details is shown.

{% highlight js %}
# users.js
$('.user').on('click',function(e){
  $(e.currentTarget).next('tr.user-details').fadeToggle(500)
})
{% endhighlight %}

But after renering via `list.js.erb` the click event on `.user` didn't get fired.

## Solution

I hope the problem is now 