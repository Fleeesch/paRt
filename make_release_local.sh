#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Preparation
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

source ./release_tools.sh

SetupEnvVariables

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Binaries
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# clear previous stuff
ClearReleaseFolder
ClearTempFiles

# create binaries
CreateBinaries

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   ReaPack Theme File
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# --------------------------------------
#   Constructing theme file
# --------------------------------------
echo -n Constructing Theme file...

LoadReaPackVariables

# store paths
theme_file_name="part.theme"
reapack_folder="$TMP_FOLDER/rp"
reapack_theme_file="$reapack_folder/$theme_file_name"
reapack_prov_file="./$RP_FOLDER/provides"
script_path="./src/scripts"
theme_scripts_name="paRt Scripts"
reapack_release_folder="$REL_FOLDER/$REL_TAG/reapack"

# create directories
mkdir -p "$TMP_FOLDER"
mkdir -p "$reapack_folder"

# @description
if [ -n "$RP_DESC" ]; then
    echo -e "$RP_DESC" >$reapack_theme_file
fi

# @version
if [ -n "$RP_VER" ]; then
    echo -e "@version $RP_VER" >>$reapack_theme_file
fi

# @author
if [ -n "$RP_AUTH" ]; then
    echo -e "$RP_AUTH" >>$reapack_theme_file
fi

# @about
if [ -n "$RP_ABOUT" ]; then
    echo -e "$RP_ABOUT" >>$reapack_theme_file
fi

# @provides
if [ -n "$RP_PROV" ]; then
    
    echo -e "$RP_PROV" >>$reapack_theme_file
fi

# @link
if [ -n "$RP_LINK" ]; then
    echo -e "$RP_LINK" >>$reapack_theme_file
fi

# @screenshot
if [ -n "$RP_SSHOT" ]; then
    echo -e "$RP_SSHOT" >>$reapack_theme_file
fi

# changelog
if [ -n "$RP_CHANGE" ]; then
    echo -e "@changelog\n$RP_CHANGE" >>$reapack_theme_file
fi

# make release theme folder
mkdir -p "$reapack_release_folder"

# copy the created theme file
\cp -f "$reapack_theme_file" "$reapack_release_folder/$theme_file_name"

echo done

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Cleanup
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

ClearTempFiles
