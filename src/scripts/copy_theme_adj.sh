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

#   Preparation
# --------------------------------------------

source_folder="../../reaper/Scripts/Fleeesch/Themes/paRt"
target_folder="./themeadj"

#   Direction
# --------------------------------------------

# check for unattended mode
dir_to_dev_folder=false
while getopts "p" opt; do
    case $opt in
    p)
        dir_to_dev_folder=true
        ;;
    *) ;;
    esac
done

#   Copy Process
# --------------------------------------------

if [ "$dir_to_dev_folder" == false ]; then

    echo -en "Copying Theme Adjuster from Reaper development folder..."

    # source has to be available
    if [ ! -d "$source_folder" ]; then
        echo -e "${COLOR_RED}no Theme Adjuster found${COLOR_RESET}"
    else

        # check if source folder is empty
        if [ -z "$(ls -A "$source_folder")" ]; then
            echo -e "${COLOR_RED}Source folder is empty${COLOR_RESET}"
        else
            # clear first
            rm -rf "$target_folder"/*

            # copy
            rsync -a --quiet "$source_folder/conf/defaults.partmap" "$target_folder/conf/"
            rsync -a --quiet --exclude "conf" "$source_folder/" "$target_folder/"

            echo -e "${COLOR_GREEN}done${COLOR_RESET}"
        fi

    fi

else


    echo -en "Updating theme adjuster in development folder..."

    source_folder_bu="$source_folder"
    source_folder="$target_folder"
    target_folder="$source_folder_bu"

    # source has to be available
    if [ ! -d "$source_folder" ]; then
        echo -e "${COLOR_RED}no Theme Adjuster found${COLOR_RESET}"
    else

        # check if source folder is empty
        if [ -z "$(ls -A "$source_folder")" ]; then
            echo -e "${COLOR_RED}Source folder is empty${COLOR_RESET}"
        else
            # clear first
            rm -rf "$target_folder"/*

            # copy
            rsync -a --quiet "$source_folder/conf/defaults.partmap" "$target_folder/conf/"
            rsync -a --quiet --exclude "conf" "$source_folder/" "$target_folder/"

            echo -e "${COLOR_GREEN}done${COLOR_RESET}"
        fi

    fi

fi
