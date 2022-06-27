---
layout: post
title: 'Alfred : workflow to simulate keyboard input'
excerpt: 'Alfred : workflow to simulate keyboard input'
date: 2022-06-26 18:15 +0530
updated: 2022-06-26 18:15 +0530
categories: rails
tags: alfred
---

Some web applications, especially certain banking applications won't allow you to copay and paste the text into input forms. In such cases, you might need to enter the text manually or find some way to simulate the keyboard text input. 

Using the Alfred app, you can add a custom workflow to simulate text input. This blog explains how you can create a custom workflow.


## <a class="anchor" name="create-new-workflow" href="#create-new-workflow"><i class="anchor-icon"></i></a>1. Create a new workflow

You can start by creating a new workflow from `Alfred preferences` -> `Workflows` and fill in the basic details about the workflow.

{: style="text-align: center"}
![basic details of workflow](/assets/images/simulate_keyboard_input/new-workflow.webp){: style="width: 100%"}

## <a class="anchor" name="add-new-universal-action" href="#add-new-universal-action"><i class="anchor-icon"></i></a>2. Add new universal action

Right-click and add new universal action. Please give it a name and choose which types this action should show for. In most cases, you will need only text but feel free to select as per your requirement.

{: style="text-align: center"}
![new universal action](/assets/images/simulate_keyboard_input/add-as-universal-action.webp){: style="width: 100%"}

## <a class="anchor" name="add-action-to-run-applescript" href="#add-action-to-run-applescript"><i class="anchor-icon"></i></a>3. Add action to run AppleScript

Once the universal action is saved, Again right click and add action to `run NSAppleAcript`. 

{: style='text-align: center'}
![add action](/assets/images/simulate_keyboard_input/add-action.webp){: style='width: 100%'}

This will prompt a new window where you add the following snippet.

```
on alfred_script(q)
  tell application "System Events" to keystroke q
end alfred_script
```

{: style='text-align: center'}
![fill-action-content](/assets/images/simulate_keyboard_input/fill-action-content.webp){: style='width: 100%'}

Save it and your workflow is ready. Make sure you enable the workflow before try out.   
Please note that this snippet won't handle the newlines, hence best work for single-line texts.

## <a class="anchor" name="use-text-action" href="#use-text-action"><i class="anchor-icon"></i></a>4. Use the text action with Alfred

Now in Alfred, pick any text from clipboard history or snippet and trigger text actions (Normally right arrow), you can see your new text action.

{: style='text-align: center'}
![use workflow via text action](/assets/images/simulate_keyboard_input/text-action-on-text.webp){: style='width: 100%'}

## <a class="anchor" name="download" href="#download"><i class="anchor-icon"></i></a>5. Download workflow from GitHub

Alternatively, you can download the workflow from [GitHub](https://github.com/revathskumar/alfred-simulate-keyboard) as well.
