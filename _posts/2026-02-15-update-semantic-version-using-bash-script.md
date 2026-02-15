---
layout: post
title: update semantic version using bash script
date: 2026-02-15 13:56 CEST
updated: 2026-02-15 13:56 CEST
categories: bash
tags:
- bash
- shell
- github
- github-actions
- zig
image: ''
---
For all of my JavaScript projects, I depend on the `npm version` command to update the version number for generating a release. So when I wanted to release [my Zig project (clipz)](https://codeberg.org/0x52534B/clipz){: rel="nofollow"}, I was looking for something similar to update the version number in the `build.zig.zon` file.

Since Zig doesn't have any command equivalent to `npm version`, I decided to go with a simple shell script.

<!--excerpt ends-->

## <a class="anchor" name="the-bash-script" href="#the-bash-script"><i class="anchor-icon"></i></a>The bash script

```sh
#!/bin/bash

# version.sh
# USAGE : ./version.sh <major|minor|patch>

current_version=$(grep -oP '\.version = "\K[^"]+' build.zig.zon)

IFS='.' read -r major minor patch <<< "$current_version"
case "$1" in
  major) major=$((major + 1)); minor=0; patch=0 ;;
  minor) minor=$((minor + 1)); patch=0 ;;
  patch) patch=$((patch + 1)) ;;
esac
new_version="$major.$minor.$patch"

sed -i "s/\.version = \"[^\"]*\"/.version = \"$new_version\"/" build.zig.zon
echo $new_version

```

The above script will read the version from `build.zig.zon` file and update the version number based on the argument.

```sh
./version.sh patch
```

Now I can use this in my GitHub actions like

{% highlight yml %}
{% raw %}
name: Generate Release

on:
  workflow_dispatch:
    inputs:
      release_type:
        description: "Select release type"
        required: true
        default: "patch"
        type: choice
        options:
          - patch
          - minor
          - major

jobs:
  x86_64-linux-gnu:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      # other steps
      - name: Update version in build.zig.zon
        id: update-version
        run: |
          new_version=$(./version.sh ${{ github.event.inputs.release_type }})
          # Commit the change
          # add git tag
          # push the changes
          echo "new_version=$new_version" >> $GITHUB_ENV
          echo "new_version=$new_version" >> $GITHUB_OUTPUT
{% endraw %}
{% endhighlight %}

## <a class="anchor" name="Using-new-version-number-in-subsequent-steps" href="#Using-new-version-number-in-subsequent-steps"><i class="anchor-icon"></i></a>Using new version number in subsequent steps


Now in the subsequent steps, we can use `$new_version` in the shell scripts like

```yaml
     - name: Build
       run: |
          # build command
          mv ./zig-out/bin/clipz{,"-$new_version"}

```

or use from the step output like

{% highlight yml %}
{% raw %}

- name: Generate artifact attestation
  uses: actions/attest-build-provenance@v3
  with:
   subject-path: "./zig-out/bin/clipz-${{ steps.update-version.outputs.new_version }}"

{% endraw %}
{% endhighlight %}

You can see the [changes](https://codeberg.org/0x52534B/clipz/commit/2cc642ca3a445d1cc62dd44d2428e198230bebc2){: rel="nofollow"} in the clipz repo.

Hope this is helpful.
