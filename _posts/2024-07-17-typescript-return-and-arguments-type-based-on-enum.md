---
layout: post
title: TypeScript - return and arguments type based on enum
excerpt: TypeScript - return and arguments type based on enum
date: 2024-07-17 12:07 CEST
updated: 2024-07-17 12:07 CEST
categories: typescript
tags:
- typescript
image: "/assets/images/ts-args-enum/args-error.webp"
---
Consider a simple function `draw` which can expect and enum for the type of the shape needs to draw as first argument and dimensions object as second argument.


```ts
const SHAPE_TYPES = {
    CIRCLE: 'CIRCLE',
    SQUARE: 'SQUARE',
    TRIANGLE: 'TRIANGLE',
} as const;

type ShapeTypesEnum =
  (typeof SHAPE_TYPES)[keyof typeof SHAPE_TYPES];

interface Circle {
    radius: number;
}

interface Square {
    sideLength: number;
}

interface Triangle {
    base: number;
    height: number;
}

type Dimensions = Circle | Square | Triangle;

function draw(shapeType: ShapeTypesEnum, dimensions: Dimensions): any {
	// some logic
    return dimensions;
}
```

Now, this allows us to pass wrong values to dimensions like,

```ts
const circle = draw(SHAPE_TYPES.CIRCLE, { sideLength: 5, });
```

So how can we make sure typescript will throw error if we pass wrong values in the above case?

## <a class="anchor" name="arguments" href="#arguments"><i class="anchor-icon"></i></a>Arguments Types Based on Enum

From the above example, ideally when we pass `SHAPE_TYPES.CIRCLE` as type, the second argument dimensions should accept only `radius`.  For that we will use new interface instead of Union types.


```ts
// types from the above snippet

interface ShapeDimensions {
    [SHAPE_TYPES.CIRCLE]: Circle,
    [SHAPE_TYPES.SQUARE]: Square,
    [SHAPE_TYPES.TRIANGLE]: Triangle,
}

function draw<T extends ShapeTypesEnum>(shapeType: T, dimensions: ShapeDimensions[T]): any {
	// some logic
    return dimensions;
}

const circle = draw(SHAPE_TYPES.CIRCLE, { radius: 5, });
```

Now, TypeScript will enforce that the dimensions argument matches the expected type based on the value of the shapeType argument.

{: style="text-align: center"}
![Show TS error for args](/assets/images/ts-args-enum/args-error.webp){: style='width: 100%'}

Here is the [TS playgound link][ts_args].

## <a class="anchor" name="return" href="#return"><i class="anchor-icon"></i></a>Return Types Based on Enum

Now, let's look into the return type. so far the above example we were using `any`.
Consider we try to return the `Union` type.

```ts
type Dimensions = Circle | Square | Triangle;

function draw(shapeType: ShapeTypesEnum, dimensions: Dimensions): Dimensions {
	// some logic
    return dimensions;
}

const circle = draw(SHAPE_TYPES.CIRCLE, { radius: 5, });
console.log('Return Circle :', circle.radius);
```

Now, typescript will give error in `console.log`

{: style="text-align: center"}
![Show TS error for return type](/assets/images/ts-args-enum/return-type-error.webp){: style='width: 100%'}

one way to remove this error is using guarding condition like below,

```ts
function isCircle(shape: Dimensions) : shape is Circle {
    return "radius" in shape
}

if(isCircle(circle)) {
    console.log('Return Circle :', circle.radius);
}
```

The better way to handle this is to return the right type based on the enum passed as first argument.

If we adopt, the approach as we used with arguments, we can avoid this guarding condition.

```ts
function draw<T extends ShapeTypesEnum>(shapeType: T, dimensions: ShapeDimensions[T]): ShapeDimensions[T] {
	// some logic
    return dimensions;
}

const circle = draw(SHAPE_TYPES.CIRCLE, { radius: 5, });
console.log('Return Circle :', circle.radius);
```

{: style="text-align: center"}
![Showing no error on return type](/assets/images/ts-args-enum/return-type-success.webp){: style='width: 100%'}

If we try to access `circle.sideLength`, typescript will give the error.

But what if the return type is not a object literal and an instance of a class?
Consider the  `Circle` & `Square`  classes below

```ts
class Circle {
    #radius = 0;

    setRadius(radius: number) {
        this.#radius = radius;
    }

    draw() {
        // some logic
    }

}

class Square {
    #sideLength = 0;

    setSideLength(sideLength: number) {
        this.#sideLength = sideLength;
    }

    draw() {
        // some logic
    }

}

interface ShapeType {
  [SHAPE_TYPES.CIRCLE]: Circle,
  [SHAPE_TYPES.SQUARE]: Square,
}
```

For the `ShapeFactory` if we try to return `new Cirlce()` typescript will throw the error.
Either we need to explicitly typecast using `as`

