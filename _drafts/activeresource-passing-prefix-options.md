---
layout: post
title: "ActiveResource : Passing prefix options"
date: 2013-12-25 00:00:00 IST
updated: 2013-12-25 00:00:00 IST
categories: rails
---

# .find()
Inventory.find(params[:id], params: { store_id: params[:store_id]})

# .save()
@inventory = Inventory.new(params[:inventory])
@inventory.prefix_options[:store_id] = @store.id
@inventory.save

# .update_attibutes()
params[:inventory][:store_id] = @store.id
@inventory.update_attributes(params[:inventory])