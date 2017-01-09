#!/bin/bash

# $ sonics folder "effects"
# ex: $ sonics originals "echo 0.5 0.5 0.5 0.5"


INPUT_FILE=$1

if [[ -d "$2" ]]; then
    cd "$2"
    PRESETS_FILE="$(pwd -P)"
else 
    cd "$(dirname "$2")"
    PRESETS_FILE="$(pwd -P)/$(basename "$2")"
fi

while read FX
	do 
	EXPORT_FOLDER=$(echo $FX | tr ' ' '_' | tr '.' '_'  | tr '-' '_')
	sonictiff $INPUT_FILE $EXPORT_FOLDER "$FX"
done < $PRESETS_FILE

echo "Done"

if [ "$(uname)" == "Darwin" ]; then
	osascript -e 'display notification "Process done!" with title "Sonics"'     
fi

