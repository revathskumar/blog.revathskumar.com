---
layout: post
title: 'Prisma : Extending model with custom methods'
excerpt: 'Prisma : Extending model with custom methods'
date: 2025-06-10 09:59 CEST
updated: 2025-06-10 09:59 CEST
categories: prisma
tags: prisma
image: ''
---
As a person coming from a Ruby on Rails background, I prefer `ActiveRecord` pattern to `DataMapper`. Obviously the choice will be based on the project and other criteria's, but from my experience, most projects don't require the complexity of Data Mapper. 

When I started using Prisma, one of the confusions for me was how to add a custom method to a model.

## <a class="anchor" name="extending-prisma-client-model-object" href="#extending-prisma-client-model-object"><i class="anchor-icon"></i></a>Extending Prisma Client model object


Prisma documentation on [custom models](https://www.prisma.io/docs/orm/prisma-client/queries/custom-models) provides 3 ways to achieve it. From the 3 methods, I decided to go with `Extending Prisma Client model object`. 

The major reason for going with this approach is its flexibility. By this method, we can define type-safe custom methods in models.

```ts
import { PrismaClient } from "@prisma/client";
import { prisma } from "@/../prisma";

function User(prismaUser: PrismaClient["user"]) {
  return Object.assign(prismaUser, {
    async signup(data) {
      // implement logic
    },

    async login(data) {
      // implement logic
    },
    
    async isUserFavorite(userId: string, entityId: number) {
      // implement logic
    },
  });
}

const user = User(prisma.user);

export default user;

```

and we can use both custom methods alongside inbuilt methods like `findBy`, `count` and `upsert` from the model object.  


The major downside of [Wrap model in a class](https://www.prisma.io/docs/orm/prisma-client/queries/custom-models#wrap-a-model-in-a-class) is we won't be able to use the inbuilt methods from the model instance.   


Hope this is helpful.  
  

Versions of Language/packages used in this post.

| Library/Language | Version |
| ---------------- | ------- |
| Prisma           | 6.4.1   |
