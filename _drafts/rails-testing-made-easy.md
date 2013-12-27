---
layout: post
title: "Rails : Test::Unit running tests made easy with zeus"
date: 2013-09-30 11:00:00 IST
updated: 2013-09-30 11:00:00 IST
categories: rails
---

In **Rails 3.2** with Test::Unit, there are predefined tasks to run the tests like `rake test:unit`, `rake test:functionals` etc. But when you are developing some times you need to run a single test or tests from a single file. None of the rake tasks for testing provide this in Rails 3.2.

I like to show you how you can do this with zeus.

# Run tests from single file
zeus test test/functional/some_test.rb

# Run a single test

zeus test test/functional/some_test.rb -n test_should_create_new_test\
or
zeus test test/functional/some_test.rb -n "test should create new test"
or
zeus test test/functional/some_test.rb:40