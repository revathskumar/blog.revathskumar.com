---
layout: post
title: 'PWA : receive file or text via native share'
excerpt: 'PWA : receive file or text via native share'
date: 2025-06-03 09:29 CEST
updated: 2025-06-03 09:29 CEST
categories: pwa
tags: javascript
image:
---
In this blog post, we will explore into how a PWA can receive files or text from the navite OS share functionality. By Using the `Web Share Target API`, a PWA can register with the OS as a share target and receive shared data. 

## <a class="anchor" name="updates-to-web-manifest" href="#updates-to-web-manifest"><i class="anchor-icon"></i></a>Updates to web manifest


To register the PWA as share target, we need to add `share_target` into the web manifest.

```js

  share_target: {
	action: "/share-target",
	method: "GET",
	params: {
	  text: "text",
	  title: "title",
	  url: "url"
	}
  }

```

In the above config, share target is configured to receive text data only.The `action` key specifies the endpoint which PWA can receive shared data using the `GET` method. 

We can customise the field names in which PWA can receive each data using the `params` property. 

In case of receiving files, we need to configure the `share_target` with `enctype: "multipart/form-data"` and `method: "POST"` like below. We can also configure the field name and type of file PWA can accept using the `files` property. 


```js

  share_target: {
    action: "/share-target",
    method: "POST",
    enctype: "multipart/form-data",
    params: {
      text: "text",
      title: "title",
      url: "url",
      files: [
        {
          name: "images",
          accept: ["image/jpeg", "image/png", "image/webp"],
        },
      ]
    }
  }
  
```


## <a class="anchor" name="updates-to-web-service-worker" href="#Updates-to-web-service-worker"><i class="anchor-icon"></i></a>Updates to web service worker

If the PWA `share_target` is configured with `method: "POST"`, we need to handle the request using service worker `fetch` event so that PWA can handle the file even when user is offline.


```ts
// service-worker.ts

self.addEventListener("fetch", (event: FetchEvent) => {
  const url = new URL(event.request.url)
  if (event.request.method !== "POST" || url.pathname !== "/share-target") {
    return
  }

  event.respondWith(
    (async () => {
      const formData = await event.request.formData()
      const imageFiles = formData.getAll("images") as File[]
      const text = formData.get("text") as string
      const title = formData.get("title") as string
      const url = formData.get("url") as string

	  // process the received data
	  
      return Response.redirect(`/`, 303)
    })()
  )
})

```

We can read the received data in service worker using the `event.request.formData()` like in the above snippet.

In service Worker, we won't be able to use `localStorage`, so we need to use either `IndexedDb` or query params to store the text data. 

If we want to temporarily store the files, we can use `Cache` API. 

```ts
// service-worker.ts

self.addEventListener("fetch", (event: FetchEvent) => {
  const url = new URL(event.request.url)
  if (event.request.method !== "POST" || url.pathname !== "/share-target") {
    return
  }

  event.respondWith(
    (async () => {
      const formData = await event.request.formData()
      const imageFiles = formData.getAll("images") as File[]
      const text = formData.get("text") as string
      const title = formData.get("title") as string
      const url = formData.get("url") as string

      const search = new URLSearchParams()

      if (text) {
        search.set("text", text)
      }
      if (title) {
        search.set("title", title)
      }
      if (url) {
        search.set("url", url)
      }

      if (imageFiles[0]) {
        const file = imageFiles[0] as File
        const fileName = file.name
        search.set("image", fileName)

        const ca = await caches.open("image")
        await ca.put(`/image-${fileName}`, new Response(file))
      }
      return Response.redirect(`/?${search.toString()}`, 303)
    })()
  )
})

```

In the above snippet, we are storing the image in cache and pass the cache key and other text data as query params to the destination endpoint/route.

## <a class="anchor" name="caveats" href="#caveats"><i class="anchor-icon"></i></a>Caveats

* Don't return the cached response instead of redirect from service worker fetch event.  It will trigger data submission to `/share-target` again when user refreshes the page.
* Since we are returning the redirect response, passing the text data using `postMessage` will possibly fail.
* [Browser support](https://caniuse.com/web-share) is limited.  

Hope this is helpful.  
