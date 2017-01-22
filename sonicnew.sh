#!/bin/bash

# $ source.jpg export_folder "effects”
# ex: $  img.jpg exports "echo 0.5 0.5 0.5 0.5”

if [[ -d "$1" ]]; then
    cd "$1"
    FILEPATH="$(pwd -P)"
else 
    cd "$(dirname "$1")"
    FILEPATH="$(pwd -P)/$(basename "$1")"
fi

# INTERNALS
SIZE=$(identify -ping -format '%wx%h' $FILEPATH 2>&1)
DEPTH=$(identify -ping -format '%z' $FILEPATH 2>&1)
PROCESSDEPTH=8
EXPORT_FOLDER=$(dirname $(dirname "$FILEPATH"))'/'$2 #This is super ugly and needs to be changed
FILENAME=$(basename "$FILEPATH")
EXTENSION="${FILENAME##*.}"
FILENAME="${FILENAME%.*}"

# FX paramas
ENCODING="u-law" #unsigned-integer OR u-law
FX=${3-echo 1 1 1 1}

# CHECK IF FOLDER
if [ ! -d $EXPORT_FOLDER ]; then
  echo "Directory $EXPORT_FOLDER was created"
  mkdir -p $EXPORT_FOLDER;
fi

echo "$DEPTH"

if [ "$DEPTH" -gt "8" ]; then
   echo "Converting $FILENAME to 8 bits ..."
   mogrify -depth 8 -format $EXTENSION $FILENAME.$EXTENSION
fi


echo "Processing ... $FILENAME with $FX"

# MAGIC
convert $EXTENSION:$FILEPATH rgb:- | sox --type raw --bits $PROCESSDEPTH --encoding $ENCODING --channels 1 --rate 44.1k - --type raw - $FX | convert -depth $DEPTH -size $SIZE rgb:- $EXTENSION:$EXPORT_FOLDER/$FILENAME.$EXTENSION

echo "Output result saved on $EXPORT_FOLDER/$FILENAME.tiff"
