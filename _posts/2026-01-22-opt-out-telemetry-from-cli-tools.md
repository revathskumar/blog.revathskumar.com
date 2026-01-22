---
layout: post
title: opt-out telemetry from cli tools
excerpt: opt-out telemetry from cli tools
date: 2026-01-22 06:32 CEST
updated: 2026-01-11 06:32 CEST
categories: cli
tags: telemetry cli
image: ''
---
As most of the CLI tools/JavaScript frameworks started collecting telemetry data by default, I started looking into how I could easily opt out from these.

Many of the tools support disabling the telemetry via environment variables.

I therefore decided to compile these `env` variables from the various tools and frameworks in one place.

```sh
# telementry.fish

# https://bun.com/docs/runtime/bunfig#telemetry
set DO_NOT_TRACK 1

# https://learn.microsoft.com/en-us/dotnet/core/tools/telemetry?tabs=dotnet10#how-to-opt-out
set DOTNET_CLI_TELEMETRY_OPTOUT 1

# https://astro.build/telemetry/
set ASTRO_TELEMETRY_DISABLED 1

# https://nextjs.org/telemetry
set NEXT_TELEMETRY_DISABLED 1

# https://www.prisma.io/docs/orm/tools/prisma-cli#telemetry
set CHECKPOINT_DISABLE 1

# https://github.com/nuxt/telemetry
set NUXT_TELEMETRY_DISABLED 1

# https://github.com/cloudflare/workers-sdk/blob/main/packages/wrangler/telemetry.md#how-can-i-configure-wrangler-telemetry
set WRANGLER_SEND_METRICS false

# https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/telemetry.md
set GEMINI_TELEMETRY_ENABLED false

# https://docs.expo.dev/more/expo-cli/#telemetry
set EXPO_NO_TELEMETRY 1

```

This is the list so far, I am planning to keep updating this list on the codeberg repository [cli-telemetry](https://codeberg.org/0x52534B/cli-telemetry/) as I discover more.

The [guide for zsh](https://cli-telemetry.revathskumar.workers.dev/guides/zsh/) is also available.

Suggestions and inputs are always welcome.

Hope this is helpful.  
Thank you.