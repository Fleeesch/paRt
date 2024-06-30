#!/bin/bash

echo -e "- - - - - - - - - - - - - - - - - - - - - - - - - - - - -  "
echo -e "    Reaper toolbar icon modification utility               "
echo -e "- - - - - - - - - - - - - - - - - - - - - - - - - - - - -  "
echo
echo -n Restoring Original V6 Icon Order... 

# restore original file structure
rsync -r "./original/v6/" "./original/v3/"

# clear emtpied v6 icon folder
rm -r "./original/v6"

# create v6 folders again
mkdir -p ./original/v6/100
mkdir -p ./original/v6/150
mkdir -p ./original/v6/200

echo done

echo -n Sorting V6 Icons... 

# go through sort list
while read bitmap
do
file="${bitmap/$'\r'/}"

# move v6 files to dedicated folder
mv -f "./original/v3/100/$file" "./original/v6/100/" 2>/dev/null
mv -f "./original/v3/150/$file" "./original/v6/150/" 2>/dev/null
mv -f "./original/v3/200/$file" "./original/v6/200/" 2>/dev/null

done < "v6_files"

echo done

echo
echo -e "   > Sorting done, creating modified assets..."
echo

# icon creation script
python make_icons.py
