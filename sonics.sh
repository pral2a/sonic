#!/bin/bash

# $ sonics folder "effects"
# ex: $ sonics originals "echo 0.5 0.5 0.5 0.5"


INPUT_FOLDER=$1
FX=$2
DOVIDEO=$4
PROCESS=${3:-"u-law"}
EXPORT_FOLDER="$(echo $PROCESS | tr ',' '_' | tr ' ' '_' | tr '.' '_'  | tr '-' '_')_$(echo $FX | tr ',' '_' | tr ' ' '_' | tr '.' '_'  | tr '-' '_')"

find $INPUT_FOLDER -type f -not -name ".DS_Store" | parallel sonicnew '{}' $EXPORT_FOLDER \"$FX\" \"$PROCESS\"

if [ "$DOVIDEO" == "video" ]; then
	
	if [[ -d "$1" ]]; then
	    cd "$1"
	    INPUT_FOLDER_ABS="$(pwd -P)"
	else 
	    cd "$(dirname "$1")"
	    INPUT_FOLDER_ABS="$(pwd -P)/$(basename "$1")"
	fi

	PARENT_FOLDER=$(dirname "$INPUT_FOLDER_ABS")

	VIDEO_FOLDER=$PARENT_FOLDER'/video'

	# CHECK IF FOLDER
	if [ ! -d $VIDEO_FOLDER ]; then
	  mkdir -p $VIDEO_FOLDER;
	fi	   

	VIDEO_FILE=$VIDEO_FOLDER/$EXPORT_FOLDER'.mp4'

	ffmpeg -pattern_type glob -i $PARENT_FOLDER'/'$EXPORT_FOLDER'/*.tiff' -framerate 25 $VIDEO_FILE

	# OPEN FILE IN MAC
	open -a /Applications/VLC.app $VIDEO_FILE

fi

echo "Done in $EXPORT_FOLDER"

if [ "$(uname)" == "Darwin" ]; then
	osascript -e 'display notification "Process done!" with title "Sonics"'     
fi
