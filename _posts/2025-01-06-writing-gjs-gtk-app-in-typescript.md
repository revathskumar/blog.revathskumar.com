---
layout: post
title: writing gjs gtk app in typescript
excerpt: writing gjs gtk app in typescript
date: 2025-01-06 14:00 CEST
updated: 2025-01-10 18:00 CEST
categories: typescript
tags:
  - typescript
  - gjs
  - gtk4
  - adwaita
image: "/assets/images/gjs-typescript/basic-window.webp"
---
Recently I wanted to write a small GTK utility for personal use, and I was looking into writing it in TypeScript. The [Gnome Builder](https://apps.gnome.org/en-GB/Builder/) bootstraps in JavaScript, so I was exploring the ways which I can set up the project without Gnome builder.

In case you want to skip all the manual steps, and want to bootstrap the application (including packaging) in single command you can skip to [Bootstrap using create-gtk](#bootstrap-using-create-gtk) after installing the system dependencies.

## Install dependencies<a class="anchor" name="install-dependencies" href="#install-dependencies"><i class="anchor-icon"></i></a>

I am using `Debian 12 (bookworm)` I installed the GTK and other system dependencies using `apt-get`.

```sh
sudo apt-get install libgtk-4-dev pkg-config meson gjs libadwaita-1-dev
```

`libadwaita-1-dev` is required only if you are planning to use `Adwaita` widgets.

## Setup typescript project<a class="anchor" name="setup-typescript-project" href="#setup-typescript-project"><i class="anchor-icon"></i></a>

As usual, I start to set up the project by

```sh
mkdir example-gtk
cd example-gtk
npm init -y
```

and install the NPM dependencies like

```sh
npm i -D typescript esbuild
```

In order to set up the types of gjs, we can use 

```sh
npm i -D @girs/gtk-4.0 @girs/adw-1 @girs/gjs
```

If you prefer to generate the types, you can use `generate` command from NPM package `@ts-for-gir/cli` 

The `tsconfig.json` will look like

```json
{
  "compilerOptions": {
    "types": ["@girs/gjs", "@girs/adw-1"],
    "lib": ["ES2024", "DOM"],
    "target": "ES2024",
    "module": "NodeNext",
    "moduleResolution": "node16",
    "resolveJsonModule": true,
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "noImplicitThis": true,
    "alwaysStrict": true
  },
  "include": ["src"]
}

```

Now we can set up an entry point for our application.

```ts
// src/index.ts

import Gio from "gi://Gio";
import Adw from "gi://Adw?version=1";
import GObject from "gi://GObject";
import Gtk from "gi://Gtk";

class _Application extends Adw.Application {
  constructor(
    constructProperties = {
      application_id: "com.<user>.<project.name>",
      flags: Gio.ApplicationFlags.FLAGS_NONE,
    }
  ) {
    super(constructProperties);

    const quit_action = new Gio.SimpleAction({ name: "quit" });
    quit_action.connect("activate", (action) => {
      this.quit();
    });
    this.add_action(quit_action);
    this.set_accels_for_action("app.quit", ["<primary>q"]);
  }

  override vfunc_activate() {
    super.vfunc_activate();
    let win = this.active_window;
    if (!win) {
      win = new Gtk.Window({
        title: "<project.name>",
        default_width: 800,
        default_height: 800,
        application: this,
      });
    }

    win.present();
  }
}

/** Main Application class */
const Application = GObject.registerClass(
  {
    GTypeName: "Application",
  },
  _Application
);

/** Run the main application */
const main = () => {
  const app = new Application();
  app.run([imports.system.programInvocationName].concat(ARGV));
};
main();
```
## Setup build<a class="anchor" name="setup-build" href="#setup-build"><i class="anchor-icon"></i></a>

I use `esbuild` to build the typescript application. The basic configuration is given below. The target can be set based on the gjs version, a reference is given along with the esbuild configuration. [Support for sourcemap](https://gitlab.gnome.org/GNOME/gjs/-/merge_requests/938) has recently merged with Gnome 48, but since it is not available to me, I will skip this option.

```js
// esbuild.js

import { build } from "esbuild";

await build({
  entryPoints: ["src/index.ts"],
  outdir: "dist/",
  bundle: true,
  // target: "firefox60", // Since GJS 1.53.90
  // target: "firefox68", // Since GJS 1.63.90
  // target: "firefox78", // Since GJS 1.65.90
  // target: "firefox91", // Since GJS 1.71.1
  // target: "firefox102", // Since GJS 1.73.2
  target: "firefox115", // Since GJS 1.77.2
  format: "esm",
  external: ["gi://*"],
});


```

Now we can run `node esbuild.js` to build our application.

If the build is successful, we can use the following command to check that the application is running without errors.

```sh

gjs -m "dist/index.js"

```

We can enable debug logging using the ENV variable, `G_MESSAGES_DEBUG`.

```sh
G_MESSAGES_DEBUG=all gjs -m "dist/index.js"
```

{: style="text-align: center"}
![basic GTK window in gjs](/assets/images/gjs-typescript/basic-window.webp){: style='width: 100%'}
## Bootstrap using create-gtk<a class="anchor" name="bootstrap-using-create-gtk" href="#bootstrap-using-create-gtk"><i class="anchor-icon"></i></a>

In order to avoid doing all the above steps manually, 
I wrote a NPM initializer [create-gtk](https://www.npmjs.com/package/create-gtk) to bootstrap gjs GTK4 apps with some defaults.

You can use it by running the command

```sh
npx create-gtk <project-name>
```

This will initialize the gjs GTK4 project with TypeScript & esbuild. 

Now we can run the following commands to build

```sh
npm i
npm run build
chmod +x bin/<project-name>
```

and test run the newly bootstrapped application using 

```sh
./bin/<project-name>
```

The bootstrapped application will use `Adwaitda` widgets, and will have a title bar, menubar, about window & sample code for toast messages.  
Packaging instructions will be available in the generated README.  
  
The create-gtk code is available at https://github.com/revathskumar/create-gtk.  

Helpful Links & Honourable Mentions

* [https://gjs.guide/guides/](https://gjs.guide/guides/)
* [https://rmnvgr.gitlab.io/gtk4-gjs-book/](https://rmnvgr.gitlab.io/gtk4-gjs-book/)
* [https://github.com/gjsify/example-gtk4](https://github.com/gjsify/example-gtk4) by Pascal Garber.
* [https://github.com/gjsify/ts-for-gir/](https://github.com/gjsify/ts-for-gir/)
* [https://gjsify.org/pages/projects](https://gjsify.org/pages/projects)

Hope this is helpful.

Versions of Language/packages used in this post.
  
| Library/Language | Version       |
| ---------------- | ------------- |
| Debian           | 12 (bookworm) |
| Gtk              | 4             |
| libgtk-4-dev     | 4.8.3         |
| meson            | 1.0.1         |
| gjs              | 1.74.2        |
| libadwaita-1-dev | 1.2.2-1       |
| TypeScript       | 5.7.2         |
