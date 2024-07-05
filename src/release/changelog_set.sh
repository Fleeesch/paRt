#!/bin/bash

#   Colors
# --------------------------------------------

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[0;33m'
COLOR_BLUE='\033[0;34m'
COLOR_MAGENTA='\033[0;35m'
COLOR_CYAN='\033[0;36m'
COLOR_WHITE='\033[0;37m'
COLOR_ORANGE='\033[0;33m'
COLOR_RESET='\033[0m'

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Preparation
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# file declarations
changelog_file="changelog"
changelog_file_edit="changelog-edit.txt"

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

echo -e "${COLOR_RESET}Opening changelog file..."

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
    
    echo -e "${COLOR_YELLOW}Press ${COLOR_RESET}(y) ${COLOR_YELLOW}to store new changelog ${COLOR_RESET}"
    read -n 1 choice
    echo ""

    case "$choice" in
        y|Y) store_changes=1;;    
    esac

    break

    
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
