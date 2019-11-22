#!/bin/bash

## How to: ./files_to_utf8.sh path/to/folder/ intitial_encoding
## e.g. ./files_to_utf8.sh lib/data/species/mangroves/ ISO-8859-1
## Converted files will be within the utf8 folder within the directory initially specified.
## Make sure iconv is installed in your machine.

DIR=$1
ENCODING=$2

# Create dir where to store new files
mkdir -p "${DIR}utf8"

for file in $DIR*; do
  [ -e "$file" ] || continue

  # Proceed only if current file is actually a file, not a folder
  if [ -f "$file" ]; then

    echo $file

    filename=$(basename -- "$file")
    extension="${filename#*.}"
    filename="${filename%.*}"

    iconv -f $ENCODING -t UTF-8 $file > "${DIR}utf8/${filename}-utf8.${extension}"
  fi
 done
