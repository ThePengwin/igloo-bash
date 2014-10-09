#!/bin/bash

# igloo linux script
# By ThePengwin
# Use how you wish!

#required programs
hash scrot 2>/dev/null || { echo >&2 "I require scrot but it's not installed.  Aborting."; exit 1; }
hash notify-send 2>/dev/null || { echo >&2 "I require notify-send but it's not installed.  Aborting."; exit 1; }
hash xclip 2>/dev/null || { echo >&2 "I require xclip but it's not installed.  Aborting."; exit 1; }

#default opts
filetype="jpg"
scrotopts=""

# working out options
#
# -w current window
# -s selection of desktop
# -d desktop mode (f will be for a file)
# neither w or s = full screen
# -j Jpeg mode
# -p PNG mode
# neither = png mode

while getopts wsdpj opt; do
  case $opt in
    w)
      scrotopts="-ub"
      ;;
    s)
      scrotopts="-s"
      ;;
    d)
      scrotopts=""
      ;;
    p)
      filetype="png"
      ;;
    j)
      filetype="jpg"
      ;;
  esac
done

#things that dont change
tempdir="/tmp"
date=$(date '+%Y-%m-%d %H:%I:%S')

if [ -r ~/.igloo.conf ]; then
  . ~/.igloo.conf
else 
  echo >&2 "Igloo is not configured properly";
  exit 1;
fi

#file that scrot will make
file="$tempdir/Screenshot $date.$filetype"
#command to invoke scrot
cmd="scrot $scrotopts \"$file\""
#do it!
eval $cmd
scrotret=$?

#something fail?
if [ $scrotret -ne 0 ]; then
    echo "Screenshot failed!"
    exit 1
fi

#tell the user that we are going to upload
notify-send --icon=up "Upload" "Uploading \"$file\""

#upload and store results
igloovar=$(curl "$IGLOO_SERVER" -F "k=$IGLOO_KEY" -F "file=@$file")
#and return code
iglooret=$?

#no matter what, remove the file
rm "$file"

#curl failed hard, so warn user
if [ $iglooret -ne 0 ]; then
		notify-send --icon=up "Upload Failed!" "I dunno what happened, cURL went bad!"
    exit 1
fi
if [ -z "$igloovar" ]; then
    notify-send --icon=up "Upload Failed!" "No URL Returned"
    exit 1
fi

#if we get here then we should be good!

#using xclip, add the url to the clipboard (-n for no newline)
echo -n "$igloovar" | xclip -selection clipboard

#and make a toast
notify-send --icon=up "Success!" "URL: $igloovar \n URL added to clipboard!"

