#!/bin/bash

cd "$(dirname $0)"

clear=0

while true; do
    read -p 'Want to clear output folders? Type "clear" ' yn
    case $yn in
        "clear" ) clear=1; break;;
        * ) break;;
    esac
done

if [ "$clear" -eq 1 ]; then

    find . -type d -name out -exec rm -rf {} \; 2>/dev/null

fi

find . -name *out*make*.sh -type f -exec bash {} \;

echo
echo -----------------------------------
echo :       All done!
echo -----------------------------------
echo
echo Press any key to close...

read -p ""