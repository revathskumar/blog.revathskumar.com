---
layout: post
title: "Rails : API as datasource"
date: 2013-12-25 00:00:00 IST
updated: 2013-12-25 00:00:00 IST
categories: rails
---

Recently I was working on a rails app where its datasource was a API instead of a database. My team wants all the components to be seperate, thats the reason we go fo this kind of architecture. We were using Rails 3.2 and ActiveResource for the frontend. 

Here is my sample data from the JSON API.

{% highlight js %}
{
  store: {
    name: 'some store',
    description: 'some description',
    contacts: {
      phone: '0495-2414123',
      email: 'test@somestore.com',
      mobile: '99950123456'
    }
  }
}
{% endhighlight %}

ActiveResource will deal with the data pretty well except `contacts`. It tends to create an object for contacts. The ActiveResource object will be something similar to

{% highlight ruby %}
#<Store:0xb4aaec4 @attributes={ "store" => {"description" => "some description", 
"contacts"=>#<Store::Contact:0xb4aa884 @attributes={ "contact" => {"opening_time"=>
"09:00", "closing_time"=>"18:00",  "holidays"=>["Sunday"], "message"=>"" } }, 
@prefix_options={}, @persisted=false>, "name"=> "some store" } } , @prefix_options={}, 
@persisted=false>
{% endhighlight %}

So I hope you have noticed that contacts is an object of `Store::Contact`. This is pretty handy anyway but the main issue was `contacts` attributes are are enclosed inside a root element `contact`. This is not an issue if you are just finding and displaing data. But its a real issue when you try to create or update.

If we continue the same structure and use `Store.create` it will create the record like 

{% highlight js %}
{
  store: {
    name: 'some store',
    description: 'some description',
    contacts: {
      contacts: {
        phone: '0495-2414123',
        email: 'test@somestore.com',
        mobile: '99950123456'
      }
    }
  }
}
{% endhighlight %}

Since we are using MongoDB to store data and the whole store and contact is document, the un-nessassory nesting for contacts was the real problem for us. So I thought of a dive into ActiveResource source code to solve this. Atlast we had two ways to solve this issue.

1. Create a model for `Store::Contact` with `self.include_root_in_json = false`
2. Monkey patch `ActiveResource::Base.create_resource_for` method

# 1. Create a model
This will work out perfectly only you have one or two situations like `Store::Contact` or else you nee to create a model for every fields which are hash.

It will be better to create the model in the parent model file itself so that it will load the class when ever the parent model loads.

{% highlight ruby %}
class Store::Contact < ActiveResource::Base
  self.include_root_in_json = false

end
{% endhighlight %}

Now when ever the we call `Store.create` ActiveResource strip the extra nesting of contacts.

# 2. Monkey patch
If you are new to monkey patching, you can take a look to my another blog post which explains [how patch in rails](/2012/12/ruby-check-whether-method-is-monkey-patched-or-not.html).

{% highlight ruby %}
# config/initializers/active_resource_base_patch.rb
module ActiveResource
  class Base

    def create_resource_for(resource_name)
      resource = self.class.const_set(resource_name, Class.new(ActiveResource::Base))
      resource.prefix = self.class.prefix
      resource.site   = self.class.site
      resource.include_root_in_json = false
      resource
    end
  end
end
{% endhighlight %}

This will work perfectly if you want all your sub model to strip the root.