#!/bin/bash

TEXT=$1
# write text to /root/text.txt
echo $TEXT > ./text.txt

# start set-text.py if it is not running
if ! pgrep -f set-text.py; then
  python3 ./set-text.py &
fi