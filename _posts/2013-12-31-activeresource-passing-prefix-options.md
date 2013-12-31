---
layout: post
title: "ActiveResource : Passing prefix options"
date: 2013-12-31 00:00:00 IST
updated: 2013-12-31 00:00:00 IST
categories: rails
---

ActiveResource can be used with nested resources, provided you need to pass the parameters accordingly. ActiveResource call it as `prefix options` that used with nested resource. Its a bit tricky to pass the prefix options to different methods, since methods use different approach to accept prefix params. Lets consider we have a model for Inventory like on below,

{% highlight ruby %}
class Inventory < ActiveResource::Base
  self.prefix = '/api/admin/stores/:store_id/'
end
{% endhighlight %}

The prefix option `:store_id` is passed to various method in different ways. Make sure you use the same key as you specified in the `self.prefix`.  

# On find()
For `find()` method you can pass the `:store_id` in `:params` hash, as second parameter. 

{% highlight ruby %}
# .find()
Inventory.find(params[:id], params: { store_id: params[:store_id]})
{% endhighlight %}

# On save()
For `save()` you can't pass it as second parameter. So you need to explicitly set on the object before calling the `.save()` method.

{% highlight ruby %}
# .save()
@inventory = Inventory.new(params[:inventory])
@inventory.prefix_options[:store_id] = @store.id
@inventory.save
{% endhighlight %}

# On update_attributes()
`.update_attributes()` won't accept any second parameter, so you need to pass it with other params.

{% highlight ruby %}
# .update_attibutes()
params[:inventory][:store_id] = @store.id
@inventory.update_attributes(params[:inventory])
{% endhighlight %}
