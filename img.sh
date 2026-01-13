#!/bin/bash

# depends on libwebp package

directory="${1%/}"
if command -v img2webp >/dev/null 2>&1 ; then
    echo "img2webp found"
    echo "version: $(img2webp -version)"
else
    echo "img2webp not found"
    exit 1;
fi

for file in "$directory"/*.{png}
do
  echo "$file"
  outfile="${file//.png/.webp}"
#  outfile="${file//.jpg/.webp}"

  if img2webp "$file" -o "$outfile"; then
    echo "conversion: success!"
  else
    echo "conversion: failure!"
  fi
done
