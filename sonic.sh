#!/bin/bash

# $ source.jpg export_folder "effects"
# ex: $  img.jpg exports "echo 0.5 0.5 0.5 0.5"

if [[ -d "$1" ]]; then
    cd "$1"
    FILEPATH="$(pwd -P)"
else 
    cd "$(dirname "$1")"
    FILEPATH="$(pwd -P)/$(basename "$1")"
fi

# INTERNALS
SIZE=$(identify -ping -format '%wx%h' $FILEPATH 2>&1)
EXPORT_FOLDER=$(dirname $(dirname "$FILEPATH"))'/'$2 #This is super ugly
FILENAME=$(basename "$FILEPATH")
EXTENSION="${FILENAME##*.}"
FILENAME="${FILENAME%.*}"

# FX paramas
ENCODING="unsigned-integer" #u-law
FX=${3-echo 1 1 1 1}

# CHECK IF FOLDER
if [ ! -d $EXPORT_FOLDER ]; then
  echo "Directory $EXPORT_FOLDER was created"
  mkdir -p $EXPORT_FOLDER;
fi

echo "Processing ... $FILENAME with $FX"

# MAGIC
convert jpg:$FILEPATH rgb:- | sox --type raw --bits 8 --encoding $ENCODING --channels 1 --rate 44.1k - --type raw - $FX | convert -depth 8 -size $SIZE rgb:- jpg:$EXPORT_FOLDER/$FILENAME.jpg

echo "Output result saved on $EXPORT_FOLDER/$FILENAME.jpg"