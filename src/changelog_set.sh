#!/bin/bash

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Preparation
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# file declarations
changelog_file="rel/changelog"
changelog_file_edit="rel/changelog-edit.txt"

# cleanup
rm -f $changelog_file_edit

# Create and empty changelog file if one doesn't exist
if [ ! -f "$changelog_file" ]; then
    touch "$changelog_file"
fi

cp $changelog_file $changelog_file_edit

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Process
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

echo "Opening changelog file..."

# look for operating system
case "$OSTYPE" in
"cygwin"*)
    # Cygwin
    changelog_file_converted=$(cygpath -w "$changelog_file_edit")
    start $changelog_file_converted
    ;;
"msys"*)
    # MSYS
    changelog_file_converted=$(cygpath -w "$changelog_file_edit")
    start $changelog_file_converted
    ;;
*)
    # Unix
    ./"$changelog_file_edit"
    ;;
esac

# assume changes won't be stored by default
store_changes=0

# save prompt
while true; do
    
    read -p "Store new changelog? [y] " userInput
    
    # Check if the user input is 'y'
    if [ "$userInput" = "y" ]; then
        # Exit the loop and continue with your script
        store_changes=1
        break
    else
        break
    fi
    
done

# store changes
if [ "$store_changes" -eq "1" ]; then
    
    cp $changelog_file_edit $changelog_file

fi

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Cleanup
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# cleanup
rm -f $changelog_file_edit
