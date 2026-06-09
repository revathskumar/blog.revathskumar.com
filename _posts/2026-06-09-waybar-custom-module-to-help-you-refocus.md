---
layout: post
title: "waybar: custom module to help you refocus"
date: 2026-06-09 19:27 CEST
updated: 2026-06-09 19:27 CEST
categories: bash
tags: bash waybar
image: ""
---

Couple of months ago when I read the post [How I hacked my clock to control my focus](https://www.paepper.com/blog/posts/how-i-hacked-my-clock-to-control-my-focus.md/?ref=blog.revathskumar.com){: target="_blank" rel="nofollow" } by Marc Päpper, It quickly became a daily driver for me. This small hack using a shell script helped me to get back to work quickly when ever I get distracted.

I quickly realized that I needed something comparable with waybar after moving to Hyprland. 

<!--excerpt ends-->

## <a class="anchor" name="Custom Module" href="#custom-module"><i class="anchor-icon"></i></a>Custom Module

I want the module to be dead simple and use only the basic unix tools I already have. Hence, I decided to store the text in a separate file and read the contents to display on waybar.

That way I can ignore the file from my dotfiles and update the text easily without any parsing overhead.

```json
{ 
   "custom/focus": {
      "format": "<span color='#ff6699'><b> Focus: {}</b></span>",
      "exec": "cat ~/.config/waybar/.focus",
      "signal":8,
   }
}
```

Create a script named `waybar-focus.sh` with the below content.

```sh
#!/bin/bash
set -e -o pipefail

# Set focus text from command line argument or prompt user
if [ -z "$1" ]; then
  echo "What's your current focus?"
  read FOCUS
else
  FOCUS="$1"
fi

if [ -z "$FOCUS" ]; then
  echo -e "" > ~/.config/waybar/.focus 
else
  echo -e "Focus: $FOCUS" > ~/.config/waybar/.focus 
  notify-send "Focus: $FOCUS"
fi

pkill -SIGRTMIN+8 waybar

echo "Focus set to: $FOCUS"
```

You can make this file executable and add to `$PATH`.  This is an adapted version of Marc Päpper's `focus.sh`. 
## <a class="anchor" name="Update custom module using signal" href="#update-custom-module-using-signal"><i class="anchor-icon"></i></a>Update custom module using signal

In the initial version of the script, I was using `killall -SIGUSR2 waybar` to restart the waybar after the update. Soon I realized this is overkill and started looking for ways I can update the module without killing and respawning waybar.

Since module content is always updated manually, watching the file or using `interval` config seems overkill as well. Then I found the `signal` option in the [config for custom modules](https://github.com/Alexays/Waybar/wiki/Module:-Custom) 

> The signal number used to update the module. The number is valid between 1 and N, where `SIGRTMIN+N` = `SIGRTMAX`.

In the above module config we use `"signal":8,` and in the script we use

```sh
pkill -SIGRTMIN+8 waybar
```

This way the latest entry will show up on the waybar instantly and without any overhead of watching the file or polling.

Hope this is helpful.  
  
Versions of Language/packages used in this post.

| Library/Language    | Version            |
| ------------------- | ------------------ |
| waybar              | v0.12.0-1          |
| OS                  | Debian 13 (trixie) |
{: style="width:100%"}