```ts
class ShapeFactory {
    createShape<T extends ShapeTypesEnum>(shape: T): ShapeType[T] {
		if (shape === SHAPE_TYPES.CIRCLE) {
            return new Circle() as ShapeType[T];
        }
    }
}
```

Another approach without typecasting will be as below,

```ts
class ShapeFactory {
    createShape<T extends ShapeTypesEnum>(shape: T): ShapeType[T] {
         return {
             [SHAPE_TYPES.CIRCLE]: new Circle(),
             [SHAPE_TYPES.SQUARE]: new Square(),
         }[shape];
    }
}
```

Feel free to check in [TS playground][return_constructor]

But using second approach means when ever we call the `createFactory` we create instance of all types which is bit annoying.

Did I miss anything, or Is there a better way?
Let me know you thoughts via email.

Thank You.

[ts_args]: https://www.typescriptlang.org/play/?#code/MYewdgzgLgBAygCQIIAUCiB9AKgTXXGAXhgG8AoGSmAYQEkAlagGTQC4YByOxljgGgpU4ARQCqSem04jxk-oMpZ6tJADkA4i3YclKjbwEBfGAEMIMUJCgBuMmSgBPAA4BTeAAsTrrM5cQ0YACuALZEggAUjq4gAGbwyOjYeGhwAJQA2gDWLg6xMFEueYiomLj4ALq2ZACWYFAuAE4xJsBucJ6uACLVwS6Q1eDm5FQw6cWJZSkAdNzMaOXs1NUNwAA2LgIjYwmlyXBTMhLz7HAAjoEmDRsKo+O7+FO6aprHMFgN1SZgAObrRnY1OqNZqtGjLNZuYZUBomAAm1UCEHYQWCACNGrZDHZavUmi02udLpCbhBqrCXEw+t8oO5kSF0Q1MdigXjQe9Pj91qQbqizC46WiMTd3C5qt93FABQymXYYoEwMAoAMwDBYTCAO4AHiwMBcAA96mBYeZ2l4XD5XP4UQA+cIQDrm3zsLB8VU9PqkwYnB3dXr9QbpLDlVLes2+j3KiCB8rcgCQAHp4zAICBejBViBvtVgDcrlBAg0VfC-Z7IEzLNALOCucQ1SZ1eE7kkHrMWK6SDAYfDEewAKyuwypawwMgVkDrKYZ77hDj0Fz5wtglZc1j8KvLlxTLsIiBDuwV2AQQlXIiqjWNnbN6aHSTt5NkilUml9gdDkdjidTmdzhcqpYbmBV1dI8LiuKZSXJSkfhpIcgA

[return_constructor]: https://www.typescriptlang.org/play/?#code/MYewdgzgLgBAygCQIIAUCiB9AKgTXXGAXhgG8AoGSmAYQEkAlagGTQC4YByOxljgGgpU4ARQCqSem04jxk-mQC+MAIYQYoSFADcZMlACeABwCm8ABbKTWI8YhowAVwC2RQQAoDJkADN4ydNh4aHAAlADaANbG+j4wnsaxiKiYuPgAujpkAJZgUMYATt7KwKZwFiYAIllOxpBZ4GrkVDBhSQGpwQB03MxoaezUWfnAADbGAs2t-ilBcJ0yEn3scACODsr544q6o6pqg8NjpIKUAMT5ygAmWQ5qxAAMmc0QxlD0VzcQbhfXt+yOTgARgUQsdms0oGYshBOucPrciDAfp8dM0FLpmpcLgB3NygprgygAeiJMAgIBqMBGIAA5llgCcYOjtmRdhA1Kt1pswVRThAspdjExajTIYjHhiqC8oHABUKRZC3PzBcKwKKzP9nMD8vjGRCoTC+XLVerEcr5WrIaiqMzMTi8TzCSSyRTTNS6Qy0bpmWy1Fh8lllGqjiRmTk8oViqVysZrCYeVNkoF8N0GL1+jQhqMtpRE+1ZvMxIsM5yNlsfSM9uZLMYAGLFKAgfL6R3qTbKPJlGsAHiwMGMAA88mBLhyY3HbPZnAA+JUx9hYELLcc2MJYNLHPVULK+Oc1oiEYhtGYpnosXWEwmbKAOfJgGBgYzYzOHYwO1TVqyr9fWwnoy9Iq8t73o+z6lps75jjWE5rhkkpOqS17Aa2zTOpMx7Jl0Z5LA+T4vtmeITJeaFUHmJ5dAskgZqB8BrGWhFbsSpIKGEEAxnBXrMqyDSwEUwCNs2iI0V2Jj1vxTb6HiOgaNA6hZkcxB8QJ+idMA7adjGbgYR0czYSE0nycYnTSu8vxfAAjPcIQ7DxZJ0dyikNhJqnqcYIlvtpBaUWg+lkBA9lGdKsoqgqZhuAArCEQA

Versions of Language/packages used in this post.


| Library/Language | Version |
| ---------------- | ------- |
| TypeScript       | 5.5.3   |
